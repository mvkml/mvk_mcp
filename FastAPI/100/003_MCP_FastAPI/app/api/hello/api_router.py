from app.api.hello import api_hello_mcp
from fastapi import APIRouter

module_hello_router = APIRouter(prefix="/hello", tags=["hello"])
module_hello_router.include_router(api_hello_mcp.hello_router)
