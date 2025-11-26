# 🩺 Gemini CLI Health Dashboard
This repository contains the JSON configuration and setup guide for the **Gemini CLI Health Dashboard**.

This dashboard provides real-time observability into the **Gemini CLI**, allowing Platform Engineering and DevOps teams to monitor API health, success vs. error rates, and response code distributions (2xx, 4xx, 5xx).

## 🛠️ Prerequisites
Before importing the dashboard, you must configure the Gemini CLI to send telemetry to Google Cloud and create specific **Log-Based Metrics**. The dashboard relies on these metrics to populate the charts.

### 1. 📡 Enable Gemini CLI Telemetry
Update your Gemini CLI settings file (typically ~/.gemini/settings.json) to enable telemetry and target Google Cloud:
```text
{
  "telemetry": {
    "enabled": true,
    "target": "gcp"
  }
}
```

### 2. 📊 Create Log-Based Metrics
You must create **3** user-defined metrics in Google Cloud Logging using either option [A](#a-setup-metrics-from-google-cloud-console) or [B](#b-setup-metrics-using-bash-script-automated)

⚠️ **Important:** The metric names must match exactly as listed below, or the dashboard widgets will show "No Data."
#### [A] Setup metrics from Google Cloud Console

##### 🟢 Metric A: Success Rate
- Metric Type: Counter
- Log Metric Name: gemini_cli_success
- Filter:
```text
resource.type="global"
jsonPayload.event.name="gemini_cli.api_response"
jsonPayload.status_code >= 200 AND jsonPayload.status_code < 300
```
##### 🔴 Metric B: Error Rate
- Metric Type: Counter
- Log Metric Name: gemini_cli_error
- Filter:
```text
resource.type="global"
jsonPayload.event.name="gemini_cli.api_error"
```
##### 📈 Metric C: Response Distribution
- Metric Type: Counter
- Log Metric Name: gemini_cli_response
- Labels: Create a label named status mapped to field jsonPayload.status_code.
- Filter:
```text
resource.type="global"
logName="projects/YOUR_PROJECT/logs/gemini_cli"
```

#### [B] Setup metrics using bash script (Automated)
Instead of manually creating metrics, you can also run the provided script:

1. Open Cloud Shell.
2. Upload `/scripts/create_log_based_metrics.sh`.
3. Run: `bash create_log_based_metrics.sh`

## 📥 Installation
1. Download the gemini-cli-dashboard.json file from this repository.
2. Go to the Google Cloud Console > Monitoring > Dashboards.
3. Click Create Dashboard (or "Import Dashboard" if available).
4. Switch to the JSON Editor tab.
5. Copy and paste the contents of gemini-cli-dashboard.json.
6. Click Apply.

## 🖼️ Dashboard Panels
- [A] Success vs Error Rate: 📊 A stacked bar chart showing the ratio of successful requests to failed ones over time.
- [B] Response Code Distribution: 📉 A line chart visualizing the volume of traffic segmented by HTTP response codes (200s, 400s, 500s).
![Alt Text](/images/sample_dashboard.png)
## 🤝 Contributing
Feel free to submit Pull Requests to improve the dashboard layout or add new metrics!
