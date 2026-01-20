# MCP vs REST API: Practical Comparison

## Overview
- REST APIs expose HTTP endpoints (verbs like GET/POST) for resources.
- MCP (Model Context Protocol) exposes tools with typed inputs/outputs for LLMs to call in a structured way.
- Think of MCP as a contract for actions the model can perform, while REST is a contract for resource access via HTTP.

---

## Key Differences
- Interface:
	- REST: URLs, methods (GET/POST/PUT/DELETE), status codes.
	- MCP: Tool names, JSON schemas for parameters/returns, invocation protocol.
- Consumer:
	- REST: Humans, services, browsers, mobile apps.
	- MCP: LLM clients and IDEs that orchestrate tool calls.
- Contract:
	- REST: Resource-centric, CRUD patterns.
	- MCP: Action-centric, capability and tool discovery.
- Transport:
	- REST: HTTP(S) request/response.
	- MCP: Typically stdio or HTTP; focuses on capabilities registry + tool execution.

---

## When To Use Which
- Use REST when you need public or service-to-service HTTP APIs for apps.
- Use MCP when you need an LLM to safely call your capabilities with typed inputs/outputs and discoverable tools.
- Many systems will use both: REST for external clients, MCP for AI assistants.

---

## FastAPI Comparison (Python)

### REST: Simple Customer Endpoint
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/customers/{id}")
async def get_customer(id: str):
		# Fetch from DB (omitted)
		return {"id": id, "status": "active"}
```

Call via curl:
```bash
curl -s http://localhost:8000/customers/123
```

### MCP: Equivalent Tool Definition
```python
from fastapi import FastAPI
from mcp.server import MCPServer

app = FastAPI()
mcp = MCPServer(app)

@mcp.tool()
async def query_customer(id: str) -> dict:
		# Fetch from DB (omitted)
		return {"id": id, "status": "active"}
```

Invoke conceptually (from an MCP client):
```json
{
	"tool": "query_customer",
	"params": { "id": "123" }
}
```

Notes:
- REST returns over HTTP with status codes.
- MCP returns structured results to the client that orchestrates LLM + tools; the client handles display and errors.

---

## ASP.NET Core Comparison (C#)

### REST: Minimal API
```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/customers/{id}", (string id) => new { id, status = "active" });

app.Run();
```

Call via curl:
```bash
curl -s http://localhost:5000/customers/123
```

### MCP: Conceptual Tool Pattern in .NET (pseudocode)
```csharp
public interface IMcpTool
{
		string Name { get; }
		Task<object> ExecuteAsync(object input);
}

public class QueryCustomerTool : IMcpTool
{
		public string Name => "query_customer";
		public Task<object> ExecuteAsync(object input)
		{
				var id = (input as dynamic).id;
				return Task.FromResult<object>(new { id = (string)id, status = "active" });
		}
}

// Tool registry and invocation would be handled by an MCP server implementation
```

Notes:
- ASP.NET Core REST uses HTTP routes and middleware.
- MCP tools in .NET would follow a registry + typed-execution pattern, exposed to an MCP client. Specific SDKs may vary; pattern remains: name + schema + execute.

---

## Request/Response Shape Comparison
- REST:
	- Request: GET /customers/123
	- Response: { "id": "123", "status": "active" } + HTTP status codes, headers.
- MCP:
	- Request: { "tool": "query_customer", "params": { "id": "123" } }
	- Response: { "result": { "id": "123", "status": "active" } }

---

## Practical Guidance
- Wrap existing REST services with MCP tools to let LLMs discover and call them safely.
- Keep REST for human/app consumption; use MCP to orchestrate multi-step actions, enforce schemas, and provide capability discovery.
- Validate inputs with schemas (Pydantic, Zod) and guardrails for safe tool execution.

---

## Profile

**Vishnu Kiran M**  
End-to-End AI, Cloud & Big Data Solution Designer
