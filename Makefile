.DEFAULT_GOAL := help

##@ Docs

docs: docgen ## Build the docs
	pushd . && yarn install && popd
	pushd . && yarn install && yarn build && popd

local-docs: docs ## Serve the docs locally
	pushd . && yarn start && popd

docgen: schema ## Autogenerate the schema and pctl help in the docs
	pctl docgen --path docs/pctl || (echo "please update your pctl version to >= 0.0.4" && exit 1)
	mkdir -p docs/assets/schema
	bin/schema ProfileCatalogSource docs/assets/schema/catalogdef.json
	bin/schema ProfileDefinition docs/assets/schema/profiledef.json

.PHONY: help
help:  ## Display this help. Thanks to https://www.thapaliya.com/en/writings/well-documented-makefiles/
ifeq ($(OS),Windows_NT)
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-40s %s\n", $$1, $$2 } /^##@/ { printf "\n%s\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
else
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
endif