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

# Query Suite

Check [CodeQL query suites](https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/javascript-typescript-built-in-queries) for more information

Translated with DeepL.com (free version)

## default
- The default query suite is the group of queries run by default in CodeQL code scanning on GitHub.

- The queries in the default query suite are highly precise and return few false positive code scanning results. Relative to the security-extended query suite, the default suite returns fewer low-confidence code scanning results.

- This query suite is available for use with default setup for code scanning.

## security-extended
- The security-extended query suite consists of all the queries in the default query suite, plus additional queries with slightly lower precision and severity.

- Relative to the default query suite, the security-extended suite may return a greater number of false positive code scanning results.

- This query suite is available for use with default setup for code scanning, and is referred to as the "Extended" query suite on GitHub.

## security-and-quality
- The security-extended query suite consists of all the queries in the default query suite and security-extended, plus extra maintainability and reliability queries.
