FROM python:3.12-slim-bookworm

# Install uv (from official binary), nodejs, npm, and git
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install build deps and essential utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* && \
    node -v && npm -v

# Copy your whole project (including pyproject.toml, mcpo src, etc) into /app
COPY . /app

WORKDIR /app

# Make sure entrypoint is copied and executable
COPY entrypoint.sh /app/entrypoint.sh

# Create uv-managed virtual environment
ENV VIRTUAL_ENV=/app/.venv
RUN uv venv "$VIRTUAL_ENV"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install your app (assumes correct pyproject.toml/setup.cfg)
RUN uv pip install . && \
    rm -rf ~/.cache && \
    which mcpo

# Set environment variables as needed (edit as desired)
ENV CONFIG_FILE=/app/config.json

# Expose port (adjust as needed)
EXPOSE 8000

# Use your custom entrypoint (make sure your script is correct and executable)
ENTRYPOINT ["/app/entrypoint.sh"]