import os
import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    """
    Opens a new PostgreSQL connection using environment variables.
    For production Lambda, set these via AWS Lambda env config or Secrets Manager.
    """
    return psycopg2.connect(
        host=os.environ.get("DB_HOST", "localhost"),
        port=int(os.environ.get("DB_PORT", 5432)),
        dbname=os.environ.get("DB_NAME", "pokedex"),
        user=os.environ.get("DB_USER", "pokeuser"),
        password=os.environ.get("DB_PASSWORD", ""),
        cursor_factory=RealDictCursor,
        connect_timeout=5,
    )
