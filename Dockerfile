# Set the python version as a build-time argument
ARG PYTHON_VERSION=3.12-slim-bullseye
FROM python:${PYTHON_VERSION}

# Install pipenv
RUN pip install pipenv

# Set Python-related environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install OS dependencies for PostgreSQL, Pillow, CairoSVG, and others
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libjpeg-dev \
    libcairo2 \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create the directory for your project code
RUN mkdir -p /code

# Set the working directory
WORKDIR /code

# Copy the Pipfile and Pipfile.lock first, to leverage Docker cache
COPY Pipfile* /code/

# Install Python dependencies using pipenv
# Install system-wide so it does not create its own virtual environment
RUN pipenv install --deploy --system

# Copy the rest of the application code
COPY ./src /code

RUN python manage.py pull_vendor_staticfiles
RUN python manage.py collectstatic --no-input

# Set the Django default project name
ARG PROJ_NAME="cfehome"

# Create a bash script to run the Django project
RUN printf "#!/bin/bash\n" > ./paracord_runner.sh && \
    printf "RUN_PORT=\"\${PORT:-8000}\"\n\n" >> ./paracord_runner.sh && \
    printf "python manage.py migrate --no-input\n" >> ./paracord_runner.sh && \
    printf "gunicorn ${PROJ_NAME}.wsgi:application --bind \"0.0.0.0:\$RUN_PORT\"\n" >> ./paracord_runner.sh

# Make the bash script executable
RUN chmod +x paracord_runner.sh

# Clean up apt cache to reduce image size
RUN apt-get remove --purge -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Run the Django project via the runtime script when the container starts
CMD ./paracord_runner.sh
