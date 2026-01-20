from fastapi import APIRouter
"""
This module defines the main API router for the application.
It imports the FastAPI APIRouter and includes the `api_pt_router` from the Portuguese API module
under the `/api_pt` prefix. This allows all endpoints defined in `api_pt_router` to be accessible
under the `/api_pt` path.
Attributes:
    api_router (APIRouter): The main API router that includes sub-routers for different API sections.
""" 
api_router = APIRouter() 


