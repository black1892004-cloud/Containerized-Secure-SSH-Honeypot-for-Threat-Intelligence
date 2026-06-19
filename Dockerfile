FROM python:3.9-slim-buster

WORKDIR /opt/cowrie

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-dev \
    libssl-dev \
    libffi-dev \
    build-essential \
    libpython3-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone Cowrie and install it
RUN git clone https://github.com/cowrie/cowrie.git .
RUN pip install --no-cache-dir -r requirements.txt

# Create necessary directories and set permissions
RUN useradd --create-home --shell /bin/bash cowrie
RUN chown -R cowrie:cowrie /opt/cowrie

# Expose the SSH port (default 2222 for Cowrie)
EXPOSE 2222

# Switch to the cowrie user
USER cowrie

# Command to run Cowrie
CMD ["/opt/cowrie/bin/cowrie", "start", "--no-detach"]
