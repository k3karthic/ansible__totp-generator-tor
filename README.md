# Ansible - Deploy TOTP Generator as a Tor Onion Service

This playbook creates a bash script which can deploy [totp.cf.maverickgeek.xyz](https://totp.cf.maverickgeek.xyz) as a [Tor Onion Service](https://community.torproject.org/onion-services/).

Demo: [http://totpmgx6wksbquraailhqzyaue6e6k47zcvvxkknsdm5puwavc4kegqd.onion](http://totpmgx6wksbquraailhqzyaue6e6k47zcvvxkknsdm5puwavc4kegqd.onion)

**Assumption:** The instance runs in Google Cloud using the terraform script below,
* terraform__gcloud-instance
    * GitHub: [github.com/k3karthic/terraform__gcloud-instance](https://github.com/k3karthic/terraform__gcloud-instance)
    * Codeberg: [codeberg.org/k3karthic/terraform__gcloud-instance](https://codeberg.org/k3karthic/terraform__gcloud-instance)

`bin/deploy.sh` uses an Ansible ad-hoc task to run `deploy_totp_tor.sh` on the instance.

## Code Mirrors

* GitHub: [github.com/k3karthic/ansible__totp-generator-tor](https://github.com/k3karthic/ansible__totp-generator-tor)
* Codeberg: [codeberg.org/k3karthic/ansible__totp-generator-tor](https://codeberg.org/k3karthic/ansible__totp-generator-tor) 

## Requirements

Install the following Ansible modules before running the playbook,
```
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix

pip install google-auth requests
ansible-galaxy collection install google.cloud
```

## Dynamic Inventory

The Google [Ansible Inventory Plugin](https://docs.ansible.com/ansible/latest/collections/google/cloud/gcp_compute_inventory.html) dynamically populates public FreeBSD instances.

The target FreeBSD instances must have the labels `os: freebsd` and `tor_service: yes`.

## Playbook Configuration

1. Create `inventory/google.gcp_compute.yml` based on `inventory/google.gcp_compute.yml.sample`,
    1. specify the project id.
    1. specify the zone where you have deployed your server on Google Cloud.
    1. Configure the authentication.
1. Set username and SSH authentication in `inventory/group_vars/`.
1. Create `roles/tor/files/torrc` from `roles/tor/files/torrc.sample`.

### Onion Service Initialization

An onion service requires an ed25519 keypair. Tor derives the public hostname from the keypair. One can create a vanity onion hostname using [cathugger/mkp224o](https://github.com/cathugger/mkp224o).

After generating a keypair copy the following into `roles/tor/files/hidden_service__totp`,
* `hostname`
* `hs_ed25519_public_key`
* `hs_ed25519_secret_key`

## Deployment

Run the playbook using the following command,
```
./bin/apply.sh
```

## Encryption

Encrypt sensitive files (onion service and SSH private keys) before saving them. `.gitignore` must contain the unencrypted file paths.

Use the following command to decrypt the files after cloning the repository,

```
./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
./bin/encrypt.sh <gpg key id>
```
