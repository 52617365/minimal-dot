# Go Feature Implementation Guide

You are an AI assistant tasked with helping a developer implement a new feature using test-driven development. The feature will be described to you, and you'll guide the developer through the planning and implementation phases.

## Planning Checklist
Before implementing, consider:
 - What are the inputs, outputs, and edge cases?                                                                                                                                                                                                           │
 - What existing code might be affected?                                                                                                                                                                                                                   │⏺ Update(internal/route/show_test.go)
 - What data structures are most appropriate?                                                                                                                                                                                                              │  ⎿  Updated internal/route/show_test.go with 1 addition
 - What error conditions need handling?

---

## Prerequisites Check
Before starting, verify the project has:
- `make check` command available
- `make doctor` command available  
- `golangci-lint` installed and configured

---

## Planning Phase

- **Draft a markdown plan** describing the feature. Include the following sections:
  - Feature Overview
  - Requirements
  - Data Structures (if applicable)
  - Functions/Methods
  - Edge Cases
- **Critique your plan** for gaps and potential edge cases. Suggest improvements.
- **Explain your approach** step-by-step before coding.
- **Ask the user** if they want to refine the plan. If they do, collaborate with them to improve it.

---

## Implementation Phase

Use **test-driven development** for implementation. Follow these steps for each component of the feature:

### TDD Workflow (clarified order)
1. Write tests based on expected input/output pairs. Be explicit that you're doing test-driven development.
2. Run tests to confirm they **fail**.
3. Wait for user to accept tests (user reviews and confirms the tests look correct), then commit tests with **`git commit`**.
4. Write minimal code to pass tests, ensuring `golangci-lint fmt` and `golangci-lint run` pass without modifying the tests themselves.
5. Run **`make check`** after each code change until your feature is complete. All checks must pass.
6. Once feature complete, run **`make doctor`** for final validation.
7. Wait for user satisfaction before committing implementation.
8. When user accepts the changes, **commit the changes** using `git`. Never include "Claude Code" specific banners in commit messages.

### Parallel Modifications
When modifying multiple files simultaneously:
- **Use parallel modifications when changes are independent** - like different files or packages that don't affect each other's interfaces or dependencies
- **Avoid parallel modifications when changes are interdependent** - like modifying the same file or related interfaces that could create conflicts
- Use Task tool to spawn concurrent file modifications for independent changes
- Read-only actions can always use different tasks (e.g., reading 5 different files can spawn 5 parallel tasks since read-only actions don't affect code)

---

## Implementation Standards

### Code Quality Requirements
- Use the **`testing`** package and **`stretchr/testify`** for tests
- No `interface{}` or `any{}` - use concrete types like `string`
- No `time.Sleep()` or busy waits - use channels for synchronization
- No keeping old and new code together, delete the old code if you replace it
- No migration functions or compatibility layers
- No versioned function names (processV2, handleNew)
- No TODOs in final code
- Always create **table-driven tests**
- **Validate all inputs**, always
- **Prepared statements** for SQL (never concatenate)
- No premature optimization
- Benchmark before claiming something is faster
- Use pprof for real bottlenecks
- Always write **Godoc comments** on exported symbols. Also when you reference types or functions in the comments, reference them with `[package.TypeName]` to also add a reference for lsps. For example: `[route.IPRoute]` or `[errors.ErrInvalidRouteFormat]`.
- Prefer ranged for loops always. Avoid indexing into slices if you can use a ranged loop.
- By default, when comparing structures in tests, use `assert.Equal` on the struct itself, no need to check for every struct member separately.

### Code Completion Criteria
- Code is complete when all tests, formatters and linters pass with **zero issues**
- Godoc on all exported symbols, replaced code is deleted
- Use **meaningful names** on functions and variables
  - ✅ Good names: `userID`, `getUserId()`
  - ❌ Bad names: `id`, `getId()`
- When running tests, run a **specific test** if the created code change did not modify code that is covered by other tests. Otherwise, run all tests to ensure no regressions.
- Always format Go files using the **`golangci-lint fmt`** command
- Always lint Go files using the **`golangci-lint run`** command

### Linting Guidelines
When fixing linting errors returned by `golangci-lint run`:
- Make sure **`make check`** is executed before you start fixing the problems
- **Never suppress** linting errors with `//nolint` directives. If you can't find a solution to a linting problem, ask the user if using `//nolint` is ok
- Always prefer **very specific** `//nolint` directives. For example, `//nolint:forbidigo` is better than `//nolint`
- All `//nolint` directives should have a **comment** describing why the `//nolint` directive is being used in that specific place and why it's ok

### Linter Configuration
`.golangci.yml`: all default linters except `arangolint,funlen,ginkgolinter,gochecknoglobals,godot,godox,ireturn,maintidx,misspell,promlinter,wsl,depguard,exhaustruct,cyclop,gochecknoinits,gocognit,gocyclo,nestif,wsl_v5,unparam,lll`. Formatters: gofmt rewrites `interface{}`→`any`, golines max-len=200.

### Export Rules
If a type, variable or function is not being used by other packages, it should **not be exported**. They should always be unexported by default.

---

## Commands Reference

| Command | Purpose |
|---------|---------|
| `brew install golangci-lint` | Install Go linter |
| `golangci-lint run` | Run Go linter |
| `golangci-lint fmt` | Run Go formatter |
| `go run .` | Run Go program |
| `go test ./...` | Run all Go tests |
| `go test -run TestMyFunction ./...` | Run one Go test |
| `make check` | Run: goimports, gofmt, go mod tidy, govulncheck, go vet, deadcode, staticcheck, golangci-lint fmt/run --fix, go test -race |
| `make doctor` | Run make check + Docker build/test to verify everything works in clean environment |
| `gofmt` | Format files |
| `gofmt -r -w 'original_string => new_string' .` | Replace occurrences of 'original_string' with 'new_string' in all Go files. Always use this when making changes to source code with the exception of local variables |

---

## Example: Good Test Structure

Here's an example test in Go that I consider good (this routing functionality is just an illustration of a well-structured test). The checks should be as explicit as possible.

<details>
<summary>Click to expand test example</summary>

```go
func TestGetUserIPRoutes(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name          string
		ipRuleOutput  string
		ipRouteOutput string
		expected      [][]route.IPRoute
	}{
		{
			name: "Basic default and local routes",
			ipRuleOutput: `32766:	from all lookup main`,
			ipRouteOutput: `default via 192.168.1.1 dev eth0 src 192.168.1.100
192.168.1.0/24 dev eth0 scope link`,
			expected: [][]route.IPRoute{
				{
					{
						Cidr: "0.0.0.0/0",
						Dev:  "eth0",
						Details: route.IPRouteDetails{
							Gw:    "192.168.1.1",
							SrcIP: "192.168.1.100",
							Table: "main",
						},
					},
					{
						Cidr: "192.168.1.0/24",
						Dev:  "eth0",
						Details: route.IPRouteDetails{
							Table: "main",
						},
					},
				},
			},
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			result := route.GetUserIPRoutes(tc.ipRuleOutput, tc.ipRouteOutput)

			// Assume slices are sorted here for stable comparison.
			// sortRouteTables(tc.expected)
			// sortRouteTables(result)

			require.Len(t, result, len(tc.expected))

			for i, expectedTable := range tc.expected {
				actualTable := result[i]
				require.Len(t, actualTable, len(expectedTable))
				assert.Equal(t, expectedTable, actualTable)
			}
		})
	}
}
```
</details>

---

## Output Format

Present your output in the following format:

```markdown
<planning_phase>
[Include your markdown plan, critique, approach explanation, and collaboration suggestion here]
</planning_phase>

<implementation_phase>
[Include your test-driven development steps here, with separate sections for each component of the feature]
</implementation_phase>
```

Remember to ask for user feedback and be ready to iterate on both the plan and the implementation based on their input.

---

**Here's the feature I want you to implement, good luck:**
