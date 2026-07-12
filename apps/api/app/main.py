"""Application factory.

`create_app()` wires configuration, middleware, error handling, and the versioned
router into a FastAPI instance. Keeping construction in a factory keeps the app
importable for tests and lets settings drive behaviour per environment.
"""

from __future__ import annotations

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app import __version__
from app.api.v1 import api_router
from app.core.config import Settings, get_settings
from app.core.errors import register_exception_handlers
from app.core.middleware import RequestIDMiddleware


def create_app(settings: Settings | None = None) -> FastAPI:
    """Build and configure the CareerOS FastAPI application."""
    settings = settings or get_settings()

    app = FastAPI(
        title=settings.project_name,
        version=__version__,
        docs_url="/api/docs",
        openapi_url="/api/openapi.json",
    )

    # Request-id first so it is available to every downstream layer and handler.
    app.add_middleware(RequestIDMiddleware)
    if settings.cors_origin_list:
        app.add_middleware(
            CORSMiddleware,
            allow_origins=settings.cors_origin_list,
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
        )

    register_exception_handlers(app)
    app.include_router(api_router, prefix=settings.api_v1_prefix)

    return app


app = create_app()
