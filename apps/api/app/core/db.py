"""Database engine, session, and declarative base.

SQLAlchemy 2.0 async stack (architecture is async-by-default). The engine and
sessionmaker are created lazily from settings so importing this module never
requires a configured database; feature modules depend on `get_db` for a scoped
`AsyncSession`. Constraint/index naming is fixed here so Alembic emits stable,
predictable names across migrations.
"""

from __future__ import annotations

from typing import TYPE_CHECKING

from sqlalchemy import MetaData, text
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase

from app.core.config import get_settings
from app.core.health import CheckResult

if TYPE_CHECKING:
    from collections.abc import AsyncIterator

# Deterministic names for constraints and indexes (Alembic-friendly).
NAMING_CONVENTION: dict[str, str] = {
    "ix": "ix_%(column_0_label)s",
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s",
}


class Base(DeclarativeBase):
    """Declarative base shared by all ORM models."""

    metadata = MetaData(naming_convention=NAMING_CONVENTION)


class DatabaseNotConfiguredError(RuntimeError):
    """Raised when a database operation is attempted without `DATABASE_URL`."""


_engine: AsyncEngine | None = None
_sessionmaker: async_sessionmaker[AsyncSession] | None = None


def get_engine() -> AsyncEngine:
    """Return the process-wide async engine, creating it on first use."""
    global _engine
    if _engine is None:
        settings = get_settings()
        if settings.database_url is None:
            raise DatabaseNotConfiguredError(
                "DATABASE_URL is not set; configure it to use the database."
            )
        _engine = create_async_engine(settings.database_url, pool_pre_ping=True)
    return _engine


def get_sessionmaker() -> async_sessionmaker[AsyncSession]:
    """Return the process-wide session factory, creating it on first use."""
    global _sessionmaker
    if _sessionmaker is None:
        _sessionmaker = async_sessionmaker(
            bind=get_engine(),
            expire_on_commit=False,
        )
    return _sessionmaker


async def get_db() -> AsyncIterator[AsyncSession]:
    """FastAPI dependency yielding a scoped async session."""
    async with get_sessionmaker()() as session:
        yield session


async def check_database() -> CheckResult:
    """Readiness check: the database answers a trivial query."""
    if get_settings().database_url is None:
        return CheckResult(name="database", healthy=False, detail="not configured")
    try:
        async with get_engine().connect() as connection:
            await connection.execute(text("SELECT 1"))
    except Exception:
        return CheckResult(name="database", healthy=False, detail="unreachable")
    return CheckResult(name="database", healthy=True)
