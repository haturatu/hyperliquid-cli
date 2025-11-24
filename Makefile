.ONESHELL:
.PHONY: all build install clean hyperliquid-src

HYPERLIQUID_REPO := https://github.com/dennohpeter/hyperliquid.git
HYPERLIQUID_DIR := vendor/hyperliquid
PATCH_FILE := hyperliquid-fix.patch

all: build

hyperliquid-src:
	echo "Checking for hyperliquid source in $(HYPERLIQUID_DIR)..."
	if [ ! -d "$(HYPERLIQUID_DIR)" ]; then
		echo "Cloning $(HYPERLIQUID_REPO) into $(HYPERLIQUID_DIR)..."
		mkdir -p $(HYPERLIQUID_DIR)
		git clone $(HYPERLIQUID_REPO) $(HYPERLIQUID_DIR)
	else
		echo "hyperliquid source already exists."
	fi

	echo "Applying patch $(PATCH_FILE)..."
	if [ ! -f "$(HYPERLIQUID_DIR)/.patched" ]; then
		patch -p1 -d $(HYPERLIQUID_DIR) < $(PATCH_FILE)
		touch "$(HYPERLIQUID_DIR)/.patched"
	else
		echo "Patch already applied."
	fi

build: hyperliquid-src
	@echo "Building hl project..."
	cargo build --jobs 1 --release

install: build
	@echo "Installing hl project..."
	cargo install --jobs 1 --path .

clean:
	@echo "Cleaning up..."
	rm -rf $(HYPERLIQUID_DIR)
	cargo clean