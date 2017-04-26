#!/bin/bash
# Kludge forecast upload to duplicate Rhyl to Rhyl East (vomitsome)
# Usage:  forecast-rhyl  uploadfile 

[[ $# = 1 ]] || { echo "Internal error calling $0" 1>&2 ; exit 1 ; }
readonly file="$1"

# Preserve incomign file for debug
cp $file $file.orig

# Ensure file ends in newline, the PRFs as supplied don't
sed -i -e '$a\' $file

echo "Removing forecasts for Aberdaron and Criccieth"
sed -i -e '/39950/d' -e '/39700/d' $file

if grep -sq 40600 $file && grep -sqv 40650 $file ; then
    echo "Duplicating Rhyl forcecast to Rhyl East"
    grep 40600 temp.csv | sed -e 's/40600/40650/' >> $file

#    if [[ $file =~ (.*)\.csv ]]; then
#        refile="${BASH_REMATCH[1]}-rhyl-east.csv"
#    else
#        refile="${file}-rhyl-east.csv"
#    fi
#    head -1 $file > $refile
#    grep 40600 $file | sed -e 's/40600/40650/' >> $refile
#    echo "Attempting to publish secondary forecast for Rhyl East"
#    curl -s -u forecastuser:r1SuN4MsNf -H "Content-Type: text/csv" -X POST --data-binary "@$refile" http://localhost:8080/dms/api/nrwbwq/components/forecasts/publishProduction
else
    echo "Either no Rhyl forecast or already a Rhyl East, skipping"
fi
