#!/bin/bash
{
	echo To: golovastic@gmail.com
	echo From: andrey.rubanko@gmail.com
	echo Subject: $1
	echo $2
} | ssmtp golovastic@gmail.com
