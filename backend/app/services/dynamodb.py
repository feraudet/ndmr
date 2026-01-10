import boto3
from functools import lru_cache
from ..config import get_settings


@lru_cache
def get_dynamodb_client():
    settings = get_settings()
    return boto3.resource("dynamodb", region_name=settings.aws_region)


class DynamoDBService:
    def __init__(self):
        self.dynamodb = get_dynamodb_client()
        settings = get_settings()
        self.users_table = self.dynamodb.Table(settings.dynamodb_users_table)
        self.codeplugs_table = self.dynamodb.Table(settings.dynamodb_codeplugs_table)
