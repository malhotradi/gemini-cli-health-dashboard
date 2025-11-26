#!/bin/bash

# Gemini CLI Health Dashboard - Metric Setup Script
# Description: Automates the creation of Log-Based Metrics required for the dashboard.

# Set your Project ID
PROJECT_ID=$(gcloud config get-value project)
echo "🚀 Setting up metrics for project: $PROJECT_ID"

# 1. Create Success Rate Metric
# Name: gemini_cli_success
# Label: success_status mapped to jsonPayload."event.name"
echo "Creating Metric: gemini_cli_success..."
gcloud logging metrics create gemini_cli_success \
  --description="Counter for successful Gemini CLI API responses (2xx)" \
  --log-filter='logName="projects/'$PROJECT_ID'/logs/gemini_cli" jsonPayload.status_code:* jsonPayload."event.name"="gemini_cli.api_response"' \
  --project=$PROJECT_ID \
  --label-config=success_status=EXTRACT(jsonPayload."event.name")

# 2. Create Error Rate Metric
# Name: gemini_cli_error
# Label: error_status mapped to jsonPayload."event.name"
echo "Creating Metric: gemini_cli_error..."
gcloud logging metrics create gemini_cli_error \
  --description="Counter for failed Gemini CLI API responses (4xx/5xx)" \
  --log-filter='logName="projects/'$PROJECT_ID'/logs/gemini_cli" jsonPayload.status_code:* jsonPayload."event.name"="gemini_cli.api_error"' \
  --project=$PROJECT_ID \
  --label-config=error_status=EXTRACT(jsonPayload."event.name")

# 3. Create Response Distribution Metric
# Name: gemini_cli_response
# Labels: 
#   - status mapped to jsonPayload.status_code
#   - event_name mapped to jsonPayload."event.name"
echo "Creating Metric: gemini_cli_response..."
gcloud logging metrics create gemini_cli_response \
  --description="Distribution of all Gemini CLI response codes" \
  --log-filter='logName="projects/'$PROJECT_ID'/logs/gemini_cli" jsonPayload.status_code:*' \
  --project=$PROJECT_ID \
  --label-config=status=EXTRACT(jsonPayload.status_code),event_name=EXTRACT(jsonPayload."event.name")

echo "✅ Metrics creation commands sent. Please verify in Cloud Logging > Log-based Metrics."
