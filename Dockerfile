FROM node:18-slim

USER root

# Cài essentials
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-venv \
    python3-pip \
    python3-dev \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Tạo user node
RUN useradd -m -s /bin/bash node && \
    mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node

# Tạo venv
RUN python3 -m venv /opt/ytvenv && \
    /opt/ytvenv/bin/pip install --upgrade pip setuptools wheel

# Cài Whisper + dependencies
RUN /opt/ytvenv/bin/pip install --no-cache-dir \
    torch \
    torchaudio \
    openai-whisper \
    yt-dlp

# Symlinks
RUN ln -s /opt/ytvenv/bin/yt-dlp /usr/local/bin/yt-dlp && \
    ln -s /opt/ytvenv/bin/whisper /usr/local/bin/whisper

ENV PATH=/opt/ytvenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# n8n nodes
RUN mkdir -p /home/node/.n8n/nodes \
    && cd /home/node/.n8n/nodes \
    && npm init -y \
    && npm install n8n-nodes-zalo-user-v3

RUN chown -R node:node /home/node/.n8n

USER node
