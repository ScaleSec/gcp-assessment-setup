# gcp-assessment-setup
Give ScaleSec limited access to your GCP organization for a security assessment.

## Prerequisites
You'll need permissions to modify and apply IAM roles to your Google Cloud organization.

## System requirements
The following items are required for a successful setup.

1. A Linux or Mac system to run the script (sorry, not tested in Windows)
1. The [gcloud](https://cloud.google.com/sdk/) SDK CLI
1. The `jq` CLI utility for your chosen platform

## Setup instructions

1. Open your Google Cloud [console](https://console.cloud.google.com).
2. Open Cloud Shell
3. Clone this repositry and switch to its directory:

```
git clone https://github.com/ScaleSec/gcp-assessment-setup.git
cd gcp-security-assessment
```

4. Edit the `manage_security_assessment_role.sh` and set variables:

```
ORG_NAME="example.com"
ROLE_ID="scalesec_assessment"
YAML_PATH="./security_assessment_role.yaml"
SERVICE_ACCOUNT="scalesec-security-assessment@scalesec-dev.iam.gserviceaccount.com"
```

5. Run the script:

```
bash security_assessment_role.yaml create
```

6. 