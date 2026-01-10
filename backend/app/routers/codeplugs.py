from fastapi import APIRouter, Depends, HTTPException, status

from ..models.codeplug import (
    CodeplugCreate,
    CodeplugUpdate,
    CodeplugResponse,
    CodeplugListItem,
    CodeplugSync,
)
from ..services.codeplug import CodeplugService
from ..dependencies import get_current_user_id

router = APIRouter(prefix="/codeplugs", tags=["codeplugs"])
codeplug_service = CodeplugService()


@router.get("", response_model=list[CodeplugListItem])
async def list_codeplugs(user_id: str = Depends(get_current_user_id)):
    """List all codeplugs for the current user"""
    return await codeplug_service.list(user_id)


@router.post("", response_model=CodeplugResponse, status_code=status.HTTP_201_CREATED)
async def create_codeplug(
    codeplug: CodeplugCreate,
    user_id: str = Depends(get_current_user_id),
):
    """Create a new codeplug"""
    return await codeplug_service.create(user_id, codeplug)


@router.get("/{codeplug_id}", response_model=CodeplugResponse)
async def get_codeplug(
    codeplug_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Get a specific codeplug by ID"""
    result = await codeplug_service.get(codeplug_id, user_id)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Codeplug not found",
        )
    return result


@router.put("/{codeplug_id}", response_model=CodeplugResponse)
async def update_codeplug(
    codeplug_id: str,
    update: CodeplugUpdate,
    user_id: str = Depends(get_current_user_id),
):
    """Update an existing codeplug"""
    result = await codeplug_service.update(codeplug_id, user_id, update)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Codeplug not found",
        )
    return result


@router.delete("/{codeplug_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_codeplug(
    codeplug_id: str,
    user_id: str = Depends(get_current_user_id),
):
    """Delete a codeplug"""
    success = await codeplug_service.delete(codeplug_id, user_id)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Codeplug not found",
        )


@router.post("/sync", response_model=CodeplugResponse)
async def sync_codeplug(
    codeplug: CodeplugSync,
    user_id: str = Depends(get_current_user_id),
):
    """
    Sync a codeplug from client to server.

    - If codeplug.id is None, creates a new codeplug
    - If codeplug.id exists and versions match, updates the codeplug
    - If server has newer version, returns server version (client should merge/overwrite)
    """
    result = await codeplug_service.sync(user_id, codeplug)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Sync failed",
        )
    return result
