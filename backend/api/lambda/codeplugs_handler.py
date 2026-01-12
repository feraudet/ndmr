"""
Codeplugs Lambda Handler for NDMR API
Handles: /codeplugs (CRUD operations)
"""
import json
import os
import uuid
import hmac
import base64
import hashlib
import time
from datetime import datetime
import boto3
from botocore.exceptions import ClientError
from decimal import Decimal

# Environment variables
CODEPLUGS_TABLE = os.environ.get('CODEPLUGS_TABLE')
JWT_SECRET = os.environ.get('JWT_SECRET', 'dev-secret-change-me')

dynamodb = boto3.resource('dynamodb')
codeplugs_table = dynamodb.Table(CODEPLUGS_TABLE) if CODEPLUGS_TABLE else None

CORS_HEADERS = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type,Authorization',
    'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
    'Content-Type': 'application/json'
}


class DecimalEncoder(json.JSONEncoder):
    """Handle Decimal types from DynamoDB"""
    def default(self, obj):
        if isinstance(obj, Decimal):
            if obj % 1 == 0:
                return int(obj)
            return float(obj)
        return super().default(obj)


def response(status_code, body):
    """Create HTTP response"""
    return {
        'statusCode': status_code,
        'headers': CORS_HEADERS,
        'body': json.dumps(body, cls=DecimalEncoder)
    }


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
    headers = event.get('headers', {})
    # Headers can be case-insensitive
    auth_header = headers.get('authorization') or headers.get('Authorization', '')
    if not auth_header.startswith('Bearer '):
        return None

    token = auth_header[7:]
    payload = decode_jwt(token)
    if not payload:
        return None

    return payload


def convert_floats_to_decimal(obj):
    """Convert floats to Decimal for DynamoDB"""
    if isinstance(obj, float):
        return Decimal(str(obj))
    elif isinstance(obj, dict):
        return {k: convert_floats_to_decimal(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_floats_to_decimal(i) for i in obj]
    return obj


def handle_list(event, user_id: str):
    """GET /codeplugs - List all codeplugs for user"""
    try:
        result = codeplugs_table.query(
            KeyConditionExpression='user_id = :uid',
            ExpressionAttributeValues={':uid': user_id}
        )
        items = result.get('Items', [])

        # Return metadata only (without full data for list view)
        codeplugs = []
        for item in items:
            codeplugs.append({
                'id': item['id'],
                'user_id': item['user_id'],
                'name': item.get('name', 'Untitled'),
                'version': item.get('version', 1),
                'created_at': item.get('created_at'),
                'updated_at': item.get('updated_at')
            })

        # Sort by updated_at descending
        codeplugs.sort(key=lambda x: x.get('updated_at', ''), reverse=True)

        return response(200, codeplugs)
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})


def handle_get(event, user_id: str, codeplug_id: str):
    """GET /codeplugs/{id} - Get single codeplug with full data"""
    try:
        result = codeplugs_table.get_item(
            Key={'user_id': user_id, 'id': codeplug_id}
        )
        item = result.get('Item')

        if not item:
            return response(404, {'detail': 'Codeplug not found'})

        return response(200, {
            'id': item['id'],
            'user_id': item['user_id'],
            'name': item.get('name', 'Untitled'),
            'data': item.get('data', {}),
            'version': item.get('version', 1),
            'created_at': item.get('created_at'),
            'updated_at': item.get('updated_at')
        })
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})


def handle_create(event, user_id: str):
    """POST /codeplugs - Create new codeplug"""
    try:
        body = json.loads(event.get('body', '{}'))
    except json.JSONDecodeError:
        return response(400, {'detail': 'Invalid JSON'})

    name = body.get('name', 'Untitled')
    data = body.get('data', {})

    if not isinstance(data, dict):
        return response(400, {'detail': 'Data must be an object'})

    codeplug_id = str(uuid.uuid4())
    now = datetime.utcnow().isoformat() + 'Z'

    item = {
        'id': codeplug_id,
        'user_id': user_id,
        'name': name,
        'data': convert_floats_to_decimal(data),
        'version': 1,
        'created_at': now,
        'updated_at': now
    }

    try:
        codeplugs_table.put_item(Item=item)
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Failed to create codeplug'})

    return response(201, {
        'id': codeplug_id,
        'user_id': user_id,
        'name': name,
        'data': data,
        'version': 1,
        'created_at': now,
        'updated_at': now
    })


def handle_update(event, user_id: str, codeplug_id: str):
    """PUT /codeplugs/{id} - Update existing codeplug"""
    try:
        body = json.loads(event.get('body', '{}'))
    except json.JSONDecodeError:
        return response(400, {'detail': 'Invalid JSON'})

    # Check if codeplug exists and belongs to user
    try:
        result = codeplugs_table.get_item(
            Key={'user_id': user_id, 'id': codeplug_id}
        )
        existing = result.get('Item')
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    if not existing:
        return response(404, {'detail': 'Codeplug not found'})

    name = body.get('name', existing.get('name', 'Untitled'))
    data = body.get('data', existing.get('data', {}))
    client_version = body.get('version')

    # Version conflict check
    current_version = existing.get('version', 1)
    if client_version is not None and client_version < current_version:
        return response(409, {
            'detail': 'Version conflict',
            'server_version': current_version,
            'client_version': client_version
        })

    new_version = current_version + 1
    now = datetime.utcnow().isoformat() + 'Z'

    try:
        codeplugs_table.update_item(
            Key={'user_id': user_id, 'id': codeplug_id},
            UpdateExpression='SET #name = :name, #data = :data, #version = :version, #updated = :updated',
            ExpressionAttributeNames={
                '#name': 'name',
                '#data': 'data',
                '#version': 'version',
                '#updated': 'updated_at'
            },
            ExpressionAttributeValues={
                ':name': name,
                ':data': convert_floats_to_decimal(data),
                ':version': new_version,
                ':updated': now
            }
        )
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Failed to update codeplug'})

    return response(200, {
        'id': codeplug_id,
        'user_id': user_id,
        'name': name,
        'data': data,
        'version': new_version,
        'created_at': existing.get('created_at'),
        'updated_at': now
    })


def handle_delete(event, user_id: str, codeplug_id: str):
    """DELETE /codeplugs/{id} - Delete codeplug"""
    # Check if exists
    try:
        result = codeplugs_table.get_item(
            Key={'user_id': user_id, 'id': codeplug_id}
        )
        if 'Item' not in result:
            return response(404, {'detail': 'Codeplug not found'})
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    # Delete
    try:
        codeplugs_table.delete_item(
            Key={'user_id': user_id, 'id': codeplug_id}
        )
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Failed to delete codeplug'})

    return response(204, {})


def handle_sync(event, user_id: str):
    """POST /codeplugs/sync - Smart sync (create if new, update if exists)"""
    try:
        body = json.loads(event.get('body', '{}'))
    except json.JSONDecodeError:
        return response(400, {'detail': 'Invalid JSON'})

    codeplug_id = body.get('id')
    name = body.get('name', 'Untitled')
    data = body.get('data', {})
    client_version = body.get('version', 0)

    if not codeplug_id:
        return response(400, {'detail': 'Codeplug ID is required'})

    now = datetime.utcnow().isoformat() + 'Z'

    # Check if exists
    try:
        result = codeplugs_table.get_item(
            Key={'user_id': user_id, 'id': codeplug_id}
        )
        existing = result.get('Item')
    except ClientError as e:
        print(f"DynamoDB error: {e}")
        return response(500, {'detail': 'Database error'})

    if existing:
        # Update existing
        current_version = existing.get('version', 1)

        # Skip if client version is behind
        if client_version < current_version:
            return response(200, {
                'id': codeplug_id,
                'user_id': user_id,
                'name': existing.get('name'),
                'data': existing.get('data', {}),
                'version': current_version,
                'created_at': existing.get('created_at'),
                'updated_at': existing.get('updated_at'),
                'action': 'skipped',
                'reason': 'client_version_behind'
            })

        new_version = current_version + 1

        try:
            codeplugs_table.update_item(
                Key={'user_id': user_id, 'id': codeplug_id},
                UpdateExpression='SET #name = :name, #data = :data, #version = :version, #updated = :updated',
                ExpressionAttributeNames={
                    '#name': 'name',
                    '#data': 'data',
                    '#version': 'version',
                    '#updated': 'updated_at'
                },
                ExpressionAttributeValues={
                    ':name': name,
                    ':data': convert_floats_to_decimal(data),
                    ':version': new_version,
                    ':updated': now
                }
            )
        except ClientError as e:
            print(f"DynamoDB error: {e}")
            return response(500, {'detail': 'Failed to update codeplug'})

        return response(200, {
            'id': codeplug_id,
            'user_id': user_id,
            'name': name,
            'data': data,
            'version': new_version,
            'created_at': existing.get('created_at'),
            'updated_at': now,
            'action': 'updated'
        })
    else:
        # Create new
        item = {
            'id': codeplug_id,
            'user_id': user_id,
            'name': name,
            'data': convert_floats_to_decimal(data),
            'version': 1,
            'created_at': now,
            'updated_at': now
        }

        try:
            codeplugs_table.put_item(Item=item)
        except ClientError as e:
            print(f"DynamoDB error: {e}")
            return response(500, {'detail': 'Failed to create codeplug'})

        return response(201, {
            'id': codeplug_id,
            'user_id': user_id,
            'name': name,
            'data': data,
            'version': 1,
            'created_at': now,
            'updated_at': now,
            'action': 'created'
        })


def lambda_handler(event, context):
    """Main Lambda handler"""
    print(f"Event: {json.dumps(event)}")

    # Get HTTP method and path
    http_context = event.get('requestContext', {}).get('http', {})
    http_method = http_context.get('method', '')
    path = http_context.get('path', '')

    # Fallback for v1.0 payload format
    if not http_method:
        http_method = event.get('httpMethod', '')
    if not path:
        path = event.get('path', '')

    # Handle OPTIONS (CORS preflight)
    if http_method == 'OPTIONS':
        return response(200, {})

    # Auth required for all codeplug operations
    payload = get_user_from_token(event)
    if not payload:
        return response(401, {'detail': 'Invalid or expired token'})

    user_id = payload.get('user_id')
    if not user_id:
        return response(401, {'detail': 'Invalid token payload'})

    # Get path parameters
    path_params = event.get('pathParameters', {}) or {}
    codeplug_id = path_params.get('id')

    # Route handling
    if path == '/codeplugs' and http_method == 'GET':
        return handle_list(event, user_id)
    elif path == '/codeplugs' and http_method == 'POST':
        return handle_create(event, user_id)
    elif path == '/codeplugs/sync' and http_method == 'POST':
        return handle_sync(event, user_id)
    elif codeplug_id and http_method == 'GET':
        return handle_get(event, user_id, codeplug_id)
    elif codeplug_id and http_method == 'PUT':
        return handle_update(event, user_id, codeplug_id)
    elif codeplug_id and http_method == 'DELETE':
        return handle_delete(event, user_id, codeplug_id)
    else:
        return response(404, {'detail': 'Not found'})
