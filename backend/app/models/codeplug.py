from pydantic import BaseModel
from datetime import datetime
from typing import Any


class CodeplugCreate(BaseModel):
    name: str
    data: dict[str, Any]


class CodeplugUpdate(BaseModel):
    name: str | None = None
    data: dict[str, Any] | None = None


class CodeplugResponse(BaseModel):
    id: str
    user_id: str
    name: str
    data: dict[str, Any]
    version: int
    created_at: datetime
    updated_at: datetime


class CodeplugListItem(BaseModel):
    id: str
    name: str
    version: int
    updated_at: datetime


class CodeplugSync(BaseModel):
    """For sync operations - includes version for conflict detection"""
    id: str | None = None
    name: str
    data: dict[str, Any]
    version: int = 0
    local_updated_at: datetime | None = None
