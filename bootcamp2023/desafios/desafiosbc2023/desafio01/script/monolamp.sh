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

#stage 1: Infrastructure as Code
function stage1() {
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

	if [ $(dpkg -l | grep -c git) -eq 1]; then
		package_installed+=("git")
	else
		package_not_installed+=("git")
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

	sudo apt update

	for package in "${package_not_installed[@}"; do
		sudo apt install $package -y
	done

	echo "Package installation done"
}

function health_check(){
	packages_up=()
	packages_down=()
	php_status=$(systemctl status php7.4-fpm | grep "active (running)" | wc -l)
	if [ $php_status -eq 1 ]; then
		packages_up+=("php")
	else
		packages_down+=("php")
	fi

	mariadb_status=$(systemctl status mariadb | grep "active (running)" | wc -l)
	if [ $mariadb_status -eq 1 ]; then
		packages_up+=("mariadb")
	else
		packages_down+=("mariadb")
	fi

        apache_status=$(systemctl status apache2 | grep "active (running)" | wc -l)
	if [ $apache_status -eq 1 ]; then
		packages_up+=("apache")
	else
		packages_down+=("apache")
	fi

	git_status=$(dpkg -l | grep -c git)
	if [ $git_status -eq 1 ]; then
		packages_up+=("git")
	else
		packages_down+=("git")
	fi

	curl_status=$(dpkg -l | grep -c curl)
	if [ $curl_status -eq 1 ]; then
		packages_up+=("curl")
	else
		packages_down+=("curl")
	fi
}




