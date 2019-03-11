#!/bin/sh -e

TARGET_FILE=${1}
TEMP_FILE="/tmp/_diff"

echo "Saving original file to /tmp"
cp ${TARGET_FILE} /tmp
git diff -U0 -w --no-color -- ${TARGET_FILE} > ${TEMP_FILE}
git checkout ${TARGET_FILE}
cat ${TEMP_FILE} | git apply --ignore-whitespace --unidiff-zero -
echo "Done"
