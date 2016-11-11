#!/bin/bash

# HTML
for i in target/site/selenium-reports/*.html
do
  echo "### $i HTML REPORT ###"
  cat $i
  echo "### END OF $i HTML REPORT ###"
done

# XML
for i in target/failsafe-reports/*.xml
do
  echo "### $i XML REPORT ###"
  cat $i
  echo "### END OF $i XML REPORT ###"
done

