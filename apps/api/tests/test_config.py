"""Unit tests for typed configuration loading."""

from __future__ import annotations

import pytest
from pydantic import ValidationError

from app.core.config import Settings, SettingsError, get_settings


def test_missing_required_env_var_fails_fast(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.delenv("APP_ENV", raising=False)
    get_settings.cache_clear()
    with pytest.raises(SettingsError) as excinfo:
        get_settings()
    assert "app_env" in str(excinfo.value)
    get_settings.cache_clear()


def test_log_level_is_normalized_to_upper() -> None:
    settings = Settings(app_env="test", log_level="info")
    assert settings.log_level == "INFO"


def test_invalid_log_level_is_rejected() -> None:
    with pytest.raises(ValidationError):
        Settings(app_env="test", log_level="verbose")


def test_cors_origins_parsed_into_list() -> None:
    settings = Settings(app_env="test", cors_origins="http://a.test, http://b.test ,")
    assert settings.cors_origin_list == ["http://a.test", "http://b.test"]


def test_is_production_flag() -> None:
    assert Settings(app_env="production").is_production is True
    assert Settings(app_env="development").is_production is False
