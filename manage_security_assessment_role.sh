#!/bin/sh

# Manages an organization custom role with minimum permissions for ScaleSec to perform GCP security assessments
#
# requires:
#   IAM permissions on your Google Cloud organization
#   gcloud CLI https://cloud.google.com/sdk/
#   jq


# variables
ORG_NAME="gamine-technologies.com"
ROLE_ID="scalesec_assessment"
YAML_PATH="./security_assessment_role.yaml"
GROUP="scalesec-assessment@scalesec.com"


get_org_id ()
{
    ORG_ID=`gcloud organizations list --filter="displayName~'^${ORG_NAME}'" --format=yaml | grep organizations | awk -F/ '{print $2}'`
    if [ -z ${ORG_ID} ]; then
        echo "FATAL: Cannot describe organization \"${ORG_NAME}\". Check permissions."
        exit 1
    else
        echo "Organization \"${ORG_NAME}\" has ID \"${ORG_ID}\"."
    fi
}

create ()
{
    # make sure role does NOT exist so we can create it
    if [ -z "${describe_role}" ]; then
        gcloud iam roles create "${ROLE_ID}" --organization "${ORG_ID}" --file "${YAML_PATH}"
        create_iam_binding
    elif [ "${deleted}" == "true" ]; then
        undelete
    else
        echo "Info: role \"${ROLE_ID}\" already exists and has not been deleted. Switching to \"replace\"..."
        replace
    fi
}

# since we don't include an "etag" field, the update command will replace existing role
replace ()
{
    # make sure role exists so we can replace it
    if [ -z "${describe_role}" ]; then
        echo "FATAL: role \"${ROLE_ID}\" does not exist."
        exit 1
    elif [ "${deleted}" == "true" ]; then
        undelete
    else
        echo "Replacing existing role...."
        gcloud iam roles update ${ROLE_ID} --organization ${ORG_ID} --file ${YAML_PATH}
    fi
}

undelete ()
{
    echo "Info: role \"${ROLE_ID}\" exists but has been deleted. Switching to \"undelete\"..."
    gcloud iam roles undelete "${ROLE_ID}" --organization "${ORG_ID}"
    create_iam_binding
}

delete ()
{
    # make sure role exists so we can delete it
    if [ -z "${describe_role}" ]; then
        echo "FATAL: role \"${ROLE_ID}\" does not exist."
        exit 1
    elif [ "${deleted}" == "true" ]; then
        echo "Info: role \"${ROLE_ID}\" has already been scheduled for deletion."
    else
        echo "Scheduling role for deletion..."
        remove_iam_binding
        gcloud iam roles delete ${ROLE_ID} --organization ${ORG_ID}
    fi
    echo "
    Note: After 7 days, the role is scheduled for permanent deletion. This process takes 30 days. 
    During the 30 day window, the role and all associated bindings are permanently removed, and 
    you cannot create a new role with the same role ID.
    Reference: https://cloud.google.com/iam/docs/creating-custom-roles#deleting_a_custom_role
    "
}

create_iam_binding () 
{
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member=group:"${GROUP}" --role organizations/"${ORG_ID}"/roles/"${ROLE_ID}" --condition=None
}

remove_iam_binding ()
{
    gcloud organizations remove-iam-policy-binding "${ORG_ID}" --member=group:"${GROUP}" --role organizations/"${ORG_ID}"/roles/"${ROLE_ID}" --condition=None    
}

# get the organization ID
get_org_id

# look for conflicts
describe_role=`gcloud iam roles describe "${ROLE_ID}" --organization "${ORG_ID}"`
deleted=`gcloud iam roles describe "${ROLE_ID}" --organization "${ORG_ID}" --format json | jq -r '.deleted'`

# perform action depending on argument
case "${1}" in
    create)
        create
    ;;
    replace|update)
        replace
    ;;
    destroy|delete|remove)
        delete
    ;;
    *)
        echo $"Usage: $0 {create|replace|destroy}"
        exit 1
    ;;
esac
