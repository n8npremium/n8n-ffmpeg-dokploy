FROM n8nio/n8n

USER root

# Cài đặt essentials
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
    linux-headers \
    musl-dev

# Cài Rust từ rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

ENV PATH="/root/.cargo/bin:${PATH}"

# Cài venv + upgrade pip
RUN python3 -m venv /opt/ytvenv && \
    /opt/ytvenv/bin/pip install --upgrade pip setuptools wheel setuptools-rust

# Cài yt-dlp trước (dễ hơn)
RUN /opt/ytvenv/bin/pip install --no-cache-dir yt-dlp

# Cài tiktoken (dependency quan trọng)
RUN /opt/ytvenv/bin/pip install --no-cache-dir tiktoken

# Cài Whisper từ source (tránh wheel issues)
RUN /opt/ytvenv/bin/pip install --no-cache-dir git+https://github.com/openai/whisper.git

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
