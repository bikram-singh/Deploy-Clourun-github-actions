# Use the official Python image from the Docker Hub
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy dependency files
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copy the app code
COPY . .

# Set the entrypoint
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
