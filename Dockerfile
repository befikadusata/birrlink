# Use the official Python 3.12 Alpine base image
FROM python:3.12-alpine3.20

# Set a label for the maintainer
LABEL maintainer="CodeUmwelt"

# Set Python to not buffer output
ENV PYTHONUNBUFFERED=1

# Copy requirements file to a temporary location
COPY requirements.txt /tmp/requirements.txt

# Copy the application code
COPY ./birrlink /birrlink

# Set the working directory
WORKDIR /birrlink

# Expose the application port
EXPOSE 8000

# Install system dependencies and set up the Python environment
#RUN apk add --no-cache gcc musl-dev libffi-dev python3-dev && \

# Install required packages
RUN apk add --no-cache gcc musl-dev libffi-dev openssl-dev python3-dev postgresql-dev

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Update PATH to prioritize virtual environment binaries
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user

# Default command (optional, if your app requires one)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
