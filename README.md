Glocart Stage - Staging Deployment RepositoryWelcome to the Glocart Stage repository. 
This project contains the complete source code, Infrastructure as Code (Terraform), database configurations, and Kubernetes deployment manifests required to run our application securely in the Google Cloud Platform (GCP) staging environment.

📂 Folder Architecture Overview Below is the directory structure of this repository and the purpose of each component:
```text
glocart-stage/
├── globackend/                          # 1. Backend source code (Node.js & Express API)
│   ├── server.js                        # Main server script
│   ├── package.json                     # Node.js dependencies
│   └── Dockerfile                       # Container build file for backend
│
├── glo-frontend/                        # 2. Frontend source code (Web UI)
│   ├── index.html                       # Frontend web page
│   └── Dockerfile                       # Container build file for frontend
│
├── glo-server/                          # 3. Server helper code, scripts, or database setup files
│   └── schema.sql                       # PostgreSQL database tables setup
│
├── terraform/                           # 4. INFRASTRUCTURE PROVISIONING (Terraform)
│   ├── environments/
│   │   └── stage/
│   │       ├── terraform.tfvars         # Stage environment variable values
│   │       └── backend.hcl              # Remote state storage configuration (GCS bucket)
│   │
│   ├── modules/                         # Reusable infrastructure building blocks
│   │   ├── vpc/                         # Networking: VPC & Subnets
│   │   ├── gke/                         # Compute: Kubernetes cluster (GKE)
│   │   ├── database/                    # Database: Cloud SQL PostgreSQL
│   │   └── iam/                         # Security: Service accounts & permissions
│   │
│   ├── main.tf                          # Root module calling all child modules above
│   ├── variables.tf                     # Global configuration variables
│   ├── outputs.tf                       # Outputs (Cluster endpoint, Database IP)
│   └── provider.tf                      # Cloud provider configuration (GCP)
│
└── deploy/                              # 5. APP ORCHESTRATION & MANIFESTS (YAML / Kustomize)
    ├── base/                            # Baseline Kubernetes manifests shared across environments
    │   ├── namespace.yaml
    │   └── ingress.yaml
    │
    └── overlays/                        # Environment-specific patches
        └── stage/
            ├── backend-deployment.yaml  # Backend deployment & service rules
            ├── frontend-deployment.yaml # Frontend deployment & service rules
            └── kustomization.yaml       # Kustomize compiler configuration
```
🛠️ Prerequisites & Tools

Before working with this repository, ensure you have the following tools installed on your local machine or CI/CD runner:

Terraform (v1.5 or higher)

Google Cloud SDK (gcloud CLI)

Kubernetes CLI (kubectl)

Docker (for building container images)

🚀 Deployment Workflow

Deploying updates to the staging environment follows a strict, secure pipeline:

Provision Infrastructure (Terraform):
Navigate to the terraform stage environment folder, initialize Terraform, and apply the configuration:

cd terraform/environments/stage/
terraform init -backend-config=backend.hcl
terraform apply -var-file="terraform.tfvars"


Build & Push Container Images:
Build the frontend and backend Docker containers and push them to Google Artifact Registry.

Deploy Applications to GKE:
Apply the Kubernetes manifests using Kustomize:
kubectl apply -k deploy/overlays/stage/


Security Standards & Workload Identity Federation

To maintain high security standards, this repository adheres to strict cloud security guidelines:

No Static Service Account Keys: We completely ban downloadable .json service account keys. All CI/CD deployments authenticate using Workload Identity Federation (WIF) via short-lived OIDC tokens.

Least Privilege Access: IAM bindings use precise predefined or custom roles rather than broad primitive roles (owner, editor).

Guardrails: Organization and folder policies prevent public IP creation and public storage bucket exposure.


Step-by-Step Instructions to Build & Deploy
Follow these step-by-step instructions to initialize, provision, and deploy your e-commerce project in a real-time environment.

Step 1: Initialize Your Git Repository Locally
Open your terminal inside your main project folder (glocart-stage) and prepare Git:

Bash
cd glocart-stage
git init
Step 2: Provision Your Infrastructure with Terraform
Navigate to the terraform folder, initialize your remote backend storage, and build your cloud resources (VPC, GKE cluster, Cloud SQL database, IAM roles):

Bash
cd terraform/

# 1. Initialize Terraform using your stage backend configuration
terraform init -backend-config=environments/stage/backend.hcl

# 2. Review the infrastructure plan
terraform plan -var-file=environments/stage/terraform.tfvars

# 3. Apply the configuration to build everything in Google Cloud
terraform apply -var-file=environments/stage/terraform.tfvars -auto-approve
Step 3: Connect kubectl to Your New GKE Cluster
Once Terraform finishes building your Kubernetes cluster, connect your local terminal or CI/CD pipeline to the cluster so you can deploy your application YAML files:

Bash
gcloud container clusters get-credentials glocart-stage-cluster --region asia-south1 --project glocart-stage-infra-2026
Step 4: Build and Push Your Container Images
Before deploying YAML manifests, you need to build Docker images for your frontend and backend and push them to your Google Container Registry (GCR):

Bash
# Move to backend folder and build/push
cd ../globackend
docker build -t gcr.io/glocart-stage-infra-2026/globackend:latest .
docker push gcr.io/glocart-stage-infra-2026/globackend:latest

# Move to frontend folder and build/push
cd ../glo-frontend
docker build -t gcr.io/glocart-stage-infra-2026/glo-frontend:latest .
docker push gcr.io/glocart-stage-infra-2026/glo-frontend:latest
Step 5: Deploy Application Manifests (YAML / Kustomize)
Go back to the root folder and use Kustomize to apply your stage deployment YAML manifests to your GKE cluster:

Bash
cd ../
kubectl apply -k deploy/overlays/stage/
Step 6: Verify Your Deployment
Run the following commands to make sure your pods, services, and ingress are running smoothly:

Bash
kubectl get pods -n glocart
kubectl get services -n glocart
kubectl get ingress -n glocart
