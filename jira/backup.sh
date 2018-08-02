#!/bin/bash
date
cd /backup
mysqldump -h sieveproject.con5pbfwqyvi.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee jira --routines > jira.bak
cp -r /var/atlassian/application-data/jira/data .
date > ts.txt
zip -r jira.zip data jira.bak ts.txt
rm -r data
rm jira.bak
/usr/local/bin/gdrive update 1tzoJgR8FzCB9I37CiOYBene7UHRDS7FS jira.zip

