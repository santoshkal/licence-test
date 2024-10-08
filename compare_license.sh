#!/bin/bash

set -e

BRANCH_NAME=$1

# Fetch the LICENSE file from the branch where the PR was raised
LICENSE_FILE_PATH="./LICENSE"
if [ ! -f "$LICENSE_FILE_PATH" ]; then
    echo "LICENSE file not found in the PR branch."
    exit 1
fi

# Generate checksum and sha256 of the LICENSE file from the PR branch
LICENSE_CHECKSUM=$(md5sum $LICENSE_FILE_PATH | awk '{ print $1 }')
LICENSE_SHA256=$(sha256sum $LICENSE_FILE_PATH | awk '{ print $1 }')

echo "Checksum of LICENSE file in PR branch: $LICENSE_CHECKSUM"
echo "SHA256 of LICENSE file in PR branch: $LICENSE_SHA256"

# URL of the other LICENSE file to compare with
EXTERNAL_LICENSE_URL="https://raw.githubusercontent.com/intelops/license-files/refs/heads/main/opensource-licenses/no-restrictions/APACHE/LICENSE"

curl -o /tmp/external_LICENSE $EXTERNAL_LICENSE_URL

EXTERNAL_LICENSE_CHECKSUM=$(md5sum /tmp/external_LICENSE | awk '{ print $1 }')
EXTERNAL_LICENSE_SHA256=$(sha256sum /tmp/external_LICENSE | awk '{ print $1 }')

echo "Checksum of external LICENSE file: $EXTERNAL_LICENSE_CHECKSUM"
echo "SHA256 of external LICENSE file: $EXTERNAL_LICENSE_SHA256"

# Compare both checksums
if [ "$LICENSE_CHECKSUM" == "$EXTERNAL_LICENSE_CHECKSUM" ] && [ "$LICENSE_SHA256" == "$EXTERNAL_LICENSE_SHA256" ]; then
    echo "Both LICENSE files match."
else
    echo "LICENSE files do not match."
    exit 1
fi
