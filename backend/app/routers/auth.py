from fastapi import APIRouter, Depends, HTTPException, status

from ..models.user import UserCreate, UserLogin, UserResponse, TokenResponse, TokenRefresh
from ..services.auth import AuthService
from ..dependencies import get_current_user_id

router = APIRouter(prefix="/auth", tags=["auth"])
auth_service = AuthService()


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(user: UserCreate):
    """Register a new user account"""
    result = await auth_service.register(user)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="User with this email already exists",
        )
    return result


@router.post("/login", response_model=TokenResponse)
async def login(credentials: UserLogin):
    """Login with email and password"""
    result = await auth_service.login(credentials.email, credentials.password)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )
    return result


@router.post("/refresh", response_model=TokenResponse)
async def refresh(token_data: TokenRefresh):
    """Refresh access token using refresh token"""
    result = await auth_service.refresh(token_data.refresh_token)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired refresh token",
        )
    return result


@router.get("/me", response_model=UserResponse)
async def get_current_user(user_id: str = Depends(get_current_user_id)):
    """Get current user info - requires authentication"""
    result = await auth_service.get_user(user_id)
    if not result:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return result
