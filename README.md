# Starter Template Project

## Overview
This project is a FastAPI-based application structured with modular components, including API endpoints, configuration management, and utility scripts. It is containerized using Docker for easy deployment and scalability, with support for both CPU and GPU environments.

## Project Structure
- `app/`: Main source code directory.
  - `main.py`: Application entry point (FastAPI app).
  - `api/`: API implementation and endpoints.
  - `models/`: Data models.
  - `helpers/`: Utility modules.
- `tests/`: Test cases for the application.
- `Dockerfile`: Docker image for CPU environment.
- `Dockerfile.gpu`: Docker image for GPU environment.
- `docker-compose.yml`: Docker Compose configuration for CPU.
- `docker-compose-gpu.yml`: Docker Compose configuration for GPU.
- `docker.sh`: Docker management script for easy container operations.

## Prerequisites
- Python 3.8 or higher
- Docker and Docker Compose (for containerization)
- pip (Python package installer)
- (Optional) NVIDIA Docker runtime for GPU support

## Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd starter-template
   ```

2. (Optional) Create and activate a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

## Running the Application

### Using Docker (Recommended)

The project includes a convenient `docker.sh` script for managing containers. Make sure the script is executable:
```bash
chmod +x docker.sh
```

#### Available Commands

- **build** - Build Docker images (with cache)
- **rebuild** - Rebuild Docker images (without cache)
- **up** - Start containers
- **down** - Stop and remove containers
- **restart** - Restart containers
- **logs** - Show container logs (follow mode)
- **logs_tail** - Show last 100 lines of logs
- **shell** - Open shell in running container
- **clean** - Remove containers, volumes, and images
- **status** - Show container status
- **help** - Show help message

#### CPU Mode (Default)
```bash
# Build and start containers
./docker.sh build
./docker.sh up

# Or rebuild without cache
./docker.sh rebuild
./docker.sh up
```

#### GPU Mode
```bash
# Build and start GPU containers
./docker.sh build gpu
./docker.sh up gpu

# Or rebuild without cache
./docker.sh rebuild gpu
./docker.sh up gpu
```

#### Examples
```bash
# View logs
./docker.sh logs          # CPU mode
./docker.sh logs gpu      # GPU mode

# Access container shell
./docker.sh shell         # CPU mode
./docker.sh shell gpu     # GPU mode

# Clean up
./docker.sh clean         # CPU mode
./docker.sh clean gpu     # GPU mode
```

The application will be accessible at:
- **API**: http://localhost:5056
- **API Documentation**: http://localhost:5056/docs
- **Interactive API Docs**: http://localhost:5056/redoc

### Without Docker
Run the application directly:
```bash
python -m app.main
```

Or using uvicorn:
```bash
uvicorn app.main:app --host 0.0.0.0 --port 5056 --reload
```

## Testing
Run tests using your preferred test runner:
```bash
pytest tests/
```

## Contributing
Contributions are welcome! Please open issues or submit pull requests for improvements or bug fixes.
