# Type checking, formatting and tests for jj-gh-review.nvim.
#
#   make check        # everything CI runs
#   make typecheck    # emmylua_check against the local Neovim runtime
#   make test         # headless offline tests (no network, GitHub calls stubbed)
#   make format       # stylua in place

NVIM ?= nvim
VIMRUNTIME ?= $(shell $(NVIM) --clean --headless +'lua io.write(vim.env.VIMRUNTIME)' +q 2>/dev/null)

################################################################################
# EmmyLua (type checker)
################################################################################

ifeq ($(shell uname -m),arm64)
    EMMYLUA_ARCH ?= arm64
else ifeq ($(shell uname -m),aarch64)
    EMMYLUA_ARCH ?= arm64
else
    EMMYLUA_ARCH ?= x64
endif

EMMYLUA_REF := 0.22.0
EMMYLUA_OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
EMMYLUA_DIR := deps/emmylua-$(EMMYLUA_REF)
EMMYLUA_BIN := $(EMMYLUA_DIR)/emmylua_check
EMMYLUA_URL := https://github.com/EmmyLuaLs/emmylua-analyzer-rust/releases/download/$(EMMYLUA_REF)/emmylua_check-$(EMMYLUA_OS)-$(EMMYLUA_ARCH).tar.gz

$(EMMYLUA_BIN):
	mkdir -p $(EMMYLUA_DIR)
	curl -sSL $(EMMYLUA_URL) -o $(EMMYLUA_DIR)/emmylua_check.tar.gz
	tar -xzf $(EMMYLUA_DIR)/emmylua_check.tar.gz -C $(EMMYLUA_DIR)

# Type definitions for `vim.uv` (libuv), which Neovim's runtime does not ship.
LUV_TYPES_REF := 3615eb12c94a7cfa7184b8488cf908abb5e94c9c
LUV_TYPES := deps/luv/uv.lua

$(LUV_TYPES):
	rm -rf deps/luv && mkdir -p deps/luv
	curl -sSL https://github.com/LuaCATS/luv/archive/$(LUV_TYPES_REF).tar.gz \
		| tar -xz --strip-components=2 -C deps/luv luv-$(LUV_TYPES_REF)/library

.PHONY: typecheck
typecheck: $(EMMYLUA_BIN) $(LUV_TYPES)
	@test -n "$(VIMRUNTIME)" || { echo "VIMRUNTIME could not be determined; is nvim installed?"; exit 1; }
	VIMRUNTIME=$(VIMRUNTIME) $(EMMYLUA_BIN) . --warnings-as-errors

################################################################################
# StyLua (formatter)
################################################################################

STYLUA_VERSION := v2.3.1
STYLUA_DIR := deps/stylua-$(STYLUA_VERSION)
STYLUA_BIN := $(STYLUA_DIR)/stylua
ifeq ($(EMMYLUA_OS),darwin)
    STYLUA_PLATFORM := macos-$(if $(filter arm64,$(EMMYLUA_ARCH)),aarch64,x86_64)
else
    STYLUA_PLATFORM := linux-$(if $(filter arm64,$(EMMYLUA_ARCH)),aarch64,x86_64)
endif
STYLUA_URL := https://github.com/JohnnyMorganz/StyLua/releases/download/$(STYLUA_VERSION)/stylua-$(STYLUA_PLATFORM).zip

$(STYLUA_BIN):
	mkdir -p $(STYLUA_DIR)
	curl -sSL $(STYLUA_URL) -o $(STYLUA_DIR)/stylua.zip
	unzip -oq $(STYLUA_DIR)/stylua.zip -d $(STYLUA_DIR)

LUA_FILES := $(shell find lua plugin tests -name '*.lua')

.PHONY: format
format: $(STYLUA_BIN)
	$(STYLUA_BIN) $(LUA_FILES)

.PHONY: format-check
format-check: $(STYLUA_BIN)
	$(STYLUA_BIN) --check $(LUA_FILES)

################################################################################
# Tests
################################################################################

.PHONY: test
test:
	$(NVIM) --headless --clean -u NONE -l tests/offline_spec.lua

.PHONY: check
check: typecheck format-check test
