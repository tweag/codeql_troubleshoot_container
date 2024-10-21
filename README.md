
# CodeQL Troubleshooting Container

This repository provides a pre-configured workspace to test CodeQL in various scenarios without the need for extensive tool installation on your local machine. It uses Docker and VSCode's devcontainers to create a fully equipped environment for code analysis and development.

## Prerequisites

Ensure you have the following installed on your machine before running this project:

- [Docker](https://www.docker.com/get-started)
- [VSCode](https://code.visualstudio.com/download)

## Features

- **Devcontainers**: A development environment with all required tools, including the CodeQL CLI, to run code analysis.
- **CodeQL CLI**: Pre-installed for analyzing code.
- **VSCode Extensions**: Includes extensions like `MS-SarifVSCode.sarif-viewer` for viewing CodeQL results.

### Folder Structure
- **`/.devcontainers`**: Contains a specification of a devcontainer for each language environment.
- **`/script`**: Contains a helper script for running CodeQL analyses.
  
  **Usage**: 
  ```bash
  ./run-codeql.sh <command> [options]
  ```

  Each folder contains a `run.sh` file with predefined commands, making it easier to execute without manually specifying them.

## CodeQL Query Suites

CodeQL allows you to use different query suites depending on the level of precision and coverage you require:

- **Default**: Highly precise queries with minimal false positives, used for standard GitHub code scanning.
- **Security-Extended**: Expands on the default suite with more security-related queries, but may introduce additional false positives.
- **Security-and-Quality**: Includes both security queries and additional maintainability and reliability checks.

For more information on CodeQL query suites, check [this documentation](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/about-codeql).

## Known Limitations

- **`--db-cluster` Option**: This repository only supports analyzing one language per scan. Attempts to use `--db-cluster` were unsuccessful.
- **`--command` Option**: The current script doesn't support passing the `--command` argument directly. If needed, you can modify `scripts/run-codeql.sh` to customize the CodeQL CLI call.

## Running GitHub Actions Locally with Act

This repository is configured to allow running GitHub Actions locally using [Act](https://github.com/nektos/act).

### Act Setup

To simulate GitHub events, secrets, and variables, the following files are provided:

- **`act.event.json`**: Simulates GitHub events (e.g., pull requests, merges).
- **`act.secrets`**: Mimics repository secrets.
- **`act.variables`**: Simulates repository variables.

### Common Act Commands

1. **Run all GitHub Actions:**
   ```bash
   act
   ```

2. **Run a specific GitHub Action workflow:**
   ```bash
   act -W '.github/workflows/codeql.yaml'
   ```

3. **Run a specific Action with secrets, variables, and event files:**
   ```bash
   act --var-file act.variables --secret-file act.secrets -e act.event.json -W '.github/workflows/codeql.yaml'
   ```

4. **Enable offline mode for faster execution with cached actions and containers:**
   ```bash
   act --action-offline-mode
   ```

5. **Run an action with a valid GitHub token (via GitHub CLI):**
   ```bash
   act -s GITHUB_TOKEN="$(gh auth token)" -W '.github/workflows/codeql.yaml'
   ```

6. **Use a Personal Access Token (PAT):**
   ```bash
   act -s GITHUB_TOKEN=<Your_token_here> -W '.github/workflows/codeql.yaml'
   ```

### Useful Aliases

To simplify command execution, you can define the following aliases:

```bash
# Offline mode with variables, secrets, and event files:
alias act_off='act --action-offline-mode --var-file act.variables --secret-file act.secrets -e act.event.json -s GITHUB_TOKEN="$(gh auth token)" -W ".github/workflows/codeql.yaml"'

# Standard mode with variables, secrets, and event files:
alias act_on='act --var-file act.variables --secret-file act.secrets -e act.event.json -s GITHUB_TOKEN="$(gh auth token)" -W ".github/workflows/codeql.yaml"'
```
