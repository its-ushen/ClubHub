from sqlite3 import Row

from flask import session

from ..db_functions.users import user_profile_info


def current_user() -> str | None:
    return session.get("user", None)


def current_user_profile_info() -> Row:
    return user_profile_info(session["user-id"])


def login(user_id: int, username: str, user_type: str) -> None:
    session["user-id"] = user_id
    session["user"] = username
    session["user-type"] = user_type


def logout() -> None:
    del session["user-id"]
    del session["user"]
    del session["user-type"]