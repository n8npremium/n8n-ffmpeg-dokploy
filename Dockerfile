# BƯỚC 1: THAY ĐỔI NỀN TẢNG
# Bắt đầu từ image n8n chính thức (dựa trên Debian, tương thích với torch)
FROM n8nio/n8n:latest

# Chuyển sang người dùng root để có quyền cài đặt
USER root

# BƯỚC 2: "DỊCH" LỆNH CÀI ĐẶT SANG apt-get
# Cài đặt các công cụ nền tảng bằng apt-get (công cụ của Debian)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
    python3-venv \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# BƯỚC 3: CÀI ĐẶT CÁC GÓI PYTHON (Giữ nguyên logic gốc của chuyên gia)
# Giữ nguyên logic sử dụng môi trường ảo (venv) để đảm bảo an toàn
RUN python3 -m venv /opt/pyvenv \
    && /opt/pyvenv/bin/pip install --upgrade pip \
    && /opt/pyvenv/bin/pip install --no-cache-dir \
        yt-dlp \
        torch \
        torchaudio \
        git+https://github.com/openai/whisper.git \
    && ln -s /opt/pyvenv/bin/yt-dlp /usr/local/bin/yt-dlp \
    && ln -s /opt/pyvenv/bin/whisper /usr/local/bin/whisper

# Giữ nguyên phần cài đặt node n8n tùy chỉnh của bạn
RUN mkdir -p /home/node/.n8n/nodes \
 && cd /home/node/.n8n/nodes \
 && npm init -y \
 && npm install n8n-nodes-zalo-user-v3
 
# Giữ nguyên phần sửa quyền sở hữu
RUN chown -R node:node /home/node/.n8n

# Giữ nguyên việc chuyển về người dùng 'node'
USER node
