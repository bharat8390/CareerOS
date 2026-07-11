"""Smoke test for the API scaffold.

Verifies the package imports and exposes a version. This keeps the test suite (and
CI) green from S1-1 before any application logic exists; real tests arrive with the
app factory in S1-3.
"""

from __future__ import annotations

import app


def test_package_exposes_version() -> None:
    assert isinstance(app.__version__, str)
    assert app.__version__ != ""
