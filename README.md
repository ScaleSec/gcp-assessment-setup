# gcp-assessment-setup
Give ScaleSec limited access to your GCP organization for a security assessment.

`scalesec-assessment@scalesec.com` will be added with minimal privileges into your GCP organization.

## Prerequisites
The following items are required for a successful setup.

- You must have the following IAM Roles on the Organization Level
    - [Organization Role Admin](https://console.cloud.google.com/iam-admin/roles/details/roles<iam.organizationRoleAdmin)
    - [Organization Admin](https://console.cloud.google.com/iam-admin/roles/details/roles<resourcemanager.organizationAdmin)
- The [gcloud](https://cloud.google.com/sdk/) SDK CLI
- The `jq` CLI utility for your chosen platform

### Optional: Add the scalesec.com domain to the list of allowed domains:

If you have implemented the "Domain Restrited Sharing" Organization Policy, you will not be allowed to add a member from the scalesec.com domain without adding Scalesecs GCP customer ID to your Organization Policy.

To add ScaleSec to the allow list, following the instructions to [set the domain restricted sharing organization policy](https://cloud.google.com/resource-manager/docs/organization-policy/restricting-domains#setting_the_organization_policy)

ScaleSecs GCP customer ID is `C00lp9p1o`

## Setup instructions

1. Open your Google Cloud [console](https://console.cloud.google.com).
2. Open Cloud Shell

![Alt Text](https://cloud.google.com/shell/docs/images/shellstart-update.gif)


3. Clone this repositry and switch to its directory:

```
git clone https://github.com/ScaleSec/gcp-assessment-setup.git
cd gcp-assessment-setup/
```

4. Edit the `manage_security_assessment_role.sh` and set the organization name:

```
ORG_NAME="example.com"
```

_Note: other variables including the `ROLE_ID`, `YAML_PATH`, and `GROUP` should not be changed._ 


5. Run the script to set permissions:

```
bash manage_security_assessment_role.sh create
```

## From the Admin Console (https://admin.google.com):

The Service Account is required to have permission to impersonate a Super Admin in order to use the Directory API to test if all users have MFA enabled (CIS 1.2).  This Service Account will have minimal permission scopes as laid out in Step 9.

Google Documentation around this subject is located [here](https://developers.google.com/admin-sdk/directory/v1/guides/delegation).  The Customer will also need to provide the email address of the Super Admin to impersonate.

7. Sign into the [Admin Console](https://admin.google.com) with a `Super User` Account:

<p align="center">
    <img src="./IMG/ADMIN_CONSOLE.png" alt="drawing" width="400"/>
</p>

8. Select Security --> Advanced Settings --> Manage API Client Access

<p align="center">
    <img src="./IMG/ADV_SETTINGS.png" alt="drawing" width="400"/>
</p>

9. Input `101417956419715946363` into the `Client Name` Field.  Add `https://www.googleapis.com/auth/admin.directory.user.readonly,https://www.googleapis.com/auth/admin.directory.domain.readonly,https://www.googleapis.com/auth/admin.directory.group.readonly,https://www.googleapis.com/auth/admin.directory.group.member.readonly`to the API Scopes Field

<p align="center">
    <img src="./IMG/ADD_SCOPES.png" alt="drawing"  width="1000"/>
</p>


## Removing Access Instructions

1. Run the script to remove permissions:

```
bash manage_security_assessment_role.sh delete
```

2. Sign into the [Admin Console](https://admin.google.com) with a `Super User` Account:

<p align="center">
    <img src="./IMG/ADMIN_CONSOLE.png" alt="drawing" width="400"/>
</p>

3. Select Security --> Advanced Settings --> Manage API Client Access

<p align="center">
    <img src="./IMG/ADV_SETTINGS.png" alt="drawing" width="400"/>
</p>

4. Select the "Remove" button for the appropriate `Client Name`
