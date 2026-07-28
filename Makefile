.PHONY: dev build start lint test contract-test test-all clean

# ─── Frontend (Next.js) ──────────────────────────────────────────────────────

dev:          ## Start the Next.js development server
	npm run dev

build:        ## Build the Next.js application
	npm run build

start:        ## Start the production Next.js server
	npm run start

lint:         ## Lint the Next.js frontend code
	npm run lint

# ─── Soroban Smart Contract ──────────────────────────────────────────────────

contract-test: ## Run the Soroban contract test suite
	cd contracts/poll && cargo test

contract-lint: ## Run cargo clippy on the Soroban contract
	cd contracts/poll && cargo clippy -- -D warnings

contract-fmt:  ## Check Rust formatting on the Soroban contract
	cd contracts/poll && cargo fmt --check

# ─── Combined ─────────────────────────────────────────────────────────────────

test:         ## Run the full test suite (contract + frontend lint)
	$(MAKE) contract-test
	$(MAKE) lint

test-all:     ## Run all CI checks: formatting, linting, tests
	cd contracts/poll && cargo fmt --check
	cd contracts/poll && cargo clippy -- -D warnings
	cd contracts/poll && cargo test
	$(MAKE) lint

# ─── Utilities ────────────────────────────────────────────────────────────────

clean:        ## Clean build artifacts (both frontend and contract)
	rm -rf .next out
	cd contracts/poll && cargo clean

help:         ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
