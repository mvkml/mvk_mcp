from fastapi import APIRouter
from app.api.hello.api_router import module_hello_router
"""
This module defines the main API router for the application.
It imports the FastAPI APIRouter and includes the `api_pt_router` from the Portuguese API module
under the `/api_pt` prefix. This allows all endpoints defined in `api_pt_router` to be accessible
under the `/api_pt` path.
Attributes:
    api_router (APIRouter): The main API router that includes sub-routers for different API sections.
""" 

main_api_router = APIRouter() 
main_api_router.include_router(module_hello_router)




