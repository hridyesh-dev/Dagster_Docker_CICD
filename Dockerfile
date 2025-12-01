
# Dockerfile
FROM python:3.12-slim

# System deps for native wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl \
    && rm -rf /var/lib/apt/lists/*

# Dagster home and working directory
ENV DAGSTER_HOME=/opt/dagster/home
WORKDIR /opt/dagster/app

# Install dependencies (option A: requirements.txt)
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# OPTIONAL (Option B): install as editable package using pyproject
# This makes `etl` importable without needing PYTHONPATH
RUN pip install --no-cache-dir -e .

# Create Dagster home
RUN mkdir -p ${DAGSTER_HOME}

EXPOSE 3000

# Default command (compose overrides with workspace flag)
CMD ["dagster", "dev", "-h", "0.0.0.0", "-p", "3000"]
