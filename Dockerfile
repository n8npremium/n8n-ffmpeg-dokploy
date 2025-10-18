FROM node:18-bullseye

# Cài đặt ffmpeg, python, build tools
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-venv \
    python3-pip \
    python3-dev \
    build-essential \
    rustc \
    cargo \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Tạo user node
RUN useradd -m -s /bin/bash node && \
    mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node

# Tạo venv cho faster-whisper
RUN python3 -m venv /opt/ytvenv && \
    /opt/ytvenv/bin/pip install --upgrade pip setuptools wheel

# Cài yt-dlp và faster-whisper
RUN /opt/ytvenv/bin/pip install --no-cache-dir \
    yt-dlp \
    faster-whisper \
    pydub

# Tạo symlink
RUN ln -s /opt/ytvenv/bin/yt-dlp /usr/local/bin/yt-dlp

ENV PATH=/opt/ytvenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Cài npm packages cho n8n
RUN mkdir -p /home/node/.n8n/nodes \
    && cd /home/node/.n8n/nodes \
    && npm init -y \
    && npm install n8n-nodes-zalo-user-v3

RUN chown -R node:node /home/node/.n8n

# Cài n8n globally
RUN npm install -g n8n

USER node
WORKDIR /home/node

EXPOSE 5678

CMD ["n8n"]
