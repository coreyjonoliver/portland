GOTOOLS = github.com/mitchellh/gox
VERSION?=$(shell awk -F\" '/^const Version/ { print $$2; exit }' version.go)
VETARGS?=-asmdecl -atomic -bool -buildtags -copylocks -methods \
         -nilfunc -printf -rangeloops -shift -structtags -unsafeptr

all: tools
	@mkdir -p bin/
	@sh -c "'$(CURDIR)/scripts/build.sh'"

# dev creates binaries for testing locally - these are put into ./bin and $GOPATH
dev: format
	@PORTLAND_DEV=1 sh -c "'$(CURDIR)/scripts/build.sh'"

# dist creates the binaries for distibution
dist:
	@sh -c "'$(CURDIR)/scripts/dist.sh' $(VERSION)"

cov:
	gocov test ./... | gocov-html > /tmp/coverage.html
	open /tmp/coverage.html

test: format
	@$(MAKE) vet
	@./scripts/test.sh

cover:
	go list ./... | xargs -n1 go test --cover

format:
	@echo "--> Running go fmt"
	@go fmt $(PACKAGES)

vet:
	@echo "--> Running go tool vet $(VETARGS) ."
	@go list ./... \
		| cut -d '/' -f 4- \
		| xargs -n1 \
			go tool vet $(VETARGS) ;\
	if [ $$? -ne 0 ]; then \
		echo ""; \
		echo "Vet found suspicious constructs. Please check the reported constructs"; \
		echo "and fix them if necessary before submitting the code for reviewal."; \
	fi

tools:
	go get -u -v $(GOTOOLS)

.PHONY: all dev dist cov test cover format vet tools