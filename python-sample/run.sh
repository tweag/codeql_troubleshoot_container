#!/bin/bash

../scripts/run-codeql.sh default --path=$(pwd) --override --language=python 

#../scripts/run-codeql.sh security-and-quality --path=$(pwd) --override --language=python 

#../scripts/run-codeql.sh "security-extended" --path=$(pwd) --override --language=python 