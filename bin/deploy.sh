#!/usr/bin/env bash

ansible -i inventory/google.gcp_compute.yml all --become -a "/usr/local/bin/deploy_totp_tor.sh"
