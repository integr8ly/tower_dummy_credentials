# Tower Dummy Credentials Repo

Dummy Credentials repository to demonstrate how to bootstrap a tower instance with CI/CD jobs.

## Getting Started

This project serves as the inventory source for the [Ansible Tower Configuration](https://github.com/integr8ly/ansible-tower-configuration) project.

## Usage

The projects `SAMPLE_CREDENTIAL_CONFIG.yml` file contains all of the variables which need to be changed to suit your own environment. Once these variables have been changed, the `bootstrap.yml` playbook is used to consume the `SAMPLE_CREDENTIAL_CONFIG.yml` file containing all of the credentials in plain text, encrypt these credentials with the specified Ansible vault password and then place them into the relevant group_vars file.

## Setup

1. Clone this project

```bash
1. cd <projects_directory>
2. git clone https://github.com/integr8ly/tower_dummy_credentials
```

2. Copy and rename the `SAMPLE_CREDENTIAL_CONFIG.yml` file locally. As the local copy of the config will sensitive information in plaintext, it should only be referenced locally and not checked into a public repository.

```bash
cp SAMPLE_CREDENTIAL_CONFIG.yml local_credentials_config.yml
```

3. Change the variable values in the newly created local copy of the `SAMPLE_CREDENTIAL_CONFIG.yml` file. A list of all variables that need to be changed along with their usage can be found [HERE](VARIABLES.md).

4. From the projects root directory, run the `bootstrap.yml` playbook, specifying the path to your local copy of the credentials file.

```bash
ansible-playbook -i /inventories/hosts bootstrap.yml --extra-vars='@<path-to-local-credentials-config-file>'
```

## Adding new variables

The following steps outline the process of adding new variables to the project.

1. Add the variable to the  `SAMPLE_CREDENTIAL_CONFIG.yml` file with a value of `<CHANGEME>`.

2. If the variable is the be encrypted (as opposed to being stored in plaintext), add an entry within the `with_items` section of the `encrypt_credentials.yml` task in the `bootstrap_credentials.yml` file.

```bash
 - { name: 'new_variable', value: '{{ new_variable }}' }
 ```

3. Add the new variable to the relevant file template. If the variable requires encryption, use the format below, ensuring that the variable to substitute in the template also has `_enc` appended to the variable name.

```bash
'new_variable': !vault
|
{{ 'new_variable_enc' }}
 ```

## Decrypting individual variables

Individual encrypted variables values can be viewed if required using the command below.

```bash
ansible localhost -m debug -a var='<variable-name>' -e '@<path-to-file>' --vault-password-file /tmp/vault_password.yml
 ```