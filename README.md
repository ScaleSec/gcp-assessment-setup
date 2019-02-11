# gcp-assessment-setup
Give ScaleSec limited access to your GCP organization for a security assessment.

## Prerequisites
The following items are required for a successful setup.

- You must be an [Organization Role Admin](https://console.cloud.google.com/iam-admin/roles/details/roles<iam.organizationRoleAdmin)
- The [gcloud](https://cloud.google.com/sdk/) SDK CLI
- The `jq` CLI utility for your chosen platform

## Setup instructions

1. Open your Google Cloud [console](https://console.cloud.google.com).
2. Open Cloud Shell
3. Make sure to set your project to the project you want scanned.

```
gcloud config set project my-project-id-123
```

4. Clone this repositry and switch to its directory:

```
git clone https://github.com/ScaleSec/gcp-assessment-setup.git
cd gcp-security-assessment/
```

5. Edit the `manage_security_assessment_role.sh` and set variables:

```
ORG_NAME="example.com"
ROLE_ID="scalesec_assessment"
YAML_PATH="./security_assessment_role.yaml"
SERVICE_ACCOUNT="scalesec-security-assessment@scalesec-dev.iam.gserviceaccount.com"
```

6. Run the script to set permissions:

```
bash manage_security_assessment_role.sh create
```

7. Run the script to enable APIs:

```
bash enable_service_apis.sh
```