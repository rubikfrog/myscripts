#!/bin/bash
cd /backup
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
/etc/init.d/jira stop
data="/var/atlassian/application-data/jira/data"
ch0=`ps -ef | grep jira | grep -v grep | wc -l`

#
#	clear all
#
rm -rf /backup/*
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
rm -r $data
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee -e 'drop database jira'
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
ch1=`ls /backup | wc -l`
ch2=`ls $data | wc -l`
ch3=`mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee -e 'show databases' | grep jira | wc -l`
ch=$(($ch1 + $ch2 + $ch3 + $ch0))
echo $ch1 $ch2 $ch3 $ch0
if [[ $ch -ne 0 ]]
then
	echo "non zero!"
	exit 1
else
	echo "check 1 passed"
fi

echo "clear backup - " `ls | wc -l` "left"
gdrive download 1tzoJgR8FzCB9I37CiOYBene7UHRDS7FS --force
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
unzip jira.zip
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
d1=`cat /backup/ts.txt | cut -c 1-10`
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
d2=`date | cut -c 1-10`
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
if [[ $d1 = $d2 ]]
then
	echo "equal!"
else
	echo "not equal!"
	exit 1
fi
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi


mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee -e 'create database jira CHARACTER SET utf8 COLLATE utf8_bin'
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee jira < jira.bak
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
ch1=`mysql -h myrecheck.c2pu9wmfskp0.eu-central-1.rds.amazonaws.com -urubik -pMknr65Tee jira -e "select count(*) qty from avatar where owner = 'golovastic@gmail.com'" -BN`
if [[ $ch1 -ne 1 ]]
then
	echo "something wrong with mysql restore"
	exit 1
fi

cp -r /backup/data $data
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
chown jira:jira -R $data
if [[ $? -ne 0 ]]; then echo "ERROR"; exit $?; fi
/etc/init.d/jira start
ch0=`ps -ef | grep jira | grep -v grep | wc -l`
if [[ $ch0 -eq 0 ]]
then
	echo "jira wont start"
	exit 1
fi

echo "fin"
