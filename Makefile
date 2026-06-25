SHELL=/bin/bash -o pipefail

REGISTRY   ?= ghcr.io/masudur-rahman
BIN        ?= helm-charts
IMAGE      := $(REGISTRY)/$(BIN)
SRC_REG    ?=

update-index:
	@./hack/generate-index.sh

# ---------------------------------------------------------------------------
# SOPS secret management
#
#   make sops-edit            # edit the default secret (decrypt -> $EDITOR -> re-encrypt)
#   make sops-decrypt         # print decrypted secret to stdout
#   make sops-encrypt         # encrypt a plaintext file in place
#   make sops-key             # import the olympus age key into your sops keyring (one-time)
#
# Override the target file or key path:
#   make sops-edit FILE=clusters/olympus/infrastructure/other.sops.yaml
#   make sops-edit AGE_KEY=/path/to/keys.txt
# ---------------------------------------------------------------------------

# Default secret file so the common case needs no FILE=.
FILE     ?= clusters/olympus/infrastructure/porkbun-credentials.sops.yaml
# age private keyring sops decrypts with (absolute; default is the sops standard path).
AGE_KEY  ?= $(HOME)/.config/sops/age/keys.txt
# homelab-forge checkout that holds the olympus age key in its vault.
FORGE_DIR ?= ../homelab-forge

.PHONY: sops-encrypt sops-decrypt sops-edit sops-key _sops-check

_sops-check:
	@command -v sops >/dev/null 2>&1 || { echo "ERROR: sops not installed (brew install sops)"; exit 1; }
	@test -n "$(FILE)" || { echo "ERROR: no FILE given. Try: make $(MAKECMDGOALS) FILE=path/to/secret.sops.yaml"; exit 1; }
	@test -f "$(FILE)" || { echo "ERROR: file not found: $(FILE)"; exit 1; }
	@test -s "$(abspath $(AGE_KEY))" || { \
	  echo "ERROR: age key not found at $(AGE_KEY)"; \
	  echo "  Run 'make sops-key' once to import it, or pass AGE_KEY=/path/to/keys.txt"; \
	  exit 1; }

# Targets cd into the file's directory so sops finds the nearest .sops.yaml rules.
sops-edit: _sops-check
	@cd $(dir $(FILE)) && SOPS_AGE_KEY_FILE=$(abspath $(AGE_KEY)) sops $(notdir $(FILE))

sops-decrypt: _sops-check
	@cd $(dir $(FILE)) && SOPS_AGE_KEY_FILE=$(abspath $(AGE_KEY)) sops --decrypt $(notdir $(FILE))

sops-encrypt: _sops-check
	@cd $(dir $(FILE)) && SOPS_AGE_KEY_FILE=$(abspath $(AGE_KEY)) sops --encrypt --in-place $(notdir $(FILE))

# One-time: pull the olympus age private key from the forge vault into your keyring.
sops-key:
	@command -v age-keygen >/dev/null 2>&1 || { echo "ERROR: age not installed (brew install age)"; exit 1; }
	@test -f "$(FORGE_DIR)/vault/compute.yml" || { echo "ERROR: forge vault not found at $(FORGE_DIR)/vault/compute.yml (set FORGE_DIR=)"; exit 1; }
	@mkdir -p $(dir $(abspath $(AGE_KEY)))
	@KEY=$$(ansible-vault view $(FORGE_DIR)/vault/compute.yml --vault-password-file $(FORGE_DIR)/.vault_pass_compute \
	  | grep -oE 'AGE-SECRET-KEY-[A-Z0-9]+' | head -1); \
	  test -n "$$KEY" || { echo "ERROR: vault_olympus_age_key not found in forge vault"; exit 1; }; \
	  if grep -q "$$KEY" $(abspath $(AGE_KEY)) 2>/dev/null; then \
	    echo "olympus age key already present in $(abspath $(AGE_KEY))"; \
	  else \
	    echo "$$KEY" >> $(abspath $(AGE_KEY)); \
	    echo "Imported olympus age key into $(abspath $(AGE_KEY))"; \
	  fi
