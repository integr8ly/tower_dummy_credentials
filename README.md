# Tower Dummy Credentials Repo

Dummy Credentials repository to demonstrate how to bootstrap a tower instance with CI/CD jobs.

## Getting Started

This project serves as the inventory source for the [Ansible Tower Configuration](https://github.com/integr8ly/ansible-tower-configuration) project.

## Usage 

The projects `CREDENTIAL_CONFIG.yml` file contains a list of variables which need to be changed to suit your own tower environment. Once these variables have been changed,the `bootstrap.yml` playbook consumes the `CREDENTIAL_CONFIG.yml` file, encrypts any variables containing sensitive information using the supplied Ansible vault password, and then places each of the variables into the relevant group_vars file. The `CREDENTIAL_CONFIG.yml` file itself is then encrypted using the same Ansible vault password.

## Setup

**NOTE**: This project should be forked and made private before proceeding with the following setup steps.

1. Clone this project.

```bash
git clone https://github.com/<forked_repository_org>/tower_dummy_credentials
```

2. Change the variable values in the `CREDENTIAL_CONFIG.yml` file. A list of all variables that need to be changed along with their usage can be found [HERE](VARIABLES.md).

3. From the projects root directory, run the `bootstrap.yml` playbook, specifying the path to the `CREDENTIAL_CONFIG.yml` file.

```bash
ansible-playbook -i ./inventories/hosts bootstrap.yml --extra-vars='@CREDENTIAL_CONFIG.yml'
```

## Adding new variables

The following steps outline the process of adding new variables to the project. Please ensure that all new variables are also added to the [VARIABLES.md](VARIABLES.md) file.

### Encrypted

1. Add the variable to the  `CREDENTIAL_CONFIG.yml` file with a default value of `<CHANGEME>`.

2. Add an entry within the `with_items` section of the [bootstrap_credentials.yml](roles/credentials/tasks/bootstrap_credentials.yml#L13) file, replacing `new_variable` in the both the name and value fields with the name of the new variable.

```bash
 - { name: 'new_variable', value: '{{ new_variable }}' }
 ```

3. Add the new variable to the relevant file template located in `roles/credentials/templates` using the below format, ensuring that the variable to substitute in the template has `_enc` appended to the end of the variable name.

```bash
new_variable: !vault
|
{{ new_variable_enc }}
 ```

 ### Plaintext

 1. Add the variable to the  `CREDENTIAL_CONFIG.yml` file with a value of `<CHANGEME>`.
   
 2. Add the new variable to the relevant file template located in `roles/credentials/templates`, ensuring that the variables value is the name of the variable, placed within brackets.

```bash
 new_variable: {{ new_variable }}
 ```

## Decryption

Encrypted files and variables can be decrypted using the commands below, where the password is the `vault-password` variable value specified in your local copy of the `CREDENTIAL_CONFIG.yml` file.

### Files

```bash
ansible-vault decrypt '<path-to-file-to-decrypt>'
 ```

### Variables

```bash
ansible localhost -m debug -a var='<variable-name>' -e '@<path-to-file>' --ask-vault-pass
```

## Updating encrypted variables

The `bootstrap.yml` playbook can be re-run to update variable values.

1. Decrypt the `CREDENTIAL_CONFIG.yml` file.

```bash
ansible-vault decrypt 'CREDENTIAL_CONFIG.yml'
```

2. Make the required update/s.

3. Re-run the `bootstrap.yml` playbook.

```bash
ansible-playbook -i ./inventories/hosts bootstrap.yml --extra-vars='@CREDENTIAL_CONFIG.yml'
```