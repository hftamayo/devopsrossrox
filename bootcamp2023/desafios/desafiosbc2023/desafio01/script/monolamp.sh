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

function check_current_installation() {
	package_installed=()
	package_not_installed=()

	if [ $(dpkg -l | grep -c php) -eq 1]; then
		package_installed+=("php")
	else
		package_not_installed+=("php")
	fi

	if [ $(dpkg -l | grep -c mariadb-server) -eq 1]; then
		package_installed+=("mariadb-server")
	else
		package_not_installed+=("mariadb-server")
	fi

	if [ $(dpkg -l | grep -c apache2) -eq 1]; then
		package_installed+=("apache2")
	else
		package_not_installed+=("apache2")
	fi

	if [ $(dpkg -l | grep -c curl) -eq 1]; then
		package_installed+=("curl")
	else
		package_not_installed+=("curl")
	fi

	echo "Installed packages:"
	for package in "${package_installed[@]}"; do
		echo "$package"
	done

	echo "The next packages will be installed:"
	for package in "${package_not_installed[@]}"; do
		echo "$package"
	done

	echo "installing...."

	for package in "${package_not_installed[@}"; do
		sudo apt install $package -y
	done


}
