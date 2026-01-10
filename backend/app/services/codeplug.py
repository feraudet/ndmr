import uuid
import json
from datetime import datetime, timezone
from decimal import Decimal

from boto3.dynamodb.conditions import Key

from ..models.codeplug import (
    CodeplugCreate,
    CodeplugUpdate,
    CodeplugResponse,
    CodeplugListItem,
    CodeplugSync,
)
from .dynamodb import DynamoDBService


class DecimalEncoder(json.JSONEncoder):
    """Handle Decimal types from DynamoDB"""

    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super().default(obj)


def convert_decimals(obj):
    """Recursively convert Decimal to float in nested structures"""
    if isinstance(obj, Decimal):
        return float(obj)
    elif isinstance(obj, dict):
        return {k: convert_decimals(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_decimals(i) for i in obj]
    return obj


class CodeplugService(DynamoDBService):
    async def create(self, user_id: str, codeplug: CodeplugCreate) -> CodeplugResponse:
        codeplug_id = str(uuid.uuid4())
        now = datetime.now(timezone.utc).isoformat()

        item = {
            "id": codeplug_id,
            "user_id": user_id,
            "name": codeplug.name,
            "data": codeplug.data,
            "version": 1,
            "created_at": now,
            "updated_at": now,
        }

        self.codeplugs_table.put_item(Item=item)

        return CodeplugResponse(
            id=codeplug_id,
            user_id=user_id,
            name=codeplug.name,
            data=codeplug.data,
            version=1,
            created_at=datetime.fromisoformat(now),
            updated_at=datetime.fromisoformat(now),
        )

    async def get(self, codeplug_id: str, user_id: str) -> CodeplugResponse | None:
        response = self.codeplugs_table.get_item(Key={"id": codeplug_id})
        item = response.get("Item")

        if not item or item.get("user_id") != user_id:
            return None

        item = convert_decimals(item)

        return CodeplugResponse(
            id=item["id"],
            user_id=item["user_id"],
            name=item["name"],
            data=item["data"],
            version=item["version"],
            created_at=datetime.fromisoformat(item["created_at"]),
            updated_at=datetime.fromisoformat(item["updated_at"]),
        )

    async def list(self, user_id: str) -> list[CodeplugListItem]:
        response = self.codeplugs_table.query(
            IndexName="user_id-index",
            KeyConditionExpression=Key("user_id").eq(user_id),
        )

        items = response.get("Items", [])
        items = convert_decimals(items)

        return [
            CodeplugListItem(
                id=item["id"],
                name=item["name"],
                version=item["version"],
                updated_at=datetime.fromisoformat(item["updated_at"]),
            )
            for item in items
        ]

    async def update(
        self, codeplug_id: str, user_id: str, update: CodeplugUpdate
    ) -> CodeplugResponse | None:
        # First verify ownership
        existing = await self.get(codeplug_id, user_id)
        if not existing:
            return None

        now = datetime.now(timezone.utc).isoformat()
        new_version = existing.version + 1

        update_expr_parts = ["#updated_at = :updated_at", "#version = :version"]
        expr_attr_names = {"#updated_at": "updated_at", "#version": "version"}
        expr_attr_values = {":updated_at": now, ":version": new_version}

        if update.name is not None:
            update_expr_parts.append("#name = :name")
            expr_attr_names["#name"] = "name"
            expr_attr_values[":name"] = update.name

        if update.data is not None:
            update_expr_parts.append("#data = :data")
            expr_attr_names["#data"] = "data"
            expr_attr_values[":data"] = update.data

        self.codeplugs_table.update_item(
            Key={"id": codeplug_id},
            UpdateExpression="SET " + ", ".join(update_expr_parts),
            ExpressionAttributeNames=expr_attr_names,
            ExpressionAttributeValues=expr_attr_values,
        )

        return await self.get(codeplug_id, user_id)

    async def delete(self, codeplug_id: str, user_id: str) -> bool:
        # Verify ownership first
        existing = await self.get(codeplug_id, user_id)
        if not existing:
            return False

        self.codeplugs_table.delete_item(Key={"id": codeplug_id})
        return True

    async def sync(
        self, user_id: str, codeplug: CodeplugSync
    ) -> CodeplugResponse | None:
        """
        Sync a codeplug - create if new, update if version matches.
        Returns None if there's a version conflict (server has newer version).
        """
        if codeplug.id:
            # Try to update existing
            existing = await self.get(codeplug.id, user_id)
            if existing:
                # Check for version conflict
                if existing.version > codeplug.version:
                    # Server has newer version - return it for client to handle
                    return existing

                # Version matches or client is newer - update
                update = CodeplugUpdate(name=codeplug.name, data=codeplug.data)
                return await self.update(codeplug.id, user_id, update)

        # Create new codeplug
        create = CodeplugCreate(name=codeplug.name, data=codeplug.data)
        return await self.create(user_id, create)
