#!/bin/sh

# enable APIs for programmatic access

APIs="
cloudbilling.googleapis.com
storage-api.googleapis.com
monitoring.googleapis.com
logging.googleapis.com
dns.googleapis.com
sqladmin.googleapis.com
cloudkms.googleapis.com
"

for project in $(gcloud projects list --format=json | jq -r '.[] | .projectId'); do
    for API in ${APIs}; do
        echo "trying to enable ${API} for project ${project}..."
        gcloud services --project=${project} enable ${API}
    done
done
