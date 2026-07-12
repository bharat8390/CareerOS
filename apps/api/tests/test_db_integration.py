"""Integration tests that require a live PostgreSQL (via `DATABASE_URL`).

Skipped automatically when `DATABASE_URL` is unset, so the default unit suite
stays hermetic. CI sets it against a Postgres 16 service container.
"""

from __future__ import annotations

import asyncio
import os
from typing import TYPE_CHECKING

import pytest

import app.core.db as db_module
from app.core.config import Settings
from app.core.db import check_database
from app.main import create_app

if TYPE_CHECKING:
    from collections.abc import Iterator

    from fastapi.testclient import TestClient

_DATABASE_URL = os.environ.get("DATABASE_URL")

pytestmark = pytest.mark.skipif(
    _DATABASE_URL is None,
    reason="requires DATABASE_URL pointing at a live PostgreSQL",
)


@pytest.fixture(autouse=True)
def _fresh_engine() -> Iterator[None]:
    # An AsyncEngine is bound to the event loop that first uses it; each test here
    # runs in its own loop, so start from a clean global engine every time.
    db_module._engine = None
    db_module._sessionmaker = None
    yield
    db_module._engine = None
    db_module._sessionmaker = None


def test_check_database_healthy_against_live_db() -> None:
    result = asyncio.run(check_database())
    assert result.healthy is True


def test_ready_returns_200_with_database_check() -> None:
    from fastapi.testclient import TestClient

    settings = Settings(app_env="test", database_url=_DATABASE_URL)
    client: TestClient = TestClient(create_app(settings))
    response = client.get("/ready")
    assert response.status_code == 200
    names = [check["name"] for check in response.json()["checks"]]
    assert "database" in names
