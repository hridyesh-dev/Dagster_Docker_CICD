
FROM python:3.12-slim

ENV DAGSTER_HOME=/opt/dagster/home
WORKDIR /opt/dagster/app

# System build deps for pandas wheels (and general compilation)
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy project metadata and source BEFORE installing
COPY pyproject.toml ./
COPY src/ ./src
COPY data/ ./data

# Install package + deps from pyproject
RUN python -m pip install --upgrade pip wheel \
    && pip install --no-cache-dir . \
    && pip cache purge

# Create Dagster home and non-root user
RUN mkdir -p "${DAGSTER_HOME}" \
    && useradd -m -u 10001 dagster \
    && chown -R dagster:dagster /opt/dagster
USER dagster

EXPOSE 3000
CMD ["dagster", "dev", "-h", "0.0.0.0", "-p", "3000"]
