# Instructions for creating a new Go project
A Go project should contain the following things:
- A Makefile that is used to run the code, run the tests, linters and formatters.
- A .golangci.yml file that contains configurations for the `golangci-lint` tool.
- A Dockerfile that runs tests, linters and formatters in a container.
- Appropriate Go programs installed
    - The Go toolchain for my operating system
    - go install golang.org/x/tools/cmd/goimports@latest
    - go install golang.org/x/vuln/cmd/govulncheck@latest
    - go install golang.org/x/tools/cmd/deadcode@latest
    - go install honnef.co/go/tools/cmd/staticcheck@latest
    - go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    - brew install entr

## Example Makefile file:
A Makefile can contain as many commands as possible but these four should always be present:
- check: this runs linters, formatters and tests.
- run: runs the code
- doctor: this runs linters, formatters and tests in a container.
- poll: this starts a poller that runs check everytime changes are made to Go files.

### Example check command:
```
check:
	# Format and organize
	goimports -w .
	gofmt -w .

	go mod tidy

	# Security
	govulncheck ./...

	# Static analysis
	go vet ./...
	deadcode .
	staticcheck ./...
	golangci-lint fmt
	golangci-lint run

	# Testing
	go test -race ./...
```

### Example run command:
```
run:
	go run .
```

### Example doctor command:
```
doctor:
    make check
	docker build -t <project_name_from_go_mod> .
	docker run --rm <project_name_from_go_mod>
```

### Example check command:
```
check:
	# Format and organize
	goimports -w .
	gofmt -w .

	go mod tidy

	# Security
	govulncheck ./...

	# Static analysis
	go vet ./...
	deadcode .
	staticcheck ./...
	golangci-lint fmt
	golangci-lint run

	# Testing
	go test -race ./...
```

### Example poll command:
```
poll:
	find . | entr -r go test -count=1 ./...
```

### Example Dockerfile:
```
FROM golang:tip-alpine3.22

RUN dnf install -y golang git

WORKDIR /app

COPY . .
RUN go mod download


RUN go test ./...
```

### Example .golangci.yml file
```
version: "2"
run:
  concurrency: 10
  tests: true
linters:
  default: all
  disable:
    - arangolint
    - funlen
    - ginkgolinter
    - gochecknoglobals
    - godot
    - godox
    - ireturn # Allow returning interfaces
    - maintidx
    - misspell
    - promlinter
    - wsl # new major
    - depguard # very interesting and useful but not used here
    - exhaustruct
    - cyclop
    - gochecknoinits
    - gocognit
    - gocyclo
    - nestif

formatters:
  settings:
    gofmt:
      # Simplify code: gofmt with `-s` option.
      # Default: true
      simplify: false
      # Apply the rewrite rules to the source before reformatting.
      # https://pkg.go.dev/cmd/gofmt
      # Default: []
      rewrite-rules:
        - pattern: 'interface{}'
          replacement: 'any'
        - pattern: 'a[b:len(a)]'
          replacement: 'a[b:]'
    golines:
      max-len: 200
      tab-len: 4
      # Shorten single-line comments.
      # Default: false
      shorten-comments: true
      # Default: true
      reformat-tags: true
      # Split chained methods on the dots as opposed to the arguments.
      chain-split-dots: true
```
