#!/bin/bash

# Docker management script
# Usage: ./docker.sh [command] [gpu]
# Commands: build, rebuild, up, down, restart, logs, logs_tail, shell, clean, status, help
# Use "gpu" as second argument to use GPU compose file, otherwise uses CPU (default)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Determine which compose file to use
if [ "$2" = "gpu" ]; then
    COMPOSE_FILE="docker-compose-gpu.yml"
    MODE="GPU"
    CONTAINER_NAME="starter-template-dev-gpu"
else
    COMPOSE_FILE="docker-compose.yml"
    MODE="CPU"
    CONTAINER_NAME="starter-template-dev"
fi

# Functions
print_usage() {
    echo -e "${BLUE}Usage:${NC}"
    echo "  ./docker.sh [command] [gpu]"
    echo ""
    echo -e "${BLUE}Commands:${NC}"
    echo "  build      - Build Docker images (with cache)"
    echo "  rebuild    - Rebuild Docker images (without cache)"
    echo "  up         - Start containers"
    echo "  down       - Stop and remove containers"
    echo "  restart    - Restart containers"
    echo "  logs       - Show container logs (follow mode)"
    echo "  logs_tail  - Show last 100 lines of logs"
    echo "  shell      - Open shell in running container"
    echo "  clean      - Remove containers, volumes, and images"
    echo "  status     - Show container status"
    echo "  help       - Show this help message"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo "  gpu        - Use GPU compose file (docker-compose-gpu.yml)"
    echo "  (none)     - Use CPU compose file (docker-compose.yml) [default]"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  ./docker.sh build          - Build CPU image (with cache)"
    echo "  ./docker.sh build gpu      - Build GPU image (with cache)"
    echo "  ./docker.sh rebuild        - Rebuild CPU image (without cache)"
    echo "  ./docker.sh rebuild gpu    - Rebuild GPU image (without cache)"
    echo "  ./docker.sh up             - Start CPU containers"
    echo "  ./docker.sh up gpu         - Start GPU containers"
    echo "  ./docker.sh logs gpu       - Show GPU container logs"
    echo "  ./docker.sh clean          - Clean CPU environment"
    echo "  ./docker.sh clean gpu      - Clean GPU environment"
}

check_compose_file() {
    if [ ! -f "$COMPOSE_FILE" ]; then
        echo -e "${RED}Error:${NC} Compose file '$COMPOSE_FILE' not found!"
        exit 1
    fi
}

build() {
    echo -e "${GREEN}Building Docker image for ${MODE} environment...${NC}"
    docker-compose -f "$COMPOSE_FILE" build
    echo -e "${GREEN}Build completed!${NC}"
}

rebuild() {
    echo -e "${GREEN}Rebuilding Docker image for ${MODE} environment (without cache)...${NC}"
    docker-compose -f "$COMPOSE_FILE" build --no-cache
    echo -e "${GREEN}Rebuild completed!${NC}"
}

up() {
    echo -e "${GREEN}Starting containers for ${MODE} environment...${NC}"
    docker-compose -f "$COMPOSE_FILE" up -d
    echo -e "${GREEN}Containers started!${NC}"
    echo -e "${BLUE}FastAPI:${NC} http://localhost:5056"
    echo -e "${BLUE}API Docs:${NC} http://localhost:5056/docs"
}

down() {
    echo -e "${YELLOW}Stopping containers for ${MODE} environment...${NC}"
    docker-compose -f "$COMPOSE_FILE" down
    echo -e "${GREEN}Containers stopped!${NC}"
}

restart() {
    echo -e "${YELLOW}Restarting containers for ${MODE} environment...${NC}"
    docker-compose -f "$COMPOSE_FILE" restart
    echo -e "${GREEN}Containers restarted!${NC}"
}

logs() {
    echo -e "${BLUE}Showing logs for ${MODE} environment (Ctrl+C to exit)...${NC}"
    docker-compose -f "$COMPOSE_FILE" logs -f
}

logs_tail() {
    echo -e "${BLUE}Showing last 100 lines of logs for ${MODE} environment...${NC}"
    docker-compose -f "$COMPOSE_FILE" logs --tail=100
}

shell() {
    echo -e "${BLUE}Opening shell in ${CONTAINER_NAME}...${NC}"
    docker exec -it "$CONTAINER_NAME" /bin/bash
}

clean() {
    echo -e "${RED}Warning: This will remove containers, volumes, and images for ${MODE} environment!${NC}"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cleaning ${MODE} environment...${NC}"
        docker-compose -f "$COMPOSE_FILE" down -v --rmi all
        echo -e "${GREEN}Clean completed!${NC}"
    else
        echo -e "${BLUE}Clean cancelled.${NC}"
    fi
}

status() {
    echo -e "${BLUE}Container status for ${MODE} environment:${NC}"
    docker-compose -f "$COMPOSE_FILE" ps
}

# Main script logic
COMMAND=${1:-help}

case "$COMMAND" in
    build)
        check_compose_file
        build
        ;;
    rebuild)
        check_compose_file
        rebuild
        ;;
    up)
        check_compose_file
        up
        ;;
    down)
        check_compose_file
        down
        ;;
    restart)
        check_compose_file
        restart
        ;;
    logs)
        check_compose_file
        logs
        ;;
    logs_tail)
        check_compose_file
        logs_tail
        ;;
    shell)
        shell
        ;;
    clean)
        check_compose_file
        clean
        ;;
    status)
        check_compose_file
        status
        ;;
    help|--help|-h)
        print_usage
        ;;
    *)
        echo -e "${RED}Error:${NC} Unknown command '$COMMAND'"
        echo ""
        print_usage
        exit 1
        ;;
esac


