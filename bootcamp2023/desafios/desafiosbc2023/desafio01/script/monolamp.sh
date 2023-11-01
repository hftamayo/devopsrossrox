#!/bin/bash

#stage 0: instructions
echo "==================================================================================="
echo "Monolith LAMP application deployment automation script"
echo "This version is for Debian based distro"
echo "please run the script like this: monolamp <db_admin_password> <user_app_password>"
echo "do not forget you need to have admin creds to run this"
echo "==================================================================================="

#check if the current user belongs to the sudoers group
if [ "$(id -n | grep -c sudo)" -eq 0 ]; then
	echo "This script requires admin privileges for its execution"
	exit 1
fi

#validate if two params were passed as expected
if [ $# -ne 2]; then
	echo "please type both db_admin and user_app passwords"
	exit 1
fi

db_admin=$1
user_app=$2

echo "your creds are: dbadmin: $db_admin and user_app: $user_app. Press 1 to continue, any other key to abort"
read continue

if [ "$continue" != "1" ]; then
	echo "process aborted correctly"
	exit 1
fi

echo "stage 1: please wait while installing the needed packages"

