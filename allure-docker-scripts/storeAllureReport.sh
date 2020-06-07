#!/bin/bash

PROJECT_ID=$1
PROJECT_REPORTS_DIRECTORY=$STATIC_CONTENT_PROJECTS/$PROJECT_ID/reports
PROJECT_LATEST_REPORT=$PROJECT_REPORTS_DIRECTORY/latest

if [ ! -d "$PROJECT_LATEST_REPORT" ]; then
    echo "Creating latest report directory for PROJECT_ID: $PROJECT_ID"
    mkdir -p $PROJECT_LATEST_REPORT
fi

if [ -e $PROJECT_LATEST_REPORT ]; then
    LAST_REPORT_PATH_DIRECTORY=$(ls -td $PROJECT_REPORTS_DIRECTORY/* | grep -v latest | grep -v $EMAILABLE_REPORT_FILE_NAME | head -1)
else
    LAST_REPORT_PATH_DIRECTORY=$(ls -td $PROJECT_REPORTS_DIRECTORY/* | grep -v $EMAILABLE_REPORT_FILE_NAME | head -1)
fi

LAST_REPORT_DIRECTORY=$(basename -- "$LAST_REPORT_PATH_DIRECTORY")

if [ -z "$LAST_REPORT_DIRECTORY" ]; then
    INIT_DIRECTORY=$PROJECT_REPORTS_DIRECTORY/0
    mkdir -p $INIT_DIRECTORY
    echo 'init' > $INIT_DIRECTORY/init
fi

#echo "LAST REPORT DIRECTORY >> $LAST_REPORT_DIRECTORY"
if [ -n "$LAST_REPORT_DIRECTORY" ]; then
    if [ "$(ls -A $PROJECT_LATEST_REPORT | wc -l)" != "0" ]; then
        echo "Storing results for PROJECT_ID: $PROJECT_ID"
        DIR_NAME=$(($LAST_REPORT_DIRECTORY + 1))
        NEW_REPORT_DIRECTORY=$PROJECT_REPORTS_DIRECTORY/$DIR_NAME
        mkdir -p $NEW_REPORT_DIRECTORY
        cp --recursive --preserve=timestamps $PROJECT_LATEST_REPORT/* $NEW_REPORT_DIRECTORY/
    fi
fi