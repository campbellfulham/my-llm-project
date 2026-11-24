# Slim python image keeps container small
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Install deps first (better cache)
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the app
COPY . .

# Render sets $PORT. Fallback to 8000 for local runs.
ENV PORT=8000
EXPOSE 8000

# Use sh so ${PORT} expands
CMD sh -c 'uvicorn --app-dir src api.server:app --host 0.0.0.0 --port ${PORT:-8000}'
