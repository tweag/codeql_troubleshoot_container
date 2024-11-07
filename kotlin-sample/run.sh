#!/bin/bash

# Choose the CodeQL pack to run using CodeQL CLI

#../scripts/run-codeql.sh default --path=$(pwd) --override --language=java 

#../scripts/run-codeql.sh security-and-quality --path=$(pwd) --override --language=java 

#../scripts/run-codeql.sh "security-extended" --path=$(pwd) --override --language=java 

# Choose the Github Action to run
# BEFORE RUNNING ANY OF THE BELOW COMMANDS, MAKE SURE YOU HAVE AUTHENTICATED WITH GITHUB CLI USING `gh auth login`

#Uses the CodeQL CLI
#act --action-offline-mode --input sample=kotlin-sample -s GITHUB_TOKEN=$(gh auth token) -W '.github/workflows/codeql-cli.yaml'

#Uses the CodeQL Action
#Note: The CodeQL Action is not fully supported by act, so it will fail on the last step that is to upload the sarif file to the CodeQL tab in the Github UI.
#      If you get "Caught an exception while gathering information for telemetry: HttpError: Not Found. Will skip sending status report" error, it´s because of this.
#act --action-offline-mode --input language=java-kotlin --input query_suite=security-extended -s GITHUB_TOKEN=$(gh auth token) -W '.github/workflows/codeql.yaml'