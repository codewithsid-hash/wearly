FROM python:3.10.11-slim
 
# Install system dependencies (add more as needed)
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential wget git && \
    rm -rf /var/lib/apt/lists/*
 
# Create app directory
WORKDIR /app
 
# (Optional) Copy requirements first and install
COPY requirements.txt /app/
RUN pip install --no-cache-dir --upgrade pip && \
    if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi
 
 
COPY . /app
 
# Expose 8080 for your web/API server
EXPOSE 8080
 
 
 CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080", "--reload"]
 