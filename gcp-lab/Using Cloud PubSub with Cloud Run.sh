#!/bin/bash

# ============================================================
# GCP LAB KEY TAKEAWAY
# Pub/Sub + Cloud Run Integration (Serverless Architecture)
# ============================================================

# This script summarizes the complete MVP implementation:
# - Enable required APIs
# - Deploy producer (public) and consumer (private) Cloud Run services
# - Create Pub/Sub topic
# - Create service account with proper IAM roles
# - Create push subscription to Cloud Run
# - Test end-to-end message flow
#
# Architecture Goal:
# Achieve LOW COUPLING and HIGH RESILIENCE using Pub/Sub
# between microservices running on Cloud Run.
# ============================================================


# ------------------------------------------------------------
# STEP 1: Enable Required APIs
# ------------------------------------------------------------

# Enable Cloud Run API
# REQUIRED because Cloud Run services cannot be deployed
# unless the API is enabled.
gcloud services enable run.googleapis.com

# (Lab required re-enabling Pub/Sub API manually via Console)
# In real-world automation, ensure Pub/Sub API is enabled:
gcloud services enable pubsub.googleapis.com


# ------------------------------------------------------------
# STEP 2: Configure Region
# ------------------------------------------------------------

# Set deployment region (replace with your lab region)
LOCATION=us-central1

# Configure gcloud default compute region
# REQUIRED so you don't have to specify --region repeatedly.
gcloud config set compute/region $LOCATION


# ------------------------------------------------------------
# STEP 3: Deploy Producer Service (Public)
# ------------------------------------------------------------

# Producer = store-service
# This service accepts public HTTP requests (purchase orders).
# It must:
# - Be publicly accessible
# - Allow unauthenticated access
# WHY?
# Because customers on the internet must place orders.

gcloud run deploy store-service \
  --image gcr.io/qwiklabs-resources/gsp724-store-service \
  --region $LOCATION \
  --allow-unauthenticated


# ------------------------------------------------------------
# STEP 4: Deploy Consumer Service (Private)
# ------------------------------------------------------------

# Consumer = order-service
# This service processes backend orders.
# It must:
# - NOT be publicly accessible
# - Only be invoked by authenticated identities
# WHY?
# To protect internal processing logic.

gcloud run deploy order-service \
  --image gcr.io/qwiklabs-resources/gsp724-order-service \
  --region $LOCATION \
  --no-allow-unauthenticated


# ------------------------------------------------------------
# STEP 5: Create Pub/Sub Topic
# ------------------------------------------------------------

# Topic acts as the asynchronous message broker.
# WHY?
# It decouples producer and consumer.
# Producer does NOT need to know about the consumer.
# Messages are stored reliably until delivered.

gcloud pubsub topics create ORDER_PLACED


# ------------------------------------------------------------
# STEP 6: Create Service Account
# ------------------------------------------------------------

# Create dedicated service account for Pub/Sub push
# WHY?
# Pub/Sub needs an identity to securely invoke Cloud Run.

gcloud iam service-accounts create pubsub-cloud-run-invoker \
  --display-name "Order Initiator"

# Verify service account creation
gcloud iam service-accounts list --filter="Order Initiator"


# ------------------------------------------------------------
# STEP 7: Grant Cloud Run Invoker Role
# ------------------------------------------------------------

# Grant permission so this service account
# can invoke the PRIVATE order-service.
# WHY?
# Without roles/run.invoker, push delivery would fail (403).

gcloud run services add-iam-policy-binding order-service \
  --region $LOCATION \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker \
  --platform managed


# ------------------------------------------------------------
# STEP 8: Allow Pub/Sub to Create Auth Tokens
# ------------------------------------------------------------

# Retrieve project number
PROJECT_NUMBER=$(gcloud projects describe $GOOGLE_CLOUD_PROJECT \
  --format='value(projectNumber)')

# Grant Pub/Sub service agent permission to mint tokens
# WHY?
# Required for authenticated push subscriptions.
# Without this, Pub/Sub cannot generate identity tokens.

gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountTokenCreator


# ------------------------------------------------------------
# STEP 9: Create Push Subscription
# ------------------------------------------------------------

# Get private order-service URL
ORDER_SERVICE_URL=$(gcloud run services describe order-service \
  --region $LOCATION \
  --format="value(status.address.url)")

# Create subscription with:
# - Push endpoint (Cloud Run URL)
# - Authenticated service account
# WHY?
# This connects Pub/Sub -> Cloud Run securely.

gcloud pubsub subscriptions create order-service-sub \
  --topic ORDER_PLACED \
  --push-endpoint=$ORDER_SERVICE_URL \
  --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com


# ------------------------------------------------------------
# STEP 10: Test End-to-End Flow
# ------------------------------------------------------------

# Create test payload
cat > test.json <<EOF
{
  "billing_address": {
    "name": "Kylie Scull",
    "address": "6471 Front Street",
    "city": "Mountain View",
    "state_province": "CA",
    "postal_code": "94043",
    "country": "US"
  },
  "shipping_address": {
    "name": "Kylie Scull",
    "address": "9902 Cambridge Grove",
    "city": "Martinville",
    "state_province": "BC",
    "postal_code": "V1A",
    "country": "Canada"
  },
  "items": [
    {
      "id": "RW134",
      "quantity": 1,
      "sub-total": 12.95
    },
    {
      "id": "IB541",
      "quantity": 2,
      "sub-total": 24.5
    }
  ]
}
EOF


# Get public store-service URL
STORE_SERVICE_URL=$(gcloud run services describe store-service \
  --region $LOCATION \
  --format="value(status.address.url)")

# Send order to producer
# Flow:
# Client -> store-service -> Pub/Sub Topic -> Subscription -> order-service
curl -X POST \
  -H "Content-Type: application/json" \
  -d @test.json \
  $STORE_SERVICE_URL


# ============================================================
# FINAL ARCHITECTURE SUMMARY
# ============================================================

# ✔ Cloud Run = Serverless compute (auto scales)
# ✔ Pub/Sub = Asynchronous messaging (low coupling)
# ✔ Service Account = Secure service-to-service communication
# ✔ Push Subscription = Event-driven architecture
#
# RESULT:
# - Resilient messaging (no lost messages)
# - Automatic scaling
# - No direct service dependency
# - Fully serverless & managed infrastructure
#
# This design satisfies:
# - High resilience
# - Scalability
# - Minimal operational overhead
# ============================================================