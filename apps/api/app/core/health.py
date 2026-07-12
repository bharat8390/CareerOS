"""Readiness-check registry.

`/ready` must report whether the app's dependencies are usable. Dependencies are
registered as named async checks so each module wires its own (database in S1-5,
Redis in S1-8) without the health endpoint knowing about them. Until then the
registry is empty and readiness is trivially true.
"""

from __future__ import annotations

import logging
from collections.abc import Awaitable, Callable
from dataclasses import dataclass

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class CheckResult:
    """Outcome of a single readiness check."""

    name: str
    healthy: bool
    detail: str | None = None


ReadinessCheck = Callable[[], Awaitable[CheckResult]]


class ReadinessRegistry:
    """Holds named readiness checks and runs them for `/ready`."""

    def __init__(self) -> None:
        self._checks: dict[str, ReadinessCheck] = {}

    def register(self, name: str, check: ReadinessCheck) -> None:
        self._checks[name] = check

    def clear(self) -> None:
        self._checks.clear()

    async def run(self) -> list[CheckResult]:
        """Run every check; a raising check is reported unhealthy, never propagated."""
        results: list[CheckResult] = []
        for name, check in self._checks.items():
            try:
                results.append(await check())
            except Exception:
                logger.exception("Readiness check %r raised", name)
                results.append(
                    CheckResult(name=name, healthy=False, detail="check raised an error")
                )
        return results


# Process-wide registry populated by dependency modules at startup.
readiness_registry = ReadinessRegistry()


def get_readiness_registry() -> ReadinessRegistry:
    return readiness_registry
