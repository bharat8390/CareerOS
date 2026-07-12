"""Core building blocks for the CareerOS API.

Holds cross-cutting concerns imported by the rest of the app but that import
nothing upstream: configuration, the error envelope, and middleware. Database,
security, and logging helpers are added by later stories (S1-4, S1-5).
"""
