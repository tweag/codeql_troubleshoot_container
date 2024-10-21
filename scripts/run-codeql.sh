#!/bin/bash

RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
WHITE="\033[37m"
BOLD="\033[1m"

print_red() {
    echo -e "${RED}${1}${RESET}"
}

print_green() {
    echo -e "${GREEN}${1}${RESET}"
}

print_yellow() {
    echo -e "${YELLOW}${1}${RESET}"
}

print_white() {
    echo -e "${WHITE}${1}${RESET}"
}

print_blue() {
    echo -e "${BLUE}${1}${RESET}"
}

print_normal() {
    echo -e "${RESET}${1}${RESET}"
}

# parse parameters
script_name=$(basename "$0")
rm -rf results
mkdir results
SRC_DIR="."
results_dir="results"
COMMAND="$1"
OUTPUT_FORMAT="sarif-latest"
shift

for i in "$@"; do
    case $i in
        -l=*|--lang=*|--language=*)
            LANGUAGE="${i#*=}"
            shift # past argument=value
            ;;
        -l|--lang|--language)
            LANGUAGE="$2"
            shift 2 # past argument and value
            ;;
        -o=*|--output=*|--output-format=*)
            OUTPUT_FORMAT="${i#*=}"
            shift # past argument=value
            ;;
        -o|--output|--output-format)
            OUTPUT_FORMAT=$2
            shift 2 # past argument and value
            ;;
        --override)
            OVERRIDE_RESULTS_DIR=true
            shift # past argument with no value
            ;;
        --path)
            SRC_DIR=$2
            shift 2 # past argument and value
            ;;
        --path=*)
            SRC_DIR="${i#*=}"
            shift 2 # past argument and value
            ;;
        *)
            ;;
    esac
done

print_info() {
    print_blue   "${BOLD}CodeQL-container version v${VERSION}"
    print_blue   "Path: ${SRC_DIR}"
    print_normal ""
}

do_help() {
    print_info

    print_normal "Usage: run-codeql.sh <command> [options]"
    print_normal ""
    print_normal "Commands:"
    print_normal "  help                       Print the help information and exit"
    print_normal "  default                    Analyze default "
    print_normal "  security-extended          Analyze security and quality (extended)"
    print_normal "  security-and-quality       Analyze security and quality (extended) plus extra maintainability and reliability queries"
    print_normal ""
    print_normal "Options:"
    print_normal "  -l, --language             The programming language of the source code to scan, for example ${BLUE}${BOLD}java"
    print_normal "  -o, --output               The output format of the scan results, for example ${BLUE}${BOLD}sarifv2.1.0"
    print_normal "      --override             Override the results directory if it is not empty"
    print_normal "      --path                 Path to the source directory"
    print_normal ""
}

check_directories() {
    # check if ${SRC_DIR} and ${results_dir} are mapped
    if [ ! -d "${SRC_DIR}" ]; then
        print_red "Error: Source code directory ${SRC_DIR} is not mapped!"
        do_help
        exit 1
    fi
    if [ ! -d "${results_dir}" ]; then
        print_red "Error: Results directory ${results_dir} is not mapped!"
        do_help
        exit 1
    fi

    # check if ${results_dir} is empty or $(OVERRIDE_RESULTS_DIR) is true
    if [ ! -z "$(ls -A ${results_dir})" ]; then
        if [ "${OVERRIDE_RESULTS_DIR}" != "true" ]; then
            print_red "Error: Results directory ${results_dir} is not empty!"
            do_help
            exit 1
        fi
    fi
}

check_language() {
    if [ -z "${LANGUAGE}" ]; then
        print_red "Error: Language is not specified!"
        do_help
        exit 1
    fi
}

do_analyze() {
    print_info

    print_yellow "Creating the CodeQL database. This might take some time depending on the size of the project..."
    print_blue   "DEBUG: codeql database create --overwrite --language=${LANGUAGE} -s ${SRC_DIR} ${results_dir}/codeql-db"
    
    #export GRADLE_OPTS="-Xmx2g"
    #codeql database create --overwrite --language=${LANGUAGE} -s ${SRC_DIR} ${results_dir}/codeql-db  --command='gradle build --info' 

    codeql database create --overwrite --language=${LANGUAGE} -s ${SRC_DIR} ${results_dir}/codeql-db  

    if [ $? -eq 0 ]
    then
        print_green "\nCreated the database" 
    else
        print_red "\nFailed to create the database"
        exit 1
    fi

    output_file="${results_dir}/codeql-results.${OUTPUT_FORMAT}"
    if [[ "${OUTPUT_FORMAT}" =~ ^sarif.* ]]; then
        output_file="${results_dir}/codeql-results.sarif"
    fi

    QUERY_SUITES="$1"
    if [ "$QUERY_SUITES" == "default" ]; then
        print_yellow "\nRunning the default rules on the project..."
        print_blue   "DEBUG: codeql database analyze --format=${OUTPUT_FORMAT} --output=${output_file} ${results_dir}/codeql-db"
        codeql database analyze --format=${OUTPUT_FORMAT} --output=${output_file} ${results_dir}/codeql-db 
    else
        print_yellow "\nRunning the ${QUERIES} rules on the project..."
        print_blue   "DEBUG: codeql database analyze --format=${OUTPUT_FORMAT} --output=${output_file} ${results_dir}/codeql-db ${LANGUAGE}-${QUERY_SUITES}.qls"
        codeql database analyze --format=${OUTPUT_FORMAT} --output=${output_file} ${results_dir}/codeql-db ${LANGUAGE}-${QUERY_SUITES}.qls 
    fi

    if [ $? -eq 0 ]
    then
        print_green "\nQuery execution successful" 
    else
        print_red "\nQuery execution failed\n"
        exit 1
    fi

    [ $? -eq 0 ] && print_yellow "\nDone. The results are saved at ${output_file}"
}

case $COMMAND in
    default )
        check_directories
        check_language
        do_analyze "default"
        ;;
    security-and-quality)
        check_directories
        check_language
        do_analyze "security-and-quality"
        ;;
     security-extended)
        check_directories
        check_language
        do_analyze "security-extended"
        ;;
    *)
        do_help
        ;;
esac
