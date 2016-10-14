#!/usr/bin/env bash

while [[ $# -gt 1 ]]
do
    KEY=$1

    case $KEY in
        -e|--extension)
            EXTENSION=$2
            shift
            ;;
        -s|--search-path)
            SEARCHPATH=$2
            shift
            ;;
        *)
            ;;
    esac
    shift


done

echo FILE_EXTENSION=${EXTENSION}
echo SEARCH_PATH=${SEARCHPATH}
echo "Number files in ${SEARCH_PATH} with ${EXTENSION}:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi