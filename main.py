from fastapi import FastAPI
from config.database import engine 

# Routes 
from routes.potato import router as potato_router
from config.database import Base 

app = FastAPI()

Base.metadata.create_all(bind=engine)

# Include routers
app.include_router(potato_router)
