# CodeQL troubleshooting container

The aim of this repository is to create a workspace where you can test CodeQL in various scenarios without having to install too many tools on your machine.

In order to run this project you need to have `Docker` and `VSCode` installed on your machine

It uses `devcontainers` to create a workspace with all the tools needed to create/build code. It also has the CodeQL CLI installed so that you can run code analysis.

The main folder is `script` where you'll find a small helper for running CodeQL.

```
Usage: run-codeql.sh <command> [options]
```

To make execution easier, each folder has a `run.sh` with the commands already created so that you can just run the file.

This devcontainer is configured with some VSCode extensions such as `MS-SarifVSCode.sarif-viewer` which will allow you to view the result file. 

All devcontainers has a feature that enable you to run a github action locally. The name of this feature is Act and you can see how to use it bellow.

# Code QL
## Query Suite

Check [CodeQL query suites](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/javascript-typescript-built-in-queries) for more information

### default
- The default query suite is the group of queries run by default in CodeQL code scanning on GitHub.

- The queries in the default query suite are highly precise and return few false positive code scanning results. Relative to the security-extended query suite, the default suite returns fewer low-confidence code scanning results.

- This query suite is available for use with default setup for code scanning.

### security-extended
- The security-extended query suite consists of all the queries in the default query suite, plus additional queries with slightly lower precision and severity.

- Relative to the default query suite, the security-extended suite may return a greater number of false positive code scanning results.

- This query suite is available for use with default setup for code scanning, and is referred to as the "Extended" query suite on GitHub.

### security-and-quality
- The security-extended query suite consists of all the queries in the default query suite and security-extended, plus extra maintainability and reliability queries.
 
## Limitations

## --db-cluster

When using the CodeQL CLI on thsi repository, you will only be able to analyze one language per scan. I tried to use --db-cluster but I was not able to make it run. As I will not need it now I did not tried to fix it. 

## --command

My script is not prepared to receive the --command and send it to the CodeQL CLI. So if you need this feature you can implement it or you can change the `scripts/run-codeql.sh` file and customize the `init` call with the command that you need.

# Act

Act allow you to run a github action locally. Click [here](https://nektosact.com/introduction.html) to learn more about this tool.

## How to use it 

This repository has three files that will be used by Act: 

- `act.event.json`: This simulates a github event such as PR, Merge and others
- `act.secrets`: This simulates the github repository secrets
- `act.variables`: This simulates the github repository variables

The most used command are:

```
# Executes all Actions
act

# Execute a specified Action 
act -W '.github/workflows/codeql.yaml'

# Execute a specified Action using the variable, secrets and event files
act --var-file act.variables --secret-file my.secrets  -e event.json  -W '.github/workflows/codeql.yaml'

# If you want to speed up running act and using cached actions and container images you can enable this mode
act --action-offline-mode

# Some actions will interact with github and you will need to provide a valid github token 
# You can use the github cli. Make sure to login into github (`gh auth login`) before running the command 
act -s GITHUB_TOKEN="$(gh auth token)"

# You can use a PAT token
act -s GITHUB_TOKEN=<Your_token_here> -W '.github/workflows/codeql.yaml'

```

To facilitate, you can use some alias:

````

# act --action-offline-mode --var-file act.variables --secret-file my.secrets -e event.json -s GITHUB_TOKEN="$(gh auth token)" -W '.github/workflows/codeql.yaml'
act_off -W '.github/workflows/codeql.yaml'

# act --var-file act.variables --secret-file my.secrets -e event.json -s GITHUB_TOKEN="$(gh auth token)" -W '.github/workflows/codeql.yaml'
act_on -W '.github/workflows/codeql.yaml'

```