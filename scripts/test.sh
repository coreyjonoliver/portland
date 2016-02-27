#!/usr/bin/env bash

export GO15VENDOREXPERIMENT=1

# Create a temp dir and clean it up on exit
TEMPDIR=`mktemp -d -t consul-test.XXX`
trap "rm -rf $TEMPDIR" EXIT HUP INT QUIT TERM

# Build the Portland binary for the API tests
echo "--> Building portland"
go build -o $TEMPDIR/portland || exit 1

# Run the tests
echo "--> Running tests"
go list ./... | PATH=$TEMPDIR:$PATH xargs -n1 go test