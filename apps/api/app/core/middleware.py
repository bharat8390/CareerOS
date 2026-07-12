"""HTTP middleware for the CareerOS API.

`RequestIDMiddleware` assigns (or honours an inbound) correlation id per request,
binds it to the request context, and echoes it back on the response so clients
and logs can correlate a request end-to-end.
"""

from __future__ import annotations

from typing import TYPE_CHECKING
from uuid import uuid4

from starlette.datastructures import Headers, MutableHeaders

from app.core.context import request_id_ctx
from app.core.errors import REQUEST_ID_HEADER

if TYPE_CHECKING:
    from starlette.types import ASGIApp, Message, Receive, Scope, Send


def _new_request_id() -> str:
    return f"req_{uuid4().hex}"


class RequestIDMiddleware:
    """Pure-ASGI middleware that binds a correlation id to each HTTP request."""

    def __init__(self, app: ASGIApp) -> None:
        self.app = app

    async def __call__(self, scope: Scope, receive: Receive, send: Send) -> None:
        if scope["type"] != "http":
            await self.app(scope, receive, send)
            return

        inbound = Headers(scope=scope).get(REQUEST_ID_HEADER)
        request_id = inbound or _new_request_id()
        token = request_id_ctx.set(request_id)

        async def send_with_request_id(message: Message) -> None:
            if message["type"] == "http.response.start":
                MutableHeaders(scope=message)[REQUEST_ID_HEADER] = request_id
            await send(message)

        try:
            await self.app(scope, receive, send_with_request_id)
        finally:
            request_id_ctx.reset(token)
