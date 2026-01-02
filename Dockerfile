# Development Dockerfile with hot reload and CPU support
FROM python:3.11.13-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    curl \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    supervisor \
    && curl -LsSf https://astral.sh/uv/install.sh | sh \
    && rm -rf /var/lib/apt/lists/*

# Add uv to path
ENV PATH="/root/.local/bin:$PATH"

# Copy uv project files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen

# Install PaddlePaddle CPU first (before other dependencies)
RUN uv pip install paddlepaddle==3.2.0 -i https://www.paddlepaddle.org.cn/packages/stable/cpu/

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy app code (mounted via volume in docker-compose)
COPY app/ ./app/

# Set Python path
ENV PYTHONPATH=/app

# Expose ports for api and streamlit
EXPOSE 8002 8501

#Expose port for FastAPI
#EXPOSE 5056

# Run supervisor to manage FastAPI + Streamlit
# Note: supervisor commands will use python -m uv run
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

#If want to run the app directly, uncomment the following line
#CMD ["python", "-m", "uv", "run", "app.main:app", "--host", "0.0.0.0", "--port", "5056"]