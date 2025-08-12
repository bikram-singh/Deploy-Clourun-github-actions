# Deploy Flask App to Google Cloud Run using GitHub Actions

[![Build and Deploy to Cloud Run](https://github.com/bikram-singh/Deploy-Clourun-github-actions/actions/workflows/google-cloudrun-docker.yml/badge.svg)](https://github.com/bikram-singh/Deploy-Clourun-github-actions/actions/workflows/google-cloudrun-docker.yml)

This repository demonstrates how to automatically deploy a Flask application to Google Cloud Run using GitHub Actions. It showcases a complete CI/CD pipeline that builds a Docker container, pushes it to Google Artifact Registry, and deploys it to Cloud Run whenever code is pushed to the main branch.

## 🚀 Features

- **Automated Deployment**: Continuous deployment triggered on every push to the main branch
- **Containerized Application**: Flask app packaged in a lightweight Docker container
- **Google Cloud Integration**: Uses Google Artifact Registry for container storage and Cloud Run for hosting
- **Secure Authentication**: Service account-based authentication with GitHub Secrets
- **Production Ready**: Uses Gunicorn WSGI server for production deployment

## 📁 Project Structure

```
Deploy-Clourun-github-actions/
├── .github/
│   └── workflows/
│       └── google-cloudrun-docker.yml    # GitHub Actions workflow
├── app.py                                 # Flask application
├── Dockerfile                             # Docker configuration
├── requirements.txt                       # Python dependencies
└── README.md                             # Project documentation
```

## 🛠️ Application Overview

### Flask Application (`app.py`)
A simple Flask web application that serves a welcome message:

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, This service is deploy using GitHub Actions on Cloud Run_v3!"
```

### Dependencies (`requirements.txt`)
- **Flask 2.3.3**: Web framework for Python
- **Gunicorn 21.2.0**: WSGI HTTP Server for Python applications

### Docker Configuration (`Dockerfile`)
- **Base Image**: `python:3.11-slim` for optimal size and security
- **Working Directory**: `/app`
- **Port**: 8080 (Cloud Run standard)
- **Server**: Gunicorn with production-ready configuration

## 🔄 CI/CD Workflow

The GitHub Actions workflow (`.github/workflows/google-cloudrun-docker.yml`) automates the entire deployment process:

### Workflow Triggers
- Runs on every push to the `main` branch

### Deployment Steps
1. **Code Checkout**: Retrieves the latest code from the repository
2. **GCP Authentication**: Authenticates using service account credentials
3. **Docker Configuration**: Sets up Docker authentication with Artifact Registry
4. **Container Build & Push**: Builds Docker image and pushes to Artifact Registry
5. **Cloud Run Deployment**: Deploys the container to Cloud Run
6. **URL Display**: Shows the deployed service URL

### Environment Variables
The workflow uses these configurable environment variables:

```yaml
env:
  PROJECT_ID: 'github-actions-111'        # Your GCP project ID
  REGION: 'us-central1'                   # GCP region for deployment
  SERVICE: 'my-flask-app'                 # Cloud Run service name
  REPOSITORY: 'github-action-artifact'    # Artifact Registry repository
```

## ⚙️ Setup Instructions

### Prerequisites
- Google Cloud Platform account with billing enabled
- GitHub repository with this code
- Docker knowledge (basic understanding)

### 1. Enable Google Cloud APIs
Enable the following APIs in your GCP project:
```bash
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com
```

### 2. Create Artifact Registry Repository
```bash
gcloud artifacts repositories create github-action-artifact \
    --repository-format=docker \
    --location=us-central1 \
    --description="Repository for GitHub Actions deployments"
```

### 3. Create Service Account
Create a service account with necessary permissions:
```bash
# Create service account
gcloud iam service-accounts create github-actions-sa \
    --display-name="GitHub Actions Service Account"

# Add required roles
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/run.developer"
```

### 4. Generate Service Account Key
```bash
gcloud iam service-accounts keys create key.json \
    --iam-account=github-actions-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

### 5. Configure GitHub Secrets
In your GitHub repository, go to Settings → Secrets and variables → Actions, and add:

- **`GCP_CREDENTIALS`**: Content of the `key.json` file (entire JSON content)

### 6. Update Workflow Configuration
Edit `.github/workflows/google-cloudrun-docker.yml` and update the environment variables:

```yaml
env:
  PROJECT_ID: 'your-actual-project-id'
  REGION: 'your-preferred-region'
  SERVICE: 'your-service-name'
  REPOSITORY: 'your-artifact-repo-name'
```

## 🚀 Deployment Process

1. **Push to Main**: Push your changes to the main branch
2. **Automatic Trigger**: GitHub Actions workflow starts automatically
3. **Build & Deploy**: The workflow builds, pushes, and deploys your application
4. **Live Service**: Your Flask app is now live on Cloud Run

## 📊 Workflow Status

You can monitor the deployment status in the "Actions" tab of your GitHub repository. The workflow provides detailed logs for each step of the deployment process.

## 🌐 Accessing Your Application

After successful deployment, your Flask application will be available at:
```
https://SERVICE_NAME-PROJECT_HASH-REGION.a.run.app
```

The exact URL will be displayed in the workflow logs under the "Show Deployed URL" step.

## 🔧 Local Development

### Running Locally
```bash
# Clone the repository
git clone https://github.com/bikram-singh/Deploy-Clourun-github-actions.git
cd Deploy-Clourun-github-actions

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

### Testing with Docker
```bash
# Build the Docker image
docker build -t flask-app .

# Run the container
docker run -p 8080:8080 flask-app
```

## 🛡️ Security Best Practices

- Service account keys are stored as GitHub Secrets
- Minimal IAM permissions are granted to the service account
- Docker image uses slim Python base image for reduced attack surface
- Authentication is handled through Google Cloud's official GitHub Actions

## 🚨 Troubleshooting

### Common Issues

1. **Authentication Errors**: Verify that `GCP_CREDENTIALS` secret contains valid JSON
2. **Permission Denied**: Ensure service account has required IAM roles
3. **Build Failures**: Check Dockerfile syntax and dependencies in requirements.txt
4. **Deployment Failures**: Verify that Cloud Run API is enabled and region is correct

### Debugging Steps
1. Check GitHub Actions logs for detailed error messages
2. Verify GCP project settings and API enablement
3. Test Docker build locally before pushing
4. Ensure all environment variables are correctly set

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Support

If you encounter any issues or have questions, please:
1. Check the troubleshooting section above
2. Review the GitHub Actions logs
3. Open an issue in this repository

---

**Happy Deploying! 🎉**

This project demonstrates the power of combining GitHub Actions with Google Cloud Run for seamless, automated deployments. Feel free to customize it according to your specific needs!