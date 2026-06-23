# Local Development

## Backend

cd backend

docker build -t backend:v1 .

docker run -p 8000:8000 backend:v1

http://localhost:8000/health

## Frontend

cd frontend

docker build -t frontend:v1 .

docker run -p 3000:80 frontend:v1

http://localhost:3000