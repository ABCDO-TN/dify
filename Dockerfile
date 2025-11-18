# Step 1: Use the official Python 3.10 slim image as a base
FROM python:3.10-slim

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Step 4: Install Poetry
ENV POETRY_HOME="/opt/poetry"
ENV PATH="$POETRY_HOME/bin:$PATH"
RUN curl -sSL https://install.python-poetry.org | python3 -

# Step 5: Copy dependency definition files from the "api" subfolder
COPY api/pyproject.toml api/poetry.lock* /app/
# The '*' handles the case where poetry.lock might not exist initially

# Step 6: Install dependencies
# This will create a lock file if one doesn't exist
RUN poetry install --no-root --no-dev

# Step 7: Copy the entire application source code from the "api" subfolder
COPY api/ /app/

# Step 8: Copy our new start.sh script from the root of the repo
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Step 9: Expose the port the application will run on
EXPOSE 7860

# Step 10: Set the command to run the startup script
CMD ["/app/start.sh"]
