#!/bin/bash
# Kludge forecast upload to duplicate Rhyl to Rhyl East (vomitsome)
# Usage:  forecast-rhyl  uploadfile 

[[ $# = 1 ]] || { echo "Internal error calling $0" 1>&2 ; exit 1 ; }
readonly file="$1"

if grep -qi prediction_text_en $file ; then
  echo "Looks like a PRF, check for intercept"

  # Preserve incoming file for debug
  cp $file $file.orig

  # Ensure file ends in newline, the PRFs as supplied don't
  sed -i -e '$a\' $file

  # Special case for Cemaes to forward before deletion
  if grep -sq 40050 $file ; then
    echo "Forwarding forecast for Cemaes"
    CEMAES_PRF=$( grep 40050 $file | sed -e 's/,0,/,Unknown risk,/' -e 's/,1,/,Normal risk,/' -e 's/,2,/,Increased risk,/' -e 's/,/, /g' )
    CEMAES_SNS_TOPIC=arn:aws:sns:eu-west-1:828737851284:cemaes-prf
    aws sns publish --topic-arn $CEMAES_SNS_TOPIC --region=eu-west-1 --subject "Cemaes forecast" --message "EA Forecast for Cemaes: $CEMAES_PRF"
  fi

  echo "Removing forecasts for Aberdaron, Criccieth and Cemaes"
  sed -i -e '/39950/d' -e '/39700/d' -e '/40050/d' $file

  if grep -sq 40600 $file && grep -sqv 40650 $file ; then
    echo "Duplicating Rhyl forcecast to Rhyl East"
    grep 40600 $file | sed -e 's/40600/40650/' >> $file
  else
    echo "Either no Rhyl forecast or already a Rhyl East, skipping"
  fi

else
    echo "Not a PRF, no, intercept"
fi
