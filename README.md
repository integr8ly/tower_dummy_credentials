# Tower Dummy Credentials Repo

Dummy credentials repository used to generate organisation specific credential repositories required for bootstrapping RHMI Ansible Tower instances.

**NOTE:** This repository serves as the inventory source for the [Ansible Tower Configuration](https://github.com/integr8ly/ansible-tower-configuration) repository.

## Prerequisites

### Reporting changes back
It is **important** that all teams report their unique changes back to the tower dummy credentials repo.
The tower dummy credentials repo is the one source of truth.

For new tower jobs or configurations a new JIRA tickets should be created marked with the upcoming or affecting release version.
This allows for a discussion on changes pre release insuring any changes required in the bootstrapping stage can be incorporated.

A PR should be made against the master branch of the dummy credentials repo.
In the PR template the following information should be conveyed.

- How to verify the changes made in the PR.
- A link to any associated JIRA's
- The checklist should be filled in.
  - If the [CHANGELOG.md](https://github.com/integr8ly/tower_dummy_credentials/blob/master/CHANGELOG.md) has been updated
  - If new variables have been added to the [VARIABLES.md](https://github.com/integr8ly/tower_dummy_credentials/blob/master/VARIABLES.md).
- Any additional information / notes that may help the reviewers understand the reason behind the change and what affects it may have.

## Getting Started

### Setup

1. Fork credentials repository and make private

   **PLEASE READ** This repository should be forked BEFORE proceeding with the below steps. Although any sensitive data will be encrypted via Ansible Vault, it is still recommended that the forked repository be made private. The remainder of this README makes the assumption that all steps going forward are being performed from within the private forked repository.

2. Clone private forked credentials repository locally

        git clone https://github.com/<forked_repository_org>/<forked_repository_name>

3. Make a copy of the `CREDENTIAL_CONFIG_TEMPLATE.yml` file named `CREDENTIAL_CONFIG.yml` in the root of the repository

        cp CREDENTIAL_CONFIG_TEMPLATE.yml CREDENTIAL_CONFIG.yml

4. Populate newly copied `CREDENTIAL_CONFIG.yml` file with correct values for each variable. A list of all variables and their usage can be found in the [VARIABLES.md](https://github.com/integr8ly/tower_dummy_credentials/blob/master/VARIABLES.md) file of the upstream dummy repository

5. Once all variable values have been set in the `CREDENTIAL_CONFIG.yml` file, run the `bootstrap.yml` playbook from the root of the repository and specify the path to the `CREDENTIAL_CONFIG.yml` file.

        ansible-playbook -i ./inventories/hosts bootstrap.yml --extra-vars='@CREDENTIAL_CONFIG.yml'

   **NOTE:** All sensitive information should now be encrypted including the copied `CREDENTIAL_CONFIG.yml` file with the password set for the `vault_password` variable.

6. Next, run the cleandown task to remove any non-essential files and directories in the forked repository

        make clean branch=add_encrypted_data

7. Push all changes to remote

        git add .
        git commit -am "Initial commit containing all encrypted data"
        git push origin add_encrypted_data

8. Finally, create a new pull request from the `add_encrypted_data` feature branch referenced above and merge back to the `master` branch of the private forked repository

### Adding new variables

The following steps outline the process of adding new variables to the project. Please ensure that all new variables are also added to the [VARIABLES.md](VARIABLES.md) file.

#### Encrypted

1. Add the variable to the  `CREDENTIAL_CONFIG.yml` file with a default value of `<CHANGEME>`.

2. Add an entry within the `with_items` section of the [bootstrap_credentials.yml](roles/credentials/tasks/bootstrap_credentials.yml#L13) file, replacing `new_variable` in the both the name and value fields with the name of the new variable.

        - { name: 'new_variable', value: '{{ new_variable }}' }

3. Add the new variable to the relevant file template located in `roles/credentials/templates` using the below format, ensuring that the variable to substitute in the template has `_enc` appended to the end of the variable name.

        new_variable: !vault
        |
        {{ new_variable_enc }}

#### Plaintext

 1. Add the variable to the  `CREDENTIAL_CONFIG_TEMPLATE.yml` file with a value of `<CHANGEME>`.

 2. Add the new variable to the relevant file template located in `roles/credentials/templates`, ensuring that the variables value is the name of the variable, placed within brackets.

        new_variable: {{ new_variable }}

### Removing old variables

Removed variables will be documented in the [changelog](CHANGELOG.md) for each release. Review the [changelog](CHANGELOG.md) to ensure that all unwanted variables are removed from the configuration files.

#### Encrypted

1. Remove the variable from the `CREDENTIAL_CONFIG.yml` file.

2. Ensure the variable has been removed from the `bootstrap_credentials.yml` file.

3. Ensure the variable has been removed from all templates.  

4. From the repo's root check for any remaining instances of the variable. This should be an empty return.

        grep -rw <old_variable> *

#### Plaintext

1. Remove the variable from `CREDENTIAL_CONFIG_TEMPLATE.yml` file.

2. Ensure the variable has been removed from all templates. 

3. From the repo's root check for any remaining instances of the variable. This should be an empty return.

        grep -rw <old_variable> *

### Decryption

Encrypted files and variables can be decrypted using the commands below, where the password is the `vault-password` variable value specified in your local copy of the `CREDENTIAL_CONFIG.yml` file.

#### Files

        ansible-vault decrypt '<path-to-file-to-decrypt>'

#### Variables

        ansible localhost -m debug -a var='<variable-name>' -e '@<path-to-file>' --ask-vault-pass

### Updating encrypted variables

The `bootstrap.yml` playbook can be re-run to update variable values.

1. Decrypt the `CREDENTIAL_CONFIG.yml` file.

        ansible-vault decrypt 'CREDENTIAL_CONFIG.yml'

2. Make the required update/s.

3. Re-run the `bootstrap.yml` playbook.

        ansible-playbook -i ./inventories/hosts bootstrap.yml --extra-vars='@CREDENTIAL_CONFIG.yml'

### Updating private credential repositories

Following the creation of a new release tag on the Tower Dummy credential repository, all private repositories need to be updated to reflect the latest variables and code changes. Below is a list of steps for updating a private credentials repository to a specific release

1. Clone private credentials repository locally

        git clone git@github.com:<forked_repository_org>/<forked_repository_name>.git

2. Validate remote configuration

   The `make sync` task makes some assumptions around how GIT remotes are configured in the local repository

   Ensure the origin and dummy remotes are setup as follows

        origin git@github.com:<credential_repository_org>/<credential_repository_name>.git (fetch)
        origin git@github.com:<credential_repository_org>/<credential_repository_name>.git (push)
        dummy git@github.com:integr8ly/tower_dummy_credentials.git (fetch)
        dummy git@github.com:integr8ly/tower_dummy_credentials.git (push)

   Remote setup command example

        git remote add dummy https://github.com/integr8ly/tower_dummy_credentials.git

3. Update master branch of the forked private credentials repository

        git reset --hard
        git checkout master
        git pull origin master
        git fetch --all -p

4. Checkout Makefiles and scripts from target release tag

        git checkout <release-tag> -- Makefile scripts/
        chmod +x scripts/*

5. Run make sync task to update to a specific release tag, responding to all prompts accordingly.

   **NOTE:** The vault password to the credentials repository is required to complete this step.

        make sync releasetag=<release-tag>

   During this task, the user will be prompted to review the CHANGELOG for the specified release tag and update the local `CREDENTIAL_CONFIG.yml` file accordingly.

   Once the `make sync` task has completed, a new release base branch and associated release tag should be available from the credential repository

   For example:

        Base Branch: v99.99
        Release Tag: release-99.99.99

6. Once happy that the generated release tag and base branch have been created successfully against `origin` remote of the forked private credentials repository, complete the following:

* Issue a PR against master from the base branch e.g. `v99.99`
* Carefully review all changes as part of the PR
* Merge back to master when ready
