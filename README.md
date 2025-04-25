# vault-enterprise-poc

A quick-and-dirty Docker Compose stack that spins up Vault Enterprise for PoC-ing.

## Pre-requisites

Install `taskfile` and `jq` with the following command:

```bash
brew install go-task jq
```

Clone git repository:

```bash
git clone https://github.com/MorganPeat/vault-enterprise-poc.git
```

## Usage

Add a Vault Enterprise licence key into `.env`. (Example environment file in `.env.example`.)  

[Taskfile.yml](Taskfile.yml) contains automation commands to manage the stack.
Launch the docker compose stack with the following command:

```bash
task 
```

* `task up` will download and run the necessary docker compose stack.
* `task init` will initialise Vault. This only needs to be executed once.
* `task unseal` will unseal Vault with the unseal key, after a start or restart, and output the root token for later use.

Export the environment variables with the following command:

```bash
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=<Take from task unseal output>
vault token lookup
```

## PoCs in this repository

### Vault LDAP secret engine - root credential auto-rotation

See [./scripts/ldap-secrets.sh]. This mounts and conifigures the LDAP secret engine, using a local OpenLDAP container, rotates the root credential, and sets up auto-rotation.

## References

* Narish's LDAP repo at [https://github.com/nhsy-hcp/docker-vault-stack]
* HashiCorp tutorial [Manage LDAP credentials with Vault](https://developer.hashicorp.com/vault/tutorials/secrets-management/openldap)
