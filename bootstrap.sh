#!/bin/bash
set -e

# Usage: ./bootstrap_envs.sh dev staging prod

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <env1> <env2> ... "
  exit 1
fi

ENVIRONMENTS=("$@")
PROJECT_PREFIX="my-biquery-demo"
SA_NAME="terraform-sa"
REGION="us-central1"

for ENV in "${ENVIRONMENTS[@]}"; do
  PROJECT_ID="${PROJECT_PREFIX}-${ENV}"

  echo "➡️  Creating project: $PROJECT_ID"
  gcloud projects create "$PROJECT_ID" --name="BigQuery Demo $ENV" || echo "Project $PROJECT_ID may already exist"

  echo "➡️  Enabling APIs for $PROJECT_ID"
  gcloud services enable \
      cloudresourcemanager.googleapis.com \
      compute.googleapis.com \
      bigquery.googleapis.com \
      storage.googleapis.com \
      iam.googleapis.com \
      --project "$PROJECT_ID"

  echo "➡️  Creating service account: $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
  gcloud iam service-accounts create "$SA_NAME" \
      --display-name "Terraform Service Account" \
      --project "$PROJECT_ID" || echo "Service account may already exist"

  echo "➡️  Granting Owner role to service account (can adjust to least privilege)"
  gcloud projects add-iam-policy-binding "$PROJECT_ID" \
      --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/owner"

  BUCKET_NAME="tf-state-${PROJECT_ID}-${ENV}"
  echo "➡️  Creating backend bucket: gs://$BUCKET_NAME"
  gsutil mb -l "$REGION" "gs://$BUCKET_NAME" || echo "Bucket may already exist"

  echo "➡️  Enabling versioning on bucket: $BUCKET_NAME"
  gsutil versioning set on "gs://$BUCKET_NAME"

  echo "➡️  Creating service account key for Terraform"
  gcloud iam service-accounts keys create "./${PROJECT_ID}-${SA_NAME}-key.json" \
      --iam-account "${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

  echo "✅ Environment $ENV bootstrapped!"
done

echo "🎉 All requested environments bootstrapped!"