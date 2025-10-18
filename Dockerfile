FROM n8nio/n8n

USER root

# Cài đặt essentials cho Alpine
RUN apk add --no-cache \
    curl \
    bash \
    ffmpeg \
    python3 \
    py3-pip \
    py3-virtualenv \
    build-base \
    python3-dev \
    libffi-dev \
    openssl-dev \
    git \
    linux-headers

# Cài Rust từ rustup (không dùng cargo từ apk)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

# Source Rust environment
ENV PATH="/root/.cargo/bin:${PATH}"

# Cài venv
RUN python3 -m venv /opt/ytvenv && \
    /opt/ytvenv/bin/pip install --upgrade pip setuptools wheel setuptools-rust

# Cài Whisper + yt-dlp
RUN /opt/ytvenv/bin/pip install --no-cache-dir \
    yt-dlp \
    openai-whisper

# Symlinks
RUN ln -s /opt/ytvenv/bin/yt-dlp /usr/local/bin/yt-dlp && \
    ln -s /opt/ytvenv/bin/whisper /usr/local/bin/whisper

ENV PATH=/opt/ytvenv/bin:/root/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Cài n8n nodes
RUN mkdir -p /home/node/.n8n/nodes \
    && cd /home/node/.n8n/nodes \
    && npm init -y \
    && npm install n8n-nodes-zalo-user-v3

RUN chown -R node:node /home/node/.n8n

USER node
