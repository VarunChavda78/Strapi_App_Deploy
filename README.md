# 🚀 Strapi Task 1 - Varun

This project was created as part of the PearlThoughts DevOps Internship program to explore Strapi CMS.

---

## 📦 What's Included

- ✅ Created a new **Collection Type**: `Varun`
- ✅ Fields included in the `Varun` content type:
  - `Full_name` (Text)
  - `Age` (Number)
- All files are in my-strapi-app
---

## 🧪 How to Test

1. **Clone the repository**:
   ```bash
   git clone https://github.com/PearlThoughts-DevOps-Internship/Strapi-Monitor-Hub.git
   cd Strapi-Monitor-Hub/varun-chavda
2. Install dependencies:
    ```npm install```
3. Start the Stapi Server:
    ```npm run develop```

Here’s a professional set of lines you can add to your `README.md` file for **Task 2**:


## 🚀 Task 2: Dockerize Strapi Application

This task involves containerizing the Strapi backend application using Docker.

### ✅ Steps Performed:

* Created a `Dockerfile` using the official `node:20` image.
* Installed dependencies and built for compatibility inside Docker.
* Exposed Strapi's default port (`1337`) and ran the app in development mode.

### 🐳 Docker Commands Used:

```bash
docker build -t strapi-dockerized .
docker run -it -p 1337:1337 strapi-dockerized
```

> The `-it` flag ensures interactive terminal access, and `-p` maps container port 1337 to local port 1337.

---

# 🚀 Strapi Production Setup with PostgreSQL & Nginx (Dockerized)

This repository contains a production-ready setup of a Strapi CMS backend using:

- ✅ **Strapi** (Node.js Headless CMS)
- ✅ **PostgreSQL** as the production database
- ✅ **Docker & Docker Compose**
- ✅ **Nginx** as a reverse proxy (exposes Strapi on port 80)

---

## 📁 Project Structure

```

├── strapi-app/
│   └── .env/               # .env file
│   └── Dockerfile          # Dockerfile for strapi app
├── docker-compose.yml      # Docker multi-container orchestration
├── nginx
│    └── default.conf       # Nginx reverse proxy configuration
└── README.md               # This documentation

````

---

## 🛠️ Prerequisites

- Docker
- Docker Compose

---

## 🚀 How to Run (Production)

```bash
# From root directory
docker-compose up -d --build
```

Once running, access:

* **Strapi Admin**: `http://localhost`
* (Internally: Strapi runs on port `1337` and is reverse proxied by Nginx)

---
Task - 4
---