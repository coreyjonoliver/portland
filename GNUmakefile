GOTOOLS = github.com/mitchellh/gox
VERSION?=$(shell awk -F\" '/^const Version/ { print $$2; exit }' version.go)

all: format tools
	@mkdir -p bin/
	@bash --norc -i ./scripts/build.sh

# bin generates the releasable binaries
bin: generate
	@sh -c "'$(CURDIR)/scripts/build.sh'"

# dev creates binaries for testing locally - these are put into ./bin and $GOPATH
dev: generate
	@PORTLAND_DEV=1 sh -c "'$(CURDIR)/scripts/build.sh'"

format:
	@echo "--> Running go fmt"
	@go fmt $(PACKAGES)

# generate runs `go generate` to build the dynamically generated source files
generate:
	find . -type f -name '.DS_Store' -delete
	go generate ./...

# dist creates the binaries for distibution
dist: bin
	@sh -c "'$(CURDIR)/scripts/dist.sh' $(VERSION)"

tools:
	go get -u -v $(GOTOOLS)

.PHONY: all bin dev generate dist tools