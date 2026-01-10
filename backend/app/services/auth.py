import uuid
from datetime import datetime, timedelta, timezone
from typing import Any

from jose import jwt, JWTError
from passlib.context import CryptContext
from boto3.dynamodb.conditions import Key

from ..config import get_settings
from ..models.user import UserCreate, UserResponse, TokenResponse
from .dynamodb import DynamoDBService


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class AuthService(DynamoDBService):
    def verify_password(self, plain_password: str, hashed_password: str) -> bool:
        return pwd_context.verify(plain_password, hashed_password)

    def hash_password(self, password: str) -> str:
        return pwd_context.hash(password)

    def create_access_token(self, user_id: str) -> tuple[str, int]:
        settings = get_settings()
        expires_delta = timedelta(minutes=settings.access_token_expire_minutes)
        expire = datetime.now(timezone.utc) + expires_delta

        to_encode = {
            "sub": user_id,
            "exp": expire,
            "type": "access",
        }

        token = jwt.encode(
            to_encode,
            settings.jwt_secret_key,
            algorithm=settings.jwt_algorithm,
        )
        return token, settings.access_token_expire_minutes * 60

    def create_refresh_token(self, user_id: str) -> str:
        settings = get_settings()
        expires_delta = timedelta(days=settings.refresh_token_expire_days)
        expire = datetime.now(timezone.utc) + expires_delta

        to_encode = {
            "sub": user_id,
            "exp": expire,
            "type": "refresh",
        }

        return jwt.encode(
            to_encode,
            settings.jwt_secret_key,
            algorithm=settings.jwt_algorithm,
        )

    def verify_token(self, token: str, token_type: str = "access") -> str | None:
        """Verify token and return user_id if valid"""
        settings = get_settings()
        try:
            payload = jwt.decode(
                token,
                settings.jwt_secret_key,
                algorithms=[settings.jwt_algorithm],
            )
            if payload.get("type") != token_type:
                return None
            return payload.get("sub")
        except JWTError:
            return None

    async def register(self, user_data: UserCreate) -> UserResponse | None:
        # Check if user already exists
        response = self.users_table.query(
            IndexName="email-index",
            KeyConditionExpression=Key("email").eq(user_data.email),
        )

        if response.get("Items"):
            return None  # User already exists

        # Create new user
        user_id = str(uuid.uuid4())
        now = datetime.now(timezone.utc).isoformat()

        user_item = {
            "id": user_id,
            "email": user_data.email,
            "password_hash": self.hash_password(user_data.password),
            "callsign": user_data.callsign,
            "created_at": now,
        }

        self.users_table.put_item(Item=user_item)

        return UserResponse(
            id=user_id,
            email=user_data.email,
            callsign=user_data.callsign,
            created_at=datetime.fromisoformat(now),
        )

    async def login(self, email: str, password: str) -> TokenResponse | None:
        # Find user by email
        response = self.users_table.query(
            IndexName="email-index",
            KeyConditionExpression=Key("email").eq(email),
        )

        items = response.get("Items", [])
        if not items:
            return None

        user = items[0]

        # Verify password
        if not self.verify_password(password, user["password_hash"]):
            return None

        # Create tokens
        access_token, expires_in = self.create_access_token(user["id"])
        refresh_token = self.create_refresh_token(user["id"])

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=expires_in,
        )

    async def refresh(self, refresh_token: str) -> TokenResponse | None:
        user_id = self.verify_token(refresh_token, token_type="refresh")
        if not user_id:
            return None

        # Verify user still exists
        response = self.users_table.get_item(Key={"id": user_id})
        if "Item" not in response:
            return None

        # Create new tokens
        access_token, expires_in = self.create_access_token(user_id)
        new_refresh_token = self.create_refresh_token(user_id)

        return TokenResponse(
            access_token=access_token,
            refresh_token=new_refresh_token,
            expires_in=expires_in,
        )

    async def get_user(self, user_id: str) -> UserResponse | None:
        response = self.users_table.get_item(Key={"id": user_id})
        item = response.get("Item")

        if not item:
            return None

        return UserResponse(
            id=item["id"],
            email=item["email"],
            callsign=item.get("callsign"),
            created_at=datetime.fromisoformat(item["created_at"]),
        )
