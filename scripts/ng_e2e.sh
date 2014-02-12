#!/bin/bash

BASE_DIR=`dirname $0`

echo ""
echo "Starting Protractor tests"
echo $BASE_DIR
echo "-------------------------------------------------------------------"

protractor $BASE_DIR/../spec/angular/e2e/protractor.conf.js $*
