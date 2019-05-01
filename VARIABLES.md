# Files and Variables

A list of files within the project which the contain variables that need to be changed. The Encryption column denotes , or store it in plaintext.

## Vault Password

Ansible Vault password used to encrypt all of the following variables. This password should be stored securely for future use as it does not after project execution.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `vault_password`: | Ansible vault password |  |

## aws_credentials.yml

Credentials of the AWS account to be used to provision a new cluster. The credentials for multiple AWS environments can be stored in this file, with each environment required to be added to the `aws_credential_list`. The target AWS environment is specified when running the [Ansible Tower Configuration](https://github.com/integr8ly/ansible-tower-configuration) projects playbooks. An example is provided within the file.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `aws_credential_list: - "<CHANGEME>"`: | AWS credential name list (`dev`, `test` etc.) |  |
| `access_key_id: <CHANGEME>`: | AWS access key ID | ✔ |
| `secret_access_key_id: <CHANGEME>`: | AWS secret key ID | ✔ |

## cluster.yml

Configuration variables required by the `provisioning_vars.yml.j2` file to provision of an Openshift cluster.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `cluster_credential_git_repo`:  | Github project URL |  |
| `cluster_pod_openshift_user`:   | Openshift cluster pod username | ✔ |
| `cluster_pod_openshift_pass`:   | Openshift cluster pod password | ✔ |
| `cluster_credential_bundle_aws_name`: | AWS cluster credential bundle name |  |
| `rh_user`: | [Red Hat registry](https://docs.openshift.com/container-platform/3.11/install/configuring_inventory_file.html#advanced-install-configuring-registry-location) username | ✔ |
| `rh_pass`: | [Red Hat registry](https://docs.openshift.com/container-platform/3.11/install/configuring_inventory_file.html#advanced-install-configuring-registry-location) password | ✔ |
| `dev_domain`: | Domain name to be used for development environments |  |
| `poc_domain`: | Domain name to be used for Proof of Concept environments |  |
| `htpasswd_username`: | Openshift cluster admin username |  |
| `htpasswd_password`: | Openshift cluster admin password | ✔ |

## integreatly_vault.yml

Ansible Tower credentials values.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `tower_credential_bundle_vault_name`: | Ansible [tower_job_template](https://docs.ansible.com/ansible/latest/modules/tower_job_template_module.html) module vault credential |  |
| `integreatly_vault`: | Ansible [tower_credential](https://docs.ansible.com/ansible/latest/modules/tower_credential_module.html) module vault password | ✔ |

## letsencrypt.yml

Private key to be used with Lets Encrypt.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `letsencrypt_private_key`: | User generated private key to be used with Lets Encrypt | ✔ |

## tower_github_authentication.yml

Ansible [Social Auth](https://docs.ansible.com/ansible-tower/3.0.2/html/administration/social_auth.html) credentials.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `social_auth_github_org_name`: | GitHub organizational name |  |
| `social_auth_github_org_key`: | GitHub auth key | ✔ |
| `social_auth_github_org_secret`: | GitHub auth secret | ✔ |
| `social_auth_github_org_organization_map`: | GitHub auth organizational map |  |
| `social_auth_github_org_team_map`: | Contains [2 organizational](https://docs.ansible.com/ansible-tower/3.0.2/html/administration/social_auth.html#organization-and-team-mapping) team map variables that need to be changed |  |

## tower_github_scm.yml

Ansible Tower credential values.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `tower_credentials_project_scm_type_url`:  | Github project URL |  |
| `tower_github_scm_password`: | Ansible [tower_credential](https://docs.ansible.com/ansible/latest/modules/tower_credential_module.html) module SSH key password | ✔ |
| `tower_github_scm`: | Ansible [tower_credential](https://docs.ansible.com/ansible/latest/modules/tower_credential_module.html) module SSH private key path | ✔ |

## tower_openshift_authentication.yml

Login credentials for the Target Openshift cluster.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `tower_openshift_username`: | The username to be used to login to the Openshift cluster (requires admin permissions) | ✔ |
| `tower_openshift_password`: | The password of the Openshift user specified | ✔ |
| `tower_openshift_master_url`: | The hostname of the target Openshift cluster |  |

## tower_ssh.yml

Ansible Tower SSH configuration values.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `tower_ssh`:  | Ansible [copy_module](https://docs.ansible.com/ansible/latest/modules/tower_credential_module.html) module content field, used to copy the SSH key to the destination directory | ✔ |
| `tower_ssh_user`: | Ansible [tower_credential](https://docs.ansible.com/ansible/latest/modules/tower_credential_module.html) module username |  |

## tower.yml

Credentials of the target Ansible Tower instance. The credentials for multiple Tower instances can be stored in this file, with each environment required to be added to the `tower_instance_list`. The target AWS environment is specified when running the [Ansible Tower Configuration](https://github.com/integr8ly/ansible-tower-configuration) projects playbooks, using the `tower_environment` environmental variable. An example is provided within the file.

| Variable | Description | Encrypted |
| ------ | ----------- | ----------- |
| `tower_instance_list: - "<CHANGEME>"`: | List of target Tower instances (`dev`, `test` etc.) |  |
| `tower_host: <CHANGEME>`: | The hostname of the Target Ansible Tower instance |  |
| `tower_username: <CHANGEME>`: | The username of the Target Ansible Tower instance |  |
| `tower_password: <CHANGEME>`: | The password of the Target Ansible Tower instance | ✔ |