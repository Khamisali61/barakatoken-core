import json
from decimal import Decimal
from typing import Any
from fastapi.responses import JSONResponse

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj: Any) -> Any:
        if isinstance(obj, Decimal):
            # Return as string to preserve exactly 4 decimal places
            return format(obj, '.4f')
        return super(DecimalEncoder, self).default(obj)

class CustomJSONResponse(JSONResponse):
    def render(self, content: Any) -> bytes:
        return json.dumps(
            content,
            ensure_ascii=False,
            allow_nan=False,
            indent=None,
            separators=(",", ":"),
            cls=DecimalEncoder,
        ).encode("utf-8")
