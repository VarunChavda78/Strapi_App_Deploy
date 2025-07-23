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

# 🚀 Task 3: Strapi Production Setup with PostgreSQL & Nginx (Dockerized)

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


Here is a `README.md` file for your **Terraform-based Strapi + PostgreSQL Deployment on AWS EC2 with Docker**:

---

# 🚀 Task 4: Terraform Deployment: Strapi + PostgreSQL on AWS EC2 with Docker

This project automates the deployment of a Dockerized Strapi application and a PostgreSQL container on an Ubuntu-based AWS EC2 instance using Terraform.

## 📦 What This Project Does

- Provisions an Ubuntu EC2 instance in the `us-east-2` region.
- Installs Docker and Docker Compose on the instance.
- Runs a PostgreSQL container for the Strapi backend.
- Pulls a prebuilt Strapi Docker image from Docker Hub.
- Runs the Strapi container and connects it to the PostgreSQL container via a custom Docker network.
- Uses a custom SSH key pair for secure access.

---

## 📁 Project Structure

```

terraform-strapi-deploy/
│
├── main.tf           # EC2 instance creation and Docker setup
├── variable.tf       # Input variables
├── outputs.tf         # Outputs like public IP
├── terraform.tfvars  # store variables
└── README.md         # Project overview and instructions

````

## 🔐 Security Group Rules

- Port `22`: SSH access
- Port `1337`: Strapi Admin Panel
- Port `5432`: (Optional) PostgreSQL access (for debugging)

---

## 🔧 How It Works (User Data Boot Script)

```bash
#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker
docker network create strapi-net

# Run PostgreSQL container
docker run -d --name postgres --network strapi-net \
  -e POSTGRES_DB=strapi \
  -e POSTGRES_USER=strapi \
  -e POSTGRES_PASSWORD=strapi \
  -v /srv/pgdata:/var/lib/postgresql/data \
  postgres:15

# Run Strapi container from Docker Hub image
docker pull varunchavda78/strapi-app:latest
docker run -d --name strapi --network strapi-net \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=postgres \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=strapi \
  -e DATABASE_USERNAME=strapi \
  -e DATABASE_PASSWORD=strapi \
  -e APP_KEYS=... \
  -e API_TOKEN_SALT=... \
  -e ADMIN_JWT_SECRET=... \
  -p 1337:1337 \
  varunchavda78/strapi-app:latest
````

---

## ⚙️ How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

Once deployed, SSH into the instance using the `.pem` key:

```bash
ssh -i strapi-key.pem ubuntu@<public_ip>
```

Then access Strapi Admin Panel:

```url
http://<public_ip>:1337
```

---

## 📤 Outputs

* `public_ip`: The public IP address of the EC2 instance 

---

# 🚀 Task 5 - Strapi Automated Deployment with GitHub Actions & Terraform

This project automates the deployment of a Dockerized Strapi application to an AWS EC2 instance using **GitHub Actions** for CI/CD and **Terraform** for infrastructure provisioning.

---

## 📌 Objective

* Automate Docker image build & push using GitHub Actions on every push to `main`.
* Deploy the updated Docker image on an EC2 instance using Terraform.
* Trigger the Terraform workflow manually.

---

## ✅ Task Breakdown

### 1️⃣ Continuous Integration (CI) – Docker Build & Push

**Workflow File:** `.github/workflows/ci.yml`

#### Trigger:

* Automatically runs on every push to the `main` branch.

#### Actions Performed:

* Checkout source code.
* Log in to Docker Hub using GitHub Secrets.
* Build Docker image for the Strapi app from `./Strapi-app`.
* Push image to Docker Hub with the `latest` tag.
* Save the image tag to an artifact named `image-tag`.

#### Docker Image Tag Format:

* `your-dockerhub-username/strapi-app:latest`

---

### 2️⃣ Continuous Deployment (CD) – Terraform-based Infrastructure

**Workflow File:** `.github/workflows/terraform-deploy.yml`

#### Trigger:

* Automatically runs **after successful CI pipeline**.

#### Actions Performed:

* Download artifact (`image-tag`) from the CI workflow.
* Configure AWS credentials using GitHub Secrets.
* Run `terraform init` and `terraform apply` inside `Terraform1/` directory.
* Variables passed to Terraform:

  * `image_tag=latest`
  * `ami_id=ami-0d1b5a8c13042c939`
  * `key_name=strapii-key`
  * `aws_region=us-east-2`
  * `instance_type=t2.micro`

---

## 🔐 GitHub Secrets Used

| Secret Name             | Purpose                              |
| ----------------------- | ------------------------------------ |
| `DOCKERHUB_USERNAME`    | Docker Hub username                  |
| `DOCKERHUB_PASSWORD`    | Docker Hub password/token            |
| `AWS_ACCESS_KEY_ID`     | AWS Access Key ID                    |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key                |
| `GITHUB_TOKEN`          | Auto-injected GitHub token (default) |

---

## 🧪 Verification

* After the workflow finishes, go to the EC2 instance.
* Access the deployed Strapi application using **public IP**:

  ```
  http://<EC2_PUBLIC_IP>:1337
  ```

---

## 📁 Project Structure

```
Strapi-Monitor-Hub/
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── terraform-deploy.yml
│
├── Strapi-app/
│   └── Dockerfile
│
├── Terraform2/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── README.md
```

---

## 🛠 Technologies Used

* **GitHub Actions**
* **Terraform**
* **Docker**
* **AWS EC2**
* **Strapi CMS**

---
