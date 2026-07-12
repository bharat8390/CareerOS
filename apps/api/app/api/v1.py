"""Aggregation router for API version 1.

Feature routers (auth, users, learning, …) are attached here as their modules
land. Mounted by the app factory under the configured `/api/v1` prefix.
"""

from __future__ import annotations

from fastapi import APIRouter

api_router = APIRouter()
