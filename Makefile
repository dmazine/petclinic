# Environment settings
ENV                      := GO111MODULE=on CGO_ENABLED=1 GOFLAGS=-mod=mod

# Build settings
BUILD_FLAGS              := -trimpath -ldflags '-s -w'
BUILD_OUTPUT_DIR         := $(CURDIR)/bin
BUILD_PKGS               := ./...

# Generate settings
GENERATE_PKGS            := $(BUILD_PKGS)

# Lint settings
LINT_CONFIG              := $(CURDIR)/.code_quality/.golangci.yml
LINT_PKGS                := $(BUILD_PKGS)

# Run settings
RUN_FLAGS                := $(BUILD_FLAGS)
RUN_PKG                  := $(CURDIR)/cmd/api
RUN_ARGS                 :=

# Tests settings
TEST_FORMAT              := testname
TEST_FLAGS               := -race -v -gcflags=all=-l
TEST_PKGS                := $(BUILD_PKGS)
TEST_BENCH_PATTERN       := .
TEST_COVER_MODE          := atomic
TEST_COVER_PKGS          := $(shell go list ./... | grep -vE '/mocks' | tr "\n" ",")
TEST_COVER_REPORT        := coverage.out
TEST_COVER_METRIC        := block
TEST_COVER_THRESHOLD     := 90.00
TEST_FUZZ_PATTERN        := .

.DEFAULT_GOAL := help

## all: rebuild packages
.PHONY: all
all: clean generate lint test-coverage build

## build: build packages
.PHONY: build
build:
	@echo "==> Building packages <=="
	@mkdir -p $(BUILD_OUTPUT_DIR)
	@$(ENV) go build $(BUILD_FLAGS) -o $(BUILD_OUTPUT_DIR)/ $(BUILD_PKGS)

## cleanup: clean up
.PHONY: clean
clean:
	@echo "==> Cleaning up <=="
	@rm -Rf $(BUILD_OUTPUT_DIR) $(TEST_COVER_REPORT)

## download: download module dependencies
.PHONY: download
download:
	@echo "==> Downloading module dependencies <=="
	@$(ENV) go mod download

## generate: runs commands described by directives within existing files
.PHONY: generate
generate:
	@echo "==> Generating source code <=="
	@$(ENV) go generate $(GENERATE_PKGS)

.PHONY: gofumpt
gofumpt:
	@echo "==> Running gofumpt <=="
	@$(ENV) gofumpt -l -w .

## check-vulnerabilities: reports known vulnerabilities that affect the code
.PHONY: govulncheck
govulncheck:
	@echo "==> Checking for vulnerabilities <=="
	@$(ENV) govulncheck ./...

## help: show this usage help
.PHONY: help
help:
	@ echo "Usage: make [target]\n"
	@ sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

## install-tools: install tools
.PHONY: install-tools
install-tools:
	@echo "==> Installing tools <=="
	@$(ENV) go install github.com/google/wire/cmd/wire@latest
	@$(ENV) go install -tags 'mysql' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
	@$(ENV) go install github.com/golang/mock/mockgen@latest
	@$(ENV) go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	@$(ENV) go install github.com/mcubik/goverreport@latest
	@$(ENV) go install github.com/swaggo/swag/cmd/swag@latest
	@$(ENV) go install github.com/vektra/mockery/v2@latest
	@$(ENV) go install golang.org/x/vuln/cmd/govulncheck@latest
	@$(ENV) go install gotest.tools/gotestsum@latest
	@$(ENV) go install mvdan.cc/gofumpt@latest

## lint: run linters
.PHONY: lint
lint:
	@echo "==> Running linters <=="
	@$(ENV) golangci-lint run --exclude dupl --config $(LINT_CONFIG) $(LINT_PKGS)

## run: run main package
.PHONY: run
run:
	@echo "==> Running <=="
	@$(ENV) go run $(RUN_FLAGS) $(RUN_PKG) $(RUN_ARGS)

.PHONY: swag
swag:
	@echo "==> Generating swagger spec <=="
	@$(ENV) swag fmt
	@$(ENV) swag init --parseDependency -g cmd/api/main.go -o ./docs/specs

## test: run tests
.PHONY: test
test:
	@echo "==> Running tests <=="
	@$(ENV) gotestsum --format $(TEST_FORMAT) -- $(TEST_FLAGS) $(TEST_PKGS)

## test-benchmark: run benchmark tests
.PHONY: test-benchmark
test-benchmark:
	@echo "==> Running benchmark tests <=="
	@$(ENV) gotestsum --format $(TEST_FORMAT) -- $(TEST_FLAGS) -bench=$(BENCHMARK_PATTERN) $(TEST_PKGS)

## test-coverage: run tests with coverage
.PHONY: test-coverage
test-coverage:
	@echo "==> Running tests with coverage <=="
	@$(ENV) gotestsum --format $(TEST_FORMAT) -- $(TEST_FLAGS) -covermode=$(TEST_COVER_MODE) -coverpkg=$(TEST_COVER_PKGS) -coverprofile=$(TEST_COVER_REPORT) $(TEST_PKGS)
	@$(ENV) goverreport -metric $(TEST_COVER_METRIC) -threshold $(TEST_COVER_THRESHOLD) -coverprofile=$(TEST_COVER_REPORT)

## test-fuzz: run fuzz tests
.PHONY: test-fuzz
test-fuzz:
	@echo "==> Running fuzz tests <=="
	@$(ENV) gotestsum --format $(TEST_FORMAT) -- $(TEST_FLAGS) -fuzz=$(FUZZ_PATTERN) $(TEST_PKGS)

## tidy: ensures that the go.mod file matches the source code in the module
.PHONY: tidy
tidy:
	@echo "==> Tidying dependencies <=="
	@$(ENV) go mod tidy

## update-dependencies: updates module dependencies
.PHONY: update-dependencies
update-dependencies:
	@echo "==> Updating module dependencies <=="
	@$(ENV) go get -d -v -t ./...

## upgrade-dependencies: upgrades module dependencies
.PHONY: upgrade-dependencies
upgrade-dependencies:
	@echo "==> Upgrading module dependencies <=="
	@$(ENV) go get -d -v -u -t ./...

## wire: wire dependencies
.PHONY: wire
wire:
	@echo "==> Wiring dependencies <=="
	@$(ENV) wire ./...
