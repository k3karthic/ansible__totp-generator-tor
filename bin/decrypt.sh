#!/usr/bin/env bash

function decrypt {
    gpg --decrypt --batch --yes --output "$1" "$1.gpg"
    if [ ! "$?" -eq "0" ]; then
        exit
    fi
}

FILES=$(ls ssh/google*.gpg)
for f in $FILES; do
    decrypt $( echo $f | sed 's/\.gpg//' )
done

decrypt "roles/tor/files/hidden_service__totp/hs_ed25519_secret_key"
decrypt "roles/tor/files/torrc"
