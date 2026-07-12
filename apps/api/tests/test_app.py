"""API tests for the app factory, middleware, and error envelope."""

from __future__ import annotations

from http import HTTPStatus
from typing import TYPE_CHECKING

from fastapi.testclient import TestClient

from app.core.config import Settings
from app.core.errors import REQUEST_ID_HEADER, AppError
from app.main import create_app

if TYPE_CHECKING:
    from fastapi import FastAPI


def _build_app() -> FastAPI:
    return create_app(Settings(app_env="test"))


def test_openapi_document_is_served() -> None:
    client = TestClient(_build_app())
    response = client.get("/api/openapi.json")
    assert response.status_code == HTTPStatus.OK
    assert response.json()["info"]["title"] == "CareerOS API"


def test_unknown_route_returns_404_envelope(client: TestClient) -> None:
    response = client.get("/api/v1/does-not-exist")
    assert response.status_code == HTTPStatus.NOT_FOUND
    body = response.json()
    assert body["error"]["code"] == "NOT_FOUND"
    assert body["error"]["request_id"] is not None
    assert response.headers[REQUEST_ID_HEADER] == body["error"]["request_id"]


def test_request_id_is_generated_when_absent(client: TestClient) -> None:
    response = client.get("/api/v1/does-not-exist")
    assert response.headers[REQUEST_ID_HEADER].startswith("req_")


def test_inbound_request_id_is_honoured(client: TestClient) -> None:
    response = client.get(
        "/api/v1/does-not-exist",
        headers={REQUEST_ID_HEADER: "req_from-client"},
    )
    assert response.headers[REQUEST_ID_HEADER] == "req_from-client"
    assert response.json()["error"]["request_id"] == "req_from-client"


def test_validation_error_returns_422_envelope() -> None:
    app = _build_app()

    @app.get("/api/v1/_probe")
    def _probe(n: int) -> dict[str, int]:
        return {"n": n}

    client = TestClient(app)
    response = client.get("/api/v1/_probe", params={"n": "not-an-int"})
    assert response.status_code == HTTPStatus.UNPROCESSABLE_ENTITY
    body = response.json()
    assert body["error"]["code"] == "VALIDATION_ERROR"
    assert len(body["error"]["details"]) >= 1
    assert body["error"]["details"][0]["field"].startswith("query")


def test_app_error_maps_to_envelope() -> None:
    app = _build_app()

    @app.get("/api/v1/_boom")
    def _boom() -> None:
        raise AppError(
            code="TEAPOT",
            message="I refuse to brew coffee.",
            status_code=HTTPStatus.IM_A_TEAPOT,
        )

    client = TestClient(app)
    response = client.get("/api/v1/_boom")
    assert response.status_code == HTTPStatus.IM_A_TEAPOT
    assert response.json()["error"]["code"] == "TEAPOT"


def test_unexpected_error_does_not_leak_internals() -> None:
    app = _build_app()

    @app.get("/api/v1/_explode")
    def _explode() -> None:
        raise ValueError("super secret internal detail")

    client = TestClient(app, raise_server_exceptions=False)
    response = client.get("/api/v1/_explode")
    assert response.status_code == HTTPStatus.INTERNAL_SERVER_ERROR
    body = response.json()
    assert body["error"]["code"] == "INTERNAL_ERROR"
    assert "secret" not in body["error"]["message"]
