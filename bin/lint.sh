#!/usr/bin/env bash

ansible-lint -p site.yml roles/nginx roles/tor
