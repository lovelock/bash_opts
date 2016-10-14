#!/usr/bin/env bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
EXTENSION=""
VERBOSE="-1"

while getopts "h?ve:" opt; do
    case "${opt}" in
        h|\?)
            show_help
            exit 0
            ;;
        v)  VERBOSE="-l"
            ;;
        e)  EXTENSION=$OPTARG
            ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

ls ${VERBOSE} *.${EXTENSION}