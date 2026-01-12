"""
Authentication Lambda Handler for NDMR API
Handles: /auth/register, /auth/login, /auth/refresh, /auth/me
"""
import json
import os
import uuid
import hashlib
import hmac
import base64
import time
import secrets
from datetime import datetime, timedelta
import boto3
from botocore.exceptions import ClientError

# Environment variables
USERS_TABLE = os.environ.get('USERS_TABLE')
REFRESH_TOKENS_TABLE = os.environ.get('REFRESH_TOKENS_TABLE')
JWT_SECRET = os.environ.get('JWT_SECRET', 'dev-secret-change-me')
JWT_EXPIRY_MINUTES = int(os.environ.get('JWT_EXPIRY_MINUTES', '60'))
REFRESH_EXPIRY_DAYS = int(os.environ.get('REFRESH_EXPIRY_DAYS', '30'))

dynamodb = boto3.resource('dynamodb')
users_table = dynamodb.Table(USERS_TABLE) if USERS_TABLE else None
refresh_tokens_table = dynamodb.Table(REFRESH_TOKENS_TABLE) if REFRESH_TOKENS_TABLE else None

CORS_HEADERS = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type,Authorization',
    'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
    'Content-Type': 'application/json'
}


def response(status_code, body):
    """Create HTTP response"""
    return {
        'statusCode': status_code,
        'headers': CORS_HEADERS,
        'body': json.dumps(body)
    }


def hash_password(password: str, salt: str = None) -> tuple:
    """Hash password with PBKDF2"""
    if salt is None:
        salt = secrets.token_hex(16)
    key = hashlib.pbkdf2_hmac('sha256', password.encode(), salt.encode(), 100000)
    return base64.b64encode(key).decode(), salt


def verify_password(password: str, hashed: str, salt: str) -> bool:
    """Verify password against hash"""
    new_hash, _ = hash_password(password, salt)
    return hmac.compare_digest(new_hash, hashed)


def create_jwt(payload: dict, expiry_minutes: int = None) -> str:
    """Create a simple JWT token"""
    if expiry_minutes is None:
        expiry_minutes = JWT_EXPIRY_MINUTES

    header = {'alg': 'HS256', 'typ': 'JWT'}
    payload['exp'] = int(time.time()) + (expiry_minutes * 60)
    payload['iat'] = int(time.time())

    def b64_encode(data):
        return base64.urlsafe_b64encode(json.dumps(data).encode()).rstrip(b'=').decode()

    header_b64 = b64_encode(header)
    payload_b64 = b64_encode(payload)
    message = f"{header_b64}.{payload_b64}"

    signature = hmac.new(
        JWT_SECRET.encode(),
        message.encode(),
        hashlib.sha256
    ).digest()
    signature_b64 = base64.urlsafe_b64encode(signature).rstrip(b'=').decode()

    return f"{message}.{signature_b64}"


def decode_jwt(token: str) -> dict:
    """Decode and verify JWT token"""
    try:
        parts = token.split('.')
        if len(parts) != 3:
            return None

        header_b64, payload_b64, signature_b64 = parts

        # Verify signature
        message = f"{header_b64}.{payload_b64}"
        expected_sig = hmac.new(
            JWT_SECRET.encode(),
            message.encode(),
            hashlib.sha256
        ).digest()
        expected_sig_b64 = base64.urlsafe_b64encode(expected_sig).rstrip(b'=').decode()

        if not hmac.compare_digest(signature_b64, expected_sig_b64):
            return None

        # Decode payload
        padding = 4 - len(payload_b64) % 4
        if padding != 4:
            payload_b64 += '=' * padding
        payload = json.loads(base64.urlsafe_b64decode(payload_b64))

        # Check expiry
        if payload.get('exp', 0) < time.time():
            return None

        return payload
    except Exception:
        return None


def get_user_from_token(event) -> dict:
    """Extract and verify user from Authorization header"""
    auth_header = event.get('headers', {}).get('authorization', '')
    if not auth_header.startswith('Bearer '):
        return None

    token = auth_header[7:]
    payload = decode_jwt(token)
    if not payload:
        return None

    return payload


def handle_register(event):
    """POST /auth/register"""
    try:
        body = json.loads(event.get('body', '{}'))
    except json.JSONDecodeError:
        return response(400, {'detail': 'Invalid JSON'})

    email = body.get('email', '').lower().strip()
    password = body.get('password', '')
    callsign = body.get('callsign', '').upper().strip() or None

    # Validation
    if not email or '@' not in email:
        return response(400, {'detail': 'Valid email is required'})
    if len(password) < 8:
        return response(400, {'detail': 'Password must be at least 8 characters'})

    # Check if user exists
    try:
        existing = users_table.get_item(Key={'email': email})
        if 'Item' in existing:
            return response(409, {'detail': 'Email already registered'})
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    # Create user
    user_id = str(uuid.uuid4())
    password_hash, salt = hash_password(password)
    now = datetime.utcnow().isoformat() + 'Z'

    user = {
        'id': user_id,
        'email': email,
        'password_hash': password_hash,
        'password_salt': salt,
        'callsign': callsign,
        'created_at': now
    }

    try:
        users_table.put_item(Item=user)
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Failed to create user'})

    # Generate tokens
    access_token = create_jwt({'user_id': user_id, 'email': email})
    refresh_token = secrets.token_urlsafe(32)

    # Store refresh token
    refresh_expires = int(time.time()) + (REFRESH_EXPIRY_DAYS * 24 * 60 * 60)
    try:
        refresh_tokens_table.put_item(Item={
            'token': refresh_token,
            'user_id': user_id,
            'expires_at': refresh_expires
        })
    except ClientError as e:
        print(f"DynamoDB error storing refresh token: {e}")

    return response(201, {
        'access_token': access_token,
        'refresh_token': refresh_token,
        'token_type': 'Bearer',
        'user': {
            'id': user_id,
            'email': email,
            'callsign': callsign,
            'created_at': now
        }
    })


def handle_login(event):
    """POST /auth/login"""
    try:
        body = json.loads(event.get('body', '{}'))
    except json.JSONDecodeError:
        return response(400, {'detail': 'Invalid JSON'})

    email = body.get('email', '').lower().strip()
    password = body.get('password', '')

    if not email or not password:
        return response(400, {'detail': 'Email and password are required'})

    # Get user
    try:
        result = users_table.get_item(Key={'email': email})
        user = result.get('Item')
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    if not user:
        return response(401, {'detail': 'Invalid email or password'})

    # Verify password
    if not verify_password(password, user['password_hash'], user['password_salt']):
        return response(401, {'detail': 'Invalid email or password'})

    # Generate tokens
    access_token = create_jwt({'user_id': user['id'], 'email': user['email']})
    refresh_token = secrets.token_urlsafe(32)

    # Store refresh token
    refresh_expires = int(time.time()) + (REFRESH_EXPIRY_DAYS * 24 * 60 * 60)
    try:
        refresh_tokens_table.put_item(Item={
            'token': refresh_token,
            'user_id': user['id'],
            'expires_at': refresh_expires
        })
    except ClientError as e:
        print(f"DynamoDB error storing refresh token: {e}")

    return response(200, {
        'access_token': access_token,
        'refresh_token': refresh_token,
        'token_type': 'Bearer',
        'user': {
            'id': user['id'],
            'email': user['email'],
            'callsign': user.get('callsign'),
            'created_at': user['created_at']
        }
    })


def handle_refresh(event):
    """POST /auth/refresh"""
    try:
        body = json.loads(event.get('body', '{}'))
    except json.JSONDecodeError:
        return response(400, {'detail': 'Invalid JSON'})

    refresh_token = body.get('refresh_token', '')
    if not refresh_token:
        return response(400, {'detail': 'Refresh token is required'})

    # Verify refresh token
    try:
        result = refresh_tokens_table.get_item(Key={'token': refresh_token})
        token_item = result.get('Item')
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    if not token_item:
        return response(401, {'detail': 'Invalid refresh token'})

    if token_item.get('expires_at', 0) < int(time.time()):
        # Delete expired token
        try:
            refresh_tokens_table.delete_item(Key={'token': refresh_token})
        except ClientError:
            pass
        return response(401, {'detail': 'Refresh token expired'})

    # Get user
    user_id = token_item['user_id']
    try:
        # Query by id using GSI
        result = users_table.query(
            IndexName='id-index',
            KeyConditionExpression='id = :id',
            ExpressionAttributeValues={':id': user_id}
        )
        users = result.get('Items', [])
        user = users[0] if users else None
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    if not user:
        return response(401, {'detail': 'User not found'})

    # Delete old refresh token
    try:
        refresh_tokens_table.delete_item(Key={'token': refresh_token})
    except ClientError:
        pass

    # Generate new tokens
    access_token = create_jwt({'user_id': user['id'], 'email': user['email']})
    new_refresh_token = secrets.token_urlsafe(32)

    # Store new refresh token
    refresh_expires = int(time.time()) + (REFRESH_EXPIRY_DAYS * 24 * 60 * 60)
    try:
        refresh_tokens_table.put_item(Item={
            'token': new_refresh_token,
            'user_id': user['id'],
            'expires_at': refresh_expires
        })
    except ClientError as e:
        print(f"DynamoDB error storing refresh token: {e}")

    return response(200, {
        'access_token': access_token,
        'refresh_token': new_refresh_token,
        'token_type': 'Bearer'
    })


def handle_me(event):
    """GET /auth/me"""
    payload = get_user_from_token(event)
    if not payload:
        return response(401, {'detail': 'Invalid or expired token'})

    user_id = payload.get('user_id')

    # Get user
    try:
        result = users_table.query(
            IndexName='id-index',
            KeyConditionExpression='id = :id',
            ExpressionAttributeValues={':id': user_id}
        )
        users = result.get('Items', [])
        user = users[0] if users else None
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    if not user:
        return response(404, {'detail': 'User not found'})

    return response(200, {
        'id': user['id'],
        'email': user['email'],
        'callsign': user.get('callsign'),
        'created_at': user['created_at']
    })


def lambda_handler(event, context):
    """Main Lambda handler"""
    print(f"Event: {json.dumps(event)}")

    # Get HTTP method and path
    http_method = event.get('requestContext', {}).get('http', {}).get('method', '')
    path = event.get('requestContext', {}).get('http', {}).get('path', '')

    # Fallback for v1.0 payload format
    if not http_method:
        http_method = event.get('httpMethod', '')
    if not path:
        path = event.get('path', '')

    # Handle OPTIONS (CORS preflight)
    if http_method == 'OPTIONS':
        return response(200, {})

    # Route handling
    if path == '/auth/register' and http_method == 'POST':
        return handle_register(event)
    elif path == '/auth/login' and http_method == 'POST':
        return handle_login(event)
    elif path == '/auth/refresh' and http_method == 'POST':
        return handle_refresh(event)
    elif path == '/auth/me' and http_method == 'GET':
        return handle_me(event)
    else:
        return response(404, {'detail': 'Not found'})
