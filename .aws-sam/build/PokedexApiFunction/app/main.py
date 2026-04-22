from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum
from app.routes import pokemon, favourites, team

app = FastAPI(
    title="Pokédex API",
    description="REST API for the Pokémon Pokédex app, backed by PostgreSQL on EC2.",
    version="1.0.0",
)

# Allow requests from your Flutter app (and Swagger UI)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Restrict in production to your app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(pokemon.router)
app.include_router(favourites.router)
app.include_router(team.router)


@app.get("/", tags=["Health"])
def health_check():
    return {"status": "ok", "service": "Pokédex API"}


# ─── AWS Lambda entry point ────────────────────────────────────────────────────
# Mangum wraps the ASGI app so Lambda can call it directly.
handler = Mangum(app, lifespan="off")
