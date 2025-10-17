# n8n Self-Hosted with Redis Queue & PostgreSQL ok

This project provides a production-ready setup for running [n8n](https://n8n.io/) using Docker Compose with the following features:

- Queue mode using Redis for distributed workers
- PostgreSQL as the database

---

## 📁 Project Structure

```plaintext
.
├── Dockerfile
├── docker-compose.yml
├── .env
└── README.md
```

---

## ⚙️ Environment Configuration

Create a `.env` file (already included) with your default configuration.

```env
# .env

N8N_HOST=yourdomain.webpilot.cc
N8N_PORT=5678
GENERIC_TIMEZONE=Asia/Ho_Chi_Minh

DB_POSTGRESDB_HOST=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres

ENCRYPTION_KEY=changeEncryptionKey
```

> ⚠️ **Do not commit secrets**. Move sensitive data (like passwords and encryption keys) to `.env.production.local`, which is automatically loaded by Docker Compose and ignored by Git.

---

## 🚀 Running the Stack

### 1. Build and Start Services

```bash
docker compose up -d --build
```

This will start:
- `n8n`: Main application server
- `n8n-worker`: Separate queue worker
- `redis`: Queue backend

> PostgreSQL is assumed to be external. If needed, you can add it to the `docker-compose.yml`.

---

## 🔐 Security Notes

- Set a **strong** `ENCRYPTION_KEY` (32+ characters). Use `openssl rand -base64 32` to generate one.
- Make sure `N8N_HOST` is set correctly, especially if you're behind a reverse proxy.
- Set `N8N_PROTOCOL=https` if you're serving behind SSL.

---

## 🌐 Reverse Proxy

This setup assumes you're using an **external Docker network** (`dokploy-network`). You can attach it to a reverse proxy (like Traefik) for TLS termination and public access.

Example for Traefik:

```yaml
networks:
  dokploy-network:
    external: true
```

---

## 🧪 Health Checks

Redis and `n8n` have health checks configured to ensure proper startup order and stability when using queue mode.

---

## 📦 Volumes

- `n8n_storage`: Stores workflows, credentials, and settings.
- `redis_storage`: Persists Redis queue data.

---

## 🛠 Additional Tips

- Scale workers by running multiple instances of `n8n-worker`.

---

## 📚 References

- [n8n Docs](https://docs.n8n.io)
- [n8n Docker Setup](https://docs.n8n.io/hosting/docker/)
- [Queue Mode Setup](https://docs.n8n.io/hosting/queue-mode/)

---

## 🧼 Cleaning Up

```bash
docker compose down -v
```

To stop and remove all containers and volumes.

---

## ✍️ Author

Maintained by [Thành AI]
