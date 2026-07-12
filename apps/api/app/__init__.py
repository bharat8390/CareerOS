"""CareerOS backend API package.

Root of the FastAPI application. The app factory lives in `app.main:create_app`;
cross-cutting concerns (config, error envelope, middleware) live in `app.core`.
Feature modules and persistence arrive in later stories per the frozen architecture.
"""

__version__ = "0.0.0"
