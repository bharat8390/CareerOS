"""Per-request context.

A context variable carries the correlation id for the current request so any
layer (error handlers now, structured logging in S1-4) can read it without
threading it through call signatures.
"""

from __future__ import annotations

from contextvars import ContextVar

request_id_ctx: ContextVar[str | None] = ContextVar("request_id", default=None)


def get_request_id() -> str | None:
    """Return the correlation id bound to the current request, if any."""
    return request_id_ctx.get()
