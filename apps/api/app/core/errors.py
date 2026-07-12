"""Standard error envelope and exception handling.

Every error response shares one shape (doc 05 / API.md):

    { "error": { "code", "message", "details", "request_id" } }

Internals are never leaked: unexpected exceptions become a generic 500 while the
real cause is left to logging (added in S1-4).
"""

from __future__ import annotations

from http import HTTPStatus
from typing import TYPE_CHECKING

from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.core.context import get_request_id

if TYPE_CHECKING:
    from fastapi import FastAPI, Request

REQUEST_ID_HEADER = "X-Request-ID"

# Maps HTTP status codes to the stable error codes in the catalog (doc 05 §5.19).
_STATUS_CODE_MAP: dict[int, str] = {
    HTTPStatus.BAD_REQUEST: "VALIDATION_ERROR",
    HTTPStatus.UNAUTHORIZED: "UNAUTHENTICATED",
    HTTPStatus.FORBIDDEN: "FORBIDDEN",
    HTTPStatus.NOT_FOUND: "NOT_FOUND",
    HTTPStatus.CONFLICT: "CONFLICT",
    HTTPStatus.UNPROCESSABLE_ENTITY: "VALIDATION_ERROR",
    HTTPStatus.TOO_MANY_REQUESTS: "RATE_LIMITED",
    HTTPStatus.INTERNAL_SERVER_ERROR: "INTERNAL_ERROR",
}


class ErrorDetail(BaseModel):
    """A single field-level problem within an error."""

    field: str
    issue: str


class ErrorBody(BaseModel):
    """The body of the standard error envelope."""

    code: str
    message: str
    details: list[ErrorDetail] = Field(default_factory=list)
    request_id: str | None = None


class ErrorResponse(BaseModel):
    """Top-level error envelope returned by every failing request."""

    error: ErrorBody


class AppError(Exception):
    """Domain/application error that maps to the standard envelope.

    Raise this (or a subclass) from services to return a controlled error
    instead of leaking an unexpected exception.
    """

    def __init__(
        self,
        *,
        code: str,
        message: str,
        status_code: int = HTTPStatus.BAD_REQUEST,
        details: list[ErrorDetail] | None = None,
    ) -> None:
        super().__init__(message)
        self.code = code
        self.message = message
        self.status_code = status_code
        self.details = details or []


def _code_for_status(status_code: int) -> str:
    return _STATUS_CODE_MAP.get(status_code, "ERROR")


def _envelope(
    *,
    status_code: int,
    code: str,
    message: str,
    details: list[ErrorDetail] | None = None,
) -> JSONResponse:
    body = ErrorResponse(
        error=ErrorBody(
            code=code,
            message=message,
            details=details or [],
            request_id=get_request_id(),
        )
    )
    return JSONResponse(status_code=status_code, content=body.model_dump())


async def _handle_app_error(request: Request, exc: AppError) -> JSONResponse:
    return _envelope(
        status_code=exc.status_code,
        code=exc.code,
        message=exc.message,
        details=exc.details,
    )


async def _handle_http_exception(request: Request, exc: StarletteHTTPException) -> JSONResponse:
    message = exc.detail if isinstance(exc.detail, str) else HTTPStatus(exc.status_code).phrase
    return _envelope(
        status_code=exc.status_code,
        code=_code_for_status(exc.status_code),
        message=message,
    )


async def _handle_validation_error(request: Request, exc: RequestValidationError) -> JSONResponse:
    details = [
        ErrorDetail(
            field=".".join(str(part) for part in error["loc"]),
            issue=str(error["msg"]),
        )
        for error in exc.errors()
    ]
    return _envelope(
        status_code=HTTPStatus.UNPROCESSABLE_ENTITY,
        code="VALIDATION_ERROR",
        message="Request validation failed.",
        details=details,
    )


async def _handle_unexpected_error(request: Request, exc: Exception) -> JSONResponse:
    return _envelope(
        status_code=HTTPStatus.INTERNAL_SERVER_ERROR,
        code="INTERNAL_ERROR",
        message="An unexpected error occurred.",
    )


def register_exception_handlers(app: FastAPI) -> None:
    """Register the handlers that render every error in the standard envelope."""
    app.add_exception_handler(AppError, _handle_app_error)  # type: ignore[arg-type]
    app.add_exception_handler(StarletteHTTPException, _handle_http_exception)  # type: ignore[arg-type]
    app.add_exception_handler(RequestValidationError, _handle_validation_error)  # type: ignore[arg-type]
    app.add_exception_handler(Exception, _handle_unexpected_error)
