"""API tests for the liveness and readiness endpoints."""

from __future__ import annotations

from http import HTTPStatus
from typing import TYPE_CHECKING

import pytest

from app.core.health import CheckResult, readiness_registry

if TYPE_CHECKING:
    from collections.abc import Iterator

    from fastapi.testclient import TestClient


@pytest.fixture(autouse=True)
def _clean_registry() -> Iterator[None]:
    readiness_registry.clear()
    yield
    readiness_registry.clear()


def test_health_is_always_ok(client: TestClient) -> None:
    response = client.get("/health")
    assert response.status_code == HTTPStatus.OK
    assert response.json() == {"status": "ok"}


def test_ready_is_ok_with_no_registered_checks(client: TestClient) -> None:
    response = client.get("/ready")
    assert response.status_code == HTTPStatus.OK
    body = response.json()
    assert body["status"] == "ready"
    assert body["checks"] == []


def test_ready_reports_registered_healthy_check(client: TestClient) -> None:
    async def _db() -> CheckResult:
        return CheckResult(name="database", healthy=True)

    readiness_registry.register("database", _db)

    response = client.get("/ready")
    assert response.status_code == HTTPStatus.OK
    assert response.json()["checks"] == [{"name": "database", "healthy": True, "detail": None}]


def test_ready_returns_503_envelope_when_dependency_down(client: TestClient) -> None:
    async def _db() -> CheckResult:
        return CheckResult(name="database", healthy=False, detail="connection refused")

    readiness_registry.register("database", _db)

    response = client.get("/ready")
    assert response.status_code == HTTPStatus.SERVICE_UNAVAILABLE
    error = response.json()["error"]
    assert error["code"] == "NOT_READY"
    assert error["details"] == [{"field": "database", "issue": "connection refused"}]
    assert error["request_id"] is not None


def test_ready_treats_raising_check_as_unhealthy(client: TestClient) -> None:
    async def _redis() -> CheckResult:
        raise RuntimeError("boom")

    readiness_registry.register("redis", _redis)

    response = client.get("/ready")
    assert response.status_code == HTTPStatus.SERVICE_UNAVAILABLE
    assert response.json()["error"]["details"][0]["field"] == "redis"
