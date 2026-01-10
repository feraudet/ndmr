from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    # JWT Configuration
    jwt_secret_key: str = "dev-secret-change-in-production"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    refresh_token_expire_days: int = 7

    # DynamoDB Configuration
    dynamodb_users_table: str = "ndmr-users"
    dynamodb_codeplugs_table: str = "ndmr-codeplugs"
    aws_region: str = "eu-west-3"

    # Environment
    environment: str = "development"

    class Config:
        env_file = ".env"


@lru_cache
def get_settings() -> Settings:
    return Settings()
