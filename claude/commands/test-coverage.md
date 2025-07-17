# Checking test coverage for code base
1. Run the following commands:
    # Create reports directory if it doesn't exist
	1. mkdir -p reports
	# Run go tests with coverage and output to profile
	2. go test ./... -coverprofile=reports/coverage.out
	# Generate HTML report from coverage profile
	3. go tool cover -html=reports/coverage.out -o reports/test_report.html
2. Read through @reports/test_report.html, this is the test coverage output written by the `go tool cover` command. I want you to look at this HTML to determine what function branches are not covered. Uncovered code is styled as red, covered code is styled as green.
