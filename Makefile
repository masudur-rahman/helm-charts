SHELL=/bin/bash -o pipefail

REGISTRY   ?= ghcr.io/masudur-rahman
BIN        ?= helm-charts
IMAGE      := $(REGISTRY)/$(BIN)
SRC_REG    ?=

update-index:
	@./hack/generate-index.sh
