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

for API in ${APIs}; do
    echo "trying to enable ${API}..."
    gcloud services enable ${API}
done
