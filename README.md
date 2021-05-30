# Ansible - Deploy TOTP Generator as a Tor Onion Service

The Ansible playbook in this repository creates a bash script which can deploy [totp-generator-web](https://github.com/k3karthic/totp-generator-web) as a [Tor Onion Service](https://community.torproject.org/onion-services/).

The playbook assumes the instance runs in Google Cloud using the terraform script below,
* [https://github.com/k3karthic/terraform__gcloud-instance](https://github.com/k3karthic/terraform__gcloud-instance)

The repository also includes `bin/deploy.sh` that executes `deploy_totp_tor.sh` on the instance using an Ansible ad-hoc task.

## Requirements

Install the following Ansible modules before running the playbook,
```
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix

pip install google-auth requests
ansible-galaxy collection install google.cloud
```

## Dynamic Inventory

This playbook uses the Google [Ansible Inventory Plugin](https://docs.ansible.com/ansible/latest/collections/google/cloud/gcp_compute_inventory.html) to populate public FreeBSD instances dynamically.

All public FreeBSD instances are assumed to have a label `os: freebsd` and `tor_service: yes`.

## Playbook Configuration

1. Create `inventory/google.gcp_compute.yml` based on `inventory/google.gcp_compute.yml.sample`,
    1. specify the project id.
    1. specify the zone where you have deployed your server on Google Cloud.
    1. Configure the authentication.
1. Set username and ssh authentication in `inventory/group_vars/`.
1. Create `roles/tor/files/torrc` from `roles/tor/files/torrc.sample` by adding obfs4 Tor bridges.

### Hidden Service Initialization

A hidden service requires an ed25519 keypair to be generated; the keypair is used to derive the hostname for the service. One can create a vanity v3 onion address using [cathugger/mkp224o](https://github.com/cathugger/mkp224o).

Once a keypair has been generated; copy `hostname`, `hs_ed25519_public_key` and `hs_ed25519_secret_key` into `roles/tor/files/hidden_service__totp`.

## Deployment

Run the playbook using the following command,
```
./bin/apply.sh
```

## Encryption

Sensitive files like the hidden service private key and SSH private keys are encrypted before being stored in the repository.

You must add the unencrypted file paths to `.gitignore`.

Use the following command to decrypt the files after cloning the repository,

```
./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
./bin/encrypt.sh <gpg key id>
```
