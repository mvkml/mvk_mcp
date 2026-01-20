# MCP Application - Core Modules Documentation

This document provides detailed information about the core Python modules used in this application.

## Core Dependencies

### 1. FastAPI (`from fastapi import FastAPI`)

**Package:** `fastapi`

**Purpose:** Modern, fast (high-performance) web framework for building APIs with Python 3.7+ based on standard Python type hints.

#### Key Features:
- **Fast**: Very high performance, on par with NodeJS and Go
- **Fast to code**: Increase development speed by 200-300%
- **Type Safety**: Based on standard Python type hints with automatic validation
- **Automatic API Documentation**: Interactive API docs (Swagger UI) at `/docs` and ReDoc at `/redoc`
- **Dependency Injection**: Built-in dependency injection system
- **Async Support**: Full support for async/await patterns

#### FastAPI Class Details:

```python
from fastapi import FastAPI

app = FastAPI(
    title="MARVISH Industrial AI Assistant",
    version="1.0.0",
    description="API documentation",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json"
)
```

**Common Methods:**
- `@app.get()` - Define GET endpoint
- `@app.post()` - Define POST endpoint
- `@app.put()` - Define PUT endpoint
- `@app.delete()` - Define DELETE endpoint
- `@app.include_router()` - Include sub-routers
- `@app.middleware()` - Add middleware
- `@app.on_event("startup")` - Startup event handler
- `@app.on_event("shutdown")` - Shutdown event handler

**Installation:**
```bash
pip install fastapi==0.111.0
pip install uvicorn[standard]==0.30.1  # ASGI server
```

**Current Version in Project:** `0.111.0`

---

### 2. MCP Server - FastMCP (`from mcp.server.fastmcp import FastMCP`)

**Package:** `mcp` (Model Context Protocol)

**Purpose:** FastMCP provides a high-level, FastAPI-style interface for building MCP (Model Context Protocol) servers quickly. It's designed to integrate AI agents with external tools and data sources.

#### Key Features:
- **Declarative API**: FastAPI-like decorator syntax
- **Tool Registration**: Easy function-to-tool conversion
- **Resource Management**: Built-in resource handling
- **Prompt Templates**: Support for prompt management
- **Type Safety**: Full Pydantic model support

#### FastMCP Class Details:

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("MyServer")

@mcp.tool()
def my_tool(param: str) -> str:
    """Tool description for LLM"""
    return f"Result: {param}"
```

**Common Decorators & Methods:**
- `@mcp.tool()` - Register a function as an MCP tool
- `@mcp.resource()` - Register a resource provider
- `@mcp.prompt()` - Register a prompt template
- `mcp.run()` - Start the MCP server
- `mcp.add_tool()` - Programmatically add tools

**Use Cases:**
- Exposing Python functions as tools for LLM agents
- Building AI agent backends
- Creating custom MCP servers for LangGraph/LangChain
- Integrating external APIs with AI systems

---

### 3. MCP Server Core (`from mcp.server import Server`)

**Package:** `mcp.server`

**Purpose:** Low-level MCP server implementation. Provides the core server infrastructure for the Model Context Protocol.

#### Server Class Details:

```python
from mcp.server import Server

server = Server("my-server")

# Register handlers
@server.list_tools()
async def list_tools():
    return [...]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    return [...]
```

**Key Responsibilities:**
- **Protocol Handling**: Manages MCP protocol communication
- **Request/Response**: Handles incoming requests and outgoing responses
- **Tool Management**: Maintains tool registry and execution
- **Resource Management**: Manages available resources
- **Session Management**: Handles client sessions

**Differences from FastMCP:**
- **Server**: Low-level, more control, manual handler registration
- **FastMCP**: High-level, FastAPI-like, automatic handler generation

**When to Use:**
- Use `FastMCP` for rapid development and simple servers
- Use `Server` for complex scenarios requiring fine-grained control

---

### 4. MCP Types (`from mcp.types import Tool, TextContent`)

**Package:** `mcp.types`

**Purpose:** Type definitions and data models for the Model Context Protocol. Provides Pydantic models for structured communication.

#### Tool Class

```python
from mcp.types import Tool

tool = Tool(
    name="calculate_sum",
    description="Adds two numbers together",
    inputSchema={
        "type": "object",
        "properties": {
            "a": {"type": "number", "description": "First number"},
            "b": {"type": "number", "description": "Second number"}
        },
        "required": ["a", "b"]
    }
)
```

**Tool Attributes:**
- `name` (str): Unique identifier for the tool
- `description` (str): Human-readable description for LLM
- `inputSchema` (dict): JSON Schema defining expected parameters

**Purpose:** Defines a callable tool that LLMs can invoke through the MCP protocol. Used in function calling scenarios.

#### TextContent Class

```python
from mcp.types import TextContent

content = TextContent(
    type="text",
    text="This is the response text"
)
```

**TextContent Attributes:**
- `type` (str): Content type identifier (usually "text")
- `text` (str): The actual text content

**Purpose:** Represents textual content in MCP responses. Used when returning text results from tool calls or resources.

#### Other Common Types in mcp.types:

**ImageContent:**
```python
from mcp.types import ImageContent

image = ImageContent(
    type="image",
    data="base64_encoded_data",
    mimeType="image/png"
)
```

**CallToolResult:**
```python
from mcp.types import CallToolResult

result = CallToolResult(
    content=[TextContent(type="text", text="Result")],
    isError=False
)
```

**Resource:**
```python
from mcp.types import Resource

resource = Resource(
    uri="file:///path/to/resource",
    name="MyResource",
    description="Resource description",
    mimeType="text/plain"
)
```

---

## Architecture Integration

### How These Modules Work Together

```python
# 1. FastAPI handles HTTP endpoints
from fastapi import FastAPI
app = FastAPI(title="MARVISH Industrial AI Assistant")

# 2. MCP Server/FastMCP provides AI agent tool interface
from mcp.server.fastmcp import FastMCP
mcp_server = FastMCP("ClaimPolicyAgent")

# 3. Define tools using MCP types
from mcp.types import Tool, TextContent

@mcp_server.tool()
def validate_claim(claim_id: str) -> str:
    """Validates insurance claim"""
    result = perform_validation(claim_id)
    return result

# 4. FastAPI endpoint that uses MCP tool
@app.post("/api/validate")
async def validate_endpoint(claim_id: str):
    # Can invoke MCP tools or integrate with LangGraph
    result = await process_with_agent(claim_id)
    return {"result": result}
```

### Flow Diagram

```
Client Request
    ↓
FastAPI Endpoint (HTTP)
    ↓
Business Logic / Service Layer
    ↓
MCP Server/FastMCP (Tool Execution)
    ↓
Tool Implementation (using mcp.types)
    ↓
Return TextContent/Results
    ↓
FastAPI Response (HTTP)
```

---

## Installation

```bash
# Install FastAPI
pip install fastapi==0.111.0
pip install uvicorn[standard]==0.30.1

# Install MCP
pip install mcp

# Or install all project dependencies
pip install -r requirements.txt
```

---

## Common Patterns

### Pattern 1: FastAPI + FastMCP Integration

```python
from fastapi import FastAPI
from mcp.server.fastmcp import FastMCP
from mcp.types import Tool, TextContent

app = FastAPI()
mcp = FastMCP("MyAgent")

@mcp.tool()
def my_tool(query: str) -> str:
    """Process query"""
    return f"Processed: {query}"

@app.get("/health")
def health():
    return {"status": "healthy"}

# Run both servers
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

### Pattern 2: LangGraph + MCP Tools

```python
from langchain_openai import ChatOpenAI
from langgraph.prebuilt import create_react_agent
from mcp.types import Tool

# Define MCP tools
tools = [
    Tool(
        name="search",
        description="Search for information",
        inputSchema={...}
    )
]

# Create agent with tools
llm = ChatOpenAI(model="gpt-4")
agent = create_react_agent(llm, tools)
```

### Pattern 3: Tool Result Formatting

```python
from mcp.types import TextContent, CallToolResult

def execute_tool(name: str, args: dict) -> CallToolResult:
    try:
        result = perform_operation(name, args)
        return CallToolResult(
            content=[TextContent(type="text", text=str(result))],
            isError=False
        )
    except Exception as e:
        return CallToolResult(
            content=[TextContent(type="text", text=str(e))],
            isError=True
        )
```

---

## Best Practices

1. **Type Hints**: Always use type hints for FastAPI and MCP tool parameters
2. **Tool Descriptions**: Provide clear, detailed descriptions for LLM understanding
3. **Error Handling**: Wrap tool executions in try-except blocks
4. **Schema Validation**: Use Pydantic models with MCP inputSchema
5. **Async/Await**: Use async functions for I/O operations in FastAPI
6. **Documentation**: Leverage FastAPI's automatic docs generation

---

## Troubleshooting

### Issue: MCP Tools Not Recognized by LLM

**Solution:** Ensure tool descriptions are clear and inputSchema is properly formatted with JSON Schema.

### Issue: FastAPI and MCP Port Conflicts

**Solution:** Run them on different ports or integrate MCP as a service within FastAPI.

### Issue: Type Validation Errors

**Solution:** Ensure all parameters have proper type hints and match the inputSchema.

---

## References

- **FastAPI Documentation**: https://fastapi.tiangolo.com/
- **MCP Specification**: https://modelcontextprotocol.io/
- **Pydantic Documentation**: https://docs.pydantic.dev/
- **LangGraph Documentation**: https://langchain-ai.github.io/langgraph/

---

## Current Project Usage

This project uses these modules for:
- **FastAPI**: Main API server (port 825) serving HTTP endpoints
- **MCP Server**: Tool interface for LLM agents
- **Claim Policy Analysis**: Validating insurance claims using AI agents
- **LangGraph Integration**: Agent workflows with tool calling capabilities

See [READMEProjectStructure.md](READMEProjectStructure.md) for full project architecture.
