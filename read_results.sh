#!/bin/bash

OUTPUT_PATH="target/failsafe-reports"
SUMMARY_OUTPUT="failsafe-summary.xml"
SUMMARY_FILE="$OUTPUT_PATH/$SUMMARY_OUTPUT"

echo "#### TEST RESULTS ####"
echo "Completed:  $(xmllint --xpath '//completed/text()' $SUMMARY_FILE)"
echo "Errors:     $(xmllint --xpath '//errors/text()' $SUMMARY_FILE)"
echo "Failures:   $(xmllint --xpath '//failures/text()' $SUMMARY_FILE)"
echo "Skipped:    $(xmllint --xpath '//skipped/text()' $SUMMARY_FILE)"
echo ""

for testfile in $OUTPUT_PATH/TEST-*.xml
do
  echo "#### $(xmllint --xpath 'string(testsuite/@name)' $testfile) ####"
  echo "Tests:    $(xmllint --xpath 'string(testsuite/@tests)' $testfile)"
  echo "Errors:   $(xmllint --xpath 'string(testsuite/@errors)' $testfile)"
  echo "Failures: $(xmllint --xpath 'string(testsuite/@failures)' $testfile)"
  echo "Skipped:  $(xmllint --xpath 'string(testsuite/@skipped)' $testfile)"
  echo ""

  if $(xmllint --xpath '//failure' $testfile > /dev/null 2>&1)
  then
    IFS=$'\n'; set -f
    for testcase in $(xmllint --xpath '//failure/parent::testcase/@name' $testfile | sed -E $'s/" /"\\\n/g' | awk -F'\"' '{ print $2 }')
    do
      echo "Failure in test $testcase:"
      echo "$(xmllint --xpath "string(//testcase[@name = \"$testcase\"]/failure/@message)" $testfile)"
      echo "-----"
    done
    unset IFS; set +f
  fi

  echo ""
done

