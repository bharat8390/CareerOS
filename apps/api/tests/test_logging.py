"""Unit tests for structured JSON logging."""

from __future__ import annotations

import json
import logging

from app.core.context import request_id_ctx
from app.core.logging import JsonLogFormatter, configure_logging


def _record(message: str) -> logging.LogRecord:
    return logging.LogRecord(
        name="app.test",
        level=logging.INFO,
        pathname=__file__,
        lineno=1,
        msg=message,
        args=(),
        exc_info=None,
    )


def test_formatter_emits_valid_json_with_expected_fields() -> None:
    formatted = JsonLogFormatter().format(_record("hello"))
    payload = json.loads(formatted)
    assert payload["level"] == "INFO"
    assert payload["logger"] == "app.test"
    assert payload["message"] == "hello"
    assert "timestamp" in payload


def test_formatter_includes_request_id_when_bound() -> None:
    token = request_id_ctx.set("req_test-123")
    try:
        payload = json.loads(JsonLogFormatter().format(_record("bound")))
    finally:
        request_id_ctx.reset(token)
    assert payload["request_id"] == "req_test-123"


def test_formatter_omits_request_id_when_absent() -> None:
    payload = json.loads(JsonLogFormatter().format(_record("unbound")))
    assert "request_id" not in payload


def test_formatter_handles_falsy_exc_info() -> None:
    record = logging.LogRecord(
        name="app.test",
        level=logging.INFO,
        pathname=__file__,
        lineno=1,
        msg="no exception",
        args=(),
        exc_info=False,  # type: ignore[arg-type]
    )
    payload = json.loads(JsonLogFormatter().format(record))
    assert "exc_info" not in payload


def test_configure_logging_sets_level_and_json_formatter() -> None:
    configure_logging("WARNING")
    root = logging.getLogger()
    assert root.level == logging.WARNING
    assert len(root.handlers) == 1
    assert isinstance(root.handlers[0].formatter, JsonLogFormatter)
    # Restore a sane default for the rest of the suite.
    configure_logging("INFO")
