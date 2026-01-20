from fastapi import APIRouter, FastAPI
from mcp.server.fastmcp import FastMCP
from mcp.server import Server
from mcp.types import Tool,TextContent

hello_router = APIRouter()

@hello_router.get("/")
async def hello():
    return {"message": "Hello, MCP!"}
    
