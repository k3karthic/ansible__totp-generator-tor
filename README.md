# Ansible — Deploy TOTP Generator as a Tor Onion Service

This playbook creates a bash script to deploy [totp.maverickgeek.xyz](https://totp.maverickgeek.xyz) as a [Tor Onion Service](https://community.torproject.org/onion-services/).

**TOTP Generator Onion:** [totpmgx6wksbquraailhqzyaue6e6k47zcvvxkknsdm5puwavc4kegqd.onion](http://totpmgx6wksbquraailhqzyaue6e6k47zcvvxkknsdm5puwavc4kegqd.onion)

**Assumption:** The instance runs in Google Cloud using the Terraform script below,
* terraform__gcloud-instance
    * GitHub: [github.com/k3karthic/terraform__gcloud-instance](https://github.com/k3karthic/terraform__gcloud-instance)
    * Codeberg: [codeberg.org/k3karthic/terraform__gcloud-instance](https://codeberg.org/k3karthic/terraform__gcloud-instance)

`bin/deploy.sh` uses an Ansible ad-hoc task to run `deploy_totp_tor.sh` on the instance.

## Code Mirrors

* GitHub: [github.com/k3karthic/ansible__totp-generator-tor](https://github.com/k3karthic/ansible__totp-generator-tor)
* Codeberg: [codeberg.org/k3karthic/ansible__totp-generator-tor](https://codeberg.org/k3karthic/ansible__totp-generator-tor) 

## Requirements

Install the following before running the playbook,
```
$ ansible-galaxy collection install community.general
$ ansible-galaxy collection install ansible.posix
$ pip install google-auth requests
$ ansible-galaxy collection install google.cloud
```

## Dynamic Inventory

The Google [Ansible Inventory Plugin](https://docs.ansible.com/ansible/latest/collections/google/cloud/gcp_compute_inventory.html) populates public FreeBSD instances.

The target FreeBSD instance must have the labels `os: freebsd` and `tor_service: yes`.

## Configuration

1. Create `inventory/google.gcp_compute.yml` based on `inventory/google.gcp_compute.yml.sample`,
    1. Specify the project ID
    1. Specify the zone where you have deployed your server on Google Cloud
    1. Configure the authentication,
        1. Application Default Credentials (`auth_kind: application`)
            1. Import credentials from the Google Cloud Environment (e.g, Google Cloud Shell)
            2. Import credentials from Google Cloud SDK if installed 
        2. Service Account (`auth_kind: serviceaccount`)
            1. Use a service account for authentication. Refer [cloud.google.com/docs/authentication/production#create_service_account](https://cloud.google.com/docs/authentication/production#create_service_account).
            2. Set `service_account_file` to the credential file or `service_account_contents` to the json content
        3. Machine Account (`auth_kind: machineaccount`)
            1. When running on Compute Engine, use the service account attached to the instance
1. Set username and SSH authentication in `inventory/group_vars/`
1. Create `roles/tor/files/torrc` from `roles/tor/files/torrc.sample`

### Onion Service Initialization

An onion service requires an ed25519 keypair. Tor derives the public hostname from the keypair. One can create a vanity onion hostname using [cathugger/mkp224o](https://github.com/cathugger/mkp224o).

After generating a keypair copy the following into `roles/tor/files/hidden_service__totp`,
* `hostname`
* `hs_ed25519_public_key`
* `hs_ed25519_secret_key`

## Deployment

Run the playbook using the following command,
```
$ ./bin/apply.sh
```

## Encryption

Encrypt sensitive files (onion service keypair and SSH private keys) before saving them. `.gitignore` must contain the unencrypted file paths.

Use the following command to decrypt the files after cloning the repository,

```
$ ./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
$ ./bin/encrypt.sh <gpg key id>
```
