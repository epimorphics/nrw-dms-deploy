#!/bin/bash
# Kludge forecast upload to duplicate Rhyl to Rhyl East (vomitsome)
# Usage:  forecast-rhyl  uploadfile uploadURI

# [[ $# = 2 ]] || { echo "Internal error calling $0" 1>&2 ; exit 1 ; }
readonly file="$1"
readonly orig="${file}.orig"
readonly updateURI=$2

if grep -sq 40600 $file && grep -sqv 40650 $file ; then
    cp $file $orig
    echo "" >> $file  # Fix lack of line ending for last line
    grep 40600 $orig | sed -e 's/40600/40650/' >> $file
    echo "Duplicated Rhyl forecast to Rhyl East"
    if [[ $updateURI =~ .*/([^/]*)$ ]]; then
        uid=${BASH_REMATCH[1]}
        echo "Attemping to reconvert modified file"
        curl -i -u forecastuser:r1SuN4MsNf -H  -X POST http://localhost/dms/services/nrwbwq/components/forecasts/update/$uid/reconvert
        sleep 5s
    fi
else
    echo "Either no Rhyl forecast or already a Rhyl East, skipping"
fi
