FROM n8nio/n8n

USER root

# Nâng cấp lệnh RUN để thêm các công cụ build, sau đó dọn dẹp chúng
RUN apk add --no-cache \
        # Các công cụ cũ
        ffmpeg \
        python3 \
        py3-pip \
        py3-virtualenv \
        git \
        # THÊM MỚI: "Bộ dụng cụ" để build
        build-base \
        python3-dev \
    # Bắt đầu quá trình cài đặt (giữ nguyên logic gốc)
    && python3 -m venv /opt/ytvenv \
    && /opt/ytvenv/bin/pip install --upgrade pip \
    && /opt/ytvenv/bin/pip install --no-cache-dir \
        yt-dlp \
        git+https://github.com/openai/whisper.git \
    # Dọn dẹp "bộ dụng cụ" sau khi đã cài đặt xong để giảm kích thước image
    && apk del build-base python3-dev \
    # Tạo lối tắt (giữ nguyên logic gốc)
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
