from fastapi import FastAPI
from app.api.hello import api_router
from app.api.router import main_api_router


app = FastAPI(title="My FastAPI Application",
              version="1.0.0"
              ,description="This is a sample FastAPI application")


@app.get("/")
def api_init():
    return {"message": "MCP API initialized"}

app.include_router(main_api_router,prefix="/api")


# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run("main:app", host="127.0.0.24", port=824, reload=True)