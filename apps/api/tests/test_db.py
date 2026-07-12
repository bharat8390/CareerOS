"""Unit tests for the database base and readiness check (no live database)."""

from __future__ import annotations

import asyncio

import pytest

import app.core.db as db_module
from app.core.config import get_settings
from app.core.db import Base, DatabaseNotConfiguredError, check_database, get_engine


def test_base_declares_naming_convention() -> None:
    convention = Base.metadata.naming_convention
    assert set(convention) == {"ix", "uq", "ck", "fk", "pk"}
    assert convention["pk"] == "pk_%(table_name)s"


@pytest.fixture
def _no_database(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.delenv("DATABASE_URL", raising=False)
    get_settings.cache_clear()
    db_module._engine = None
    db_module._sessionmaker = None


def test_check_database_reports_not_configured(_no_database: None) -> None:
    result = asyncio.run(check_database())
    assert result.name == "database"
    assert result.healthy is False
    assert result.detail == "not configured"
    get_settings.cache_clear()


def test_get_engine_raises_when_not_configured(_no_database: None) -> None:
    with pytest.raises(DatabaseNotConfiguredError):
        get_engine()
    get_settings.cache_clear()
