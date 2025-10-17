# Bắt đầu từ image n8n chính thức (nền tảng Alpine đã được xác nhận)
FROM n8nio/n8n

# Chuyển sang người dùng root để có quyền cài đặt
USER root

# Nâng cấp lệnh RUN gốc để thêm 'git', sau đó cài đặt cả 'yt-dlp' và 'whisper' vào cùng môi trường ảo
RUN apk add --no-cache \
        ffmpeg \
        python3 \
        py3-pip \
        py3-virtualenv \
        git \
    && python3 -m venv /opt/ytvenv \
    && /opt/ytvenv/bin/pip install --no-cache-dir \
        yt-dlp \
        git+https://github.com/openai/whisper.git \
    && ln -s /opt/ytvenv/bin/yt-dlp /usr/local/bin/yt-dlp \
    && ln -s /opt/ytvenv/bin/whisper /usr/local/bin/whisper

# Giữ nguyên biến môi trường PATH
ENV PATH=/opt/ytvenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

# Giữ nguyên phần cài đặt node n8n tùy chỉnh của bạn
RUN mkdir -p /home/node/.n8n/nodes \
 && cd /home/node/.n8n/nodes \
 && npm init -y \
 && npm install n8n-nodes-zalo-user-v3
 
# Giữ nguyên phần sửa quyền sở hữu
RUN chown -R node:node /home/node/.n8n

# Giữ nguyên việc chuyển về người dùng 'node'
USER node
