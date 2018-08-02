#!/bin/bash
cd /backup
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
/etc/init.d/jira stop
data="/var/atlassian/application-data/jira/data"
service jira status

rm -rf /backup/*
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
rm -r $data
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee -e 'drop database jira'
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi


echo "clear backup - " `ls | wc -l` "left"
gdrive download 1tzoJgR8FzCB9I37CiOYBene7UHRDS7FS --force
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
unzip jira.zip
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
echo "ts.txt:"
cat /backup/ts.txt
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee -e 'create database jira CHARACTER SET utf8 COLLATE utf8_bin'
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee jira < jira.bak
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
cp -r /backup/data $data
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
chown jira:jira -R $data
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
/etc/init.d/jira start

echo "fin"
