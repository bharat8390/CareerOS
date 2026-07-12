"""Liveness and readiness endpoints.

`/health` answers "is the process up?" with no dependency calls. `/ready` answers
"can it serve traffic?" by running the readiness registry and returns 503 in the
standard error envelope if any dependency is unhealthy.
"""

from __future__ import annotations

from http import HTTPStatus

from fastapi import APIRouter
from pydantic import BaseModel

from app.core.errors import AppError, ErrorDetail
from app.core.health import get_readiness_registry

health_router = APIRouter(tags=["health"])


class HealthResponse(BaseModel):
    status: str


class CheckStatus(BaseModel):
    name: str
    healthy: bool
    detail: str | None = None


class ReadyResponse(BaseModel):
    status: str
    checks: list[CheckStatus]


@health_router.get("/health", response_model=HealthResponse)
async def health() -> HealthResponse:
    return HealthResponse(status="ok")


@health_router.get("/ready", response_model=ReadyResponse)
async def ready() -> ReadyResponse:
    results = await get_readiness_registry().run()
    unhealthy = [result for result in results if not result.healthy]
    if unhealthy:
        raise AppError(
            code="NOT_READY",
            message="One or more dependencies are not ready.",
            status_code=HTTPStatus.SERVICE_UNAVAILABLE,
            details=[
                ErrorDetail(field=result.name, issue=result.detail or "unhealthy")
                for result in unhealthy
            ],
        )
    return ReadyResponse(
        status="ready",
        checks=[
            CheckStatus(name=result.name, healthy=result.healthy, detail=result.detail)
            for result in results
        ],
    )
