#!/usr/bin/env bash

for i in $@
do
    case $i in
        -e=*|--extension=*)
            EXTENSION="${i#*=}"
            shift # past argument=value
            ;;
        -s=*|--searchpath=*)
            SEARCHPATH="${i#*=}"
            shift # past argument=value
            ;;
        *)
            # unknown option
            ;;
    esac
done

echo "FILE EXTENSION  = ${EXTENSION}"
echo "SEARCH PATH     = ${SEARCHPATH}"
echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi