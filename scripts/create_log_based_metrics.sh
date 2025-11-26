#!/bin/bash

# Gemini CLI Health Dashboard - Metric Setup Script
# Description: Automates the creation of Log-Based Metrics required for the dashboard.

# Set your Project ID
PROJECT_ID=$(gcloud config get-value project)
echo "🚀 Setting up metrics for project: $PROJECT_ID"

# 1. Create Success Rate Metric
echo "Creating Metric: gemini_cli_success..."
gcloud logging metrics create gemini_cli_success \
  --description="Counter for successful Gemini CLI API responses (2xx)" \
  --log-filter='resource.type="global" jsonPayload.event.name="gemini_cli.api_response" jsonPayload.status_code >= 200 AND jsonPayload.status_code < 300' \
  --project=$PROJECT_ID

# 2. Create Error Rate Metric
echo "Creating Metric: gemini_cli_error..."
gcloud logging metrics create gemini_cli_error \
  --description="Counter for failed Gemini CLI API responses (4xx/5xx)" \
  --log-filter='resource.type="global" jsonPayload.event.name="gemini_cli.api_error"' \
  --project=$PROJECT_ID

# 3. Create Response Distribution Metric (with Label)
echo "Creating Metric: gemini_cli_response..."
gcloud logging metrics create gemini_cli_response \
  --description="Distribution of all Gemini CLI response codes" \
  --log-filter='resource.type="global" logName="projects/'$PROJECT_ID'/logs/gemini_cli"' \
  --project=$PROJECT_ID 

# Note: Adding labels via gcloud CLI for log-based metrics can be complex as it often requires a config file update.
# The base counter is created above. You may need to manually add the 'status' label mapping in the Console 
# if the gcloud command doesn't fully support the complex label extraction in a single line.
# Or use 'gcloud logging metrics update' with a YAML config.

echo "✅ Metrics creation commands sent. Please verify in Cloud Logging > Log-based Metrics."
