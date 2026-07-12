"""Shared test configuration.

Sets the minimal environment the app requires before it is imported, and exposes
a `TestClient` bound to a freshly built app so tests never depend on import order.
"""

from __future__ import annotations

import os

# Must be set before any import that constructs Settings (see app.core.config).
os.environ.setdefault("APP_ENV", "test")

from typing import TYPE_CHECKING

import pytest
from fastapi.testclient import TestClient

from app.core.config import Settings
from app.main import create_app

if TYPE_CHECKING:
    from collections.abc import Iterator


@pytest.fixture
def client() -> Iterator[TestClient]:
    # Explicitly DB-less so the default client is deterministic even when a
    # DATABASE_URL is present in the environment (e.g. CI's Postgres job).
    app = create_app(Settings(app_env="test", database_url=None))
    with TestClient(app) as test_client:
        yield test_client
