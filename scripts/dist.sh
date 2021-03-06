#!/usr/bin/env bash
set -e

export GO15VENDOREXPERIMENT=1

# Get the version from the command line
VERSION=$1
if [ -z $VERSION ]; then
    echo "Please specify a version."
    exit 1
fi

# Get the parent directory of where this script is.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"

# Change into that dir because we expect that
cd $DIR

# Generate the tag
if [ -z $NOTAG ]; then
  echo "==> Tagging..."
  git commit --allow-empty -a --gpg-sign=924DDCDE -m "Release v$VERSION"
  git tag -a -m "Version $VERSION" -s -u 924DDCDE "v${VERSION}" master
fi

# Tar all the files
rm -rf ./pkg/dist
mkdir -p ./pkg/dist
for FILENAME in $(find ./pkg -mindepth 1 -maxdepth 1 -type f); do
  FILENAME=$(basename $FILENAME)
  cp ./pkg/${FILENAME} ./pkg/dist/portland-${VERSION}-${FILENAME}
done

# Make the checksums
pushd ./pkg/dist
shasum -a256 * > ./portland-${VERSION}-SHA256SUMS
if [ -z $NOSIGN ]; then
  echo "==> Signing..."
  gpg --default-key 924DDCDE --detach-sig ./portland-${VERSION}-SHA256SUMS
fi
popd

# Upload
if [ -z $NORELEASE ]; then
    for ARCHIVE in ./pkg/dist/*; do 
        ARCHIVE_NAME=$(basename ${ARCHIVE})
        echo Uploading: $ARCHIVE_NAME
        curl \
            -T ${ARCHIVE} \
            -ucoreyoliver:${BINTRAY_API_KEY} \
            "https://api.bintray.com/content/coreyoliver/portland/portland/${VERSION}/${ARCHIVE_NAME}"
    done
fi

exit 0