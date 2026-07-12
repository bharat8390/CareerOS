"""Application configuration.

Typed, environment-driven settings loaded once at startup via Pydantic Settings.
`get_settings()` fails fast with a clear message when required variables are
missing or invalid, so misconfiguration surfaces at boot rather than at request
time. The variable contract is documented in the repo-root `.env.example`.
"""

from __future__ import annotations

from functools import lru_cache
from typing import Literal

from pydantic import ValidationError, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

AppEnv = Literal["development", "test", "staging", "production"]
LogLevel = Literal["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]


class Settings(BaseSettings):
    """Runtime configuration resolved from environment variables."""

    model_config = SettingsConfigDict(
        env_prefix="",
        case_sensitive=False,
        extra="ignore",
    )

    # Required: the deployment environment. No default on purpose so that a
    # missing value fails fast (see `get_settings`).
    app_env: AppEnv

    project_name: str = "CareerOS API"
    api_v1_prefix: str = "/api/v1"

    # Bind-all host is intended for containerized dev/CI.
    api_host: str = "0.0.0.0"
    api_port: int = 8000

    log_level: LogLevel = "INFO"

    # Comma-separated list of allowed CORS origins (empty = none).
    cors_origins: str = ""

    @field_validator("log_level", mode="before")
    @classmethod
    def _normalize_log_level(cls, value: object) -> object:
        return value.upper() if isinstance(value, str) else value

    @property
    def cors_origin_list(self) -> list[str]:
        return [origin.strip() for origin in self.cors_origins.split(",") if origin.strip()]

    @property
    def is_production(self) -> bool:
        return self.app_env == "production"


class SettingsError(RuntimeError):
    """Raised when configuration cannot be resolved from the environment."""


@lru_cache
def get_settings() -> Settings:
    """Return the cached settings, raising a readable error on misconfiguration."""
    try:
        return Settings()
    except ValidationError as exc:
        problems = "; ".join(
            f"{'.'.join(str(loc) for loc in error['loc'])}: {error['msg']}"
            for error in exc.errors()
        )
        raise SettingsError(
            f"Invalid or missing environment configuration ({exc.error_count()} issue(s)): "
            f"{problems}. See .env.example for the required variables."
        ) from exc
