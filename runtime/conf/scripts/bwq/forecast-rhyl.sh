#!/bin/bash
# Kludge forecast upload to duplicate Rhyl to Rhyl East (vomitsome)
# Usage:  forecast-rhyl  upload

echo Args = "$@"

# [[ $# = 1 ]] || { echo "Internal error calling $0" 1>&2 ; exit 1 ; }
readonly file="$1"
readonly orig="${file}.orig"

if grep -sq 40600 $file && grep -sqv 40650 $file ; then
    cp $file $orig
    echo "" >> $file  # Fix lack of line ending for last line
    grep 40600 $orig | sed -e 's/40600/40650/' >> $file
    echo "Duplicated Rhyl forecast to Rhyl East"

else
    echo "Either no Rhyl forecast or already a Rhyl East, skipping"
fi
