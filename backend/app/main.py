from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum

from .config import get_settings
from .routers import auth_router, codeplugs_router

settings = get_settings()

app = FastAPI(
    title="Ndmr API",
    description="Backend API for Ndmr DMR codeplug editor",
    version="0.1.0",
    docs_url="/docs" if settings.environment == "development" else None,
    redoc_url="/redoc" if settings.environment == "development" else None,
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:*",
        "https://ndmr.app",
        "https://*.ndmr.app",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth_router)
app.include_router(codeplugs_router)


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "version": "0.1.0"}


# AWS Lambda handler
handler = Mangum(app, lifespan="off")
