#!/bin/bash

#stage 0: instructions
function stage1() {
	echo "==================================================================================="
	echo "Monolith LAMP application deployment automation script"
	echo "This version is for Debian based distro"
	echo "please run the script like this: monolamp <db_admin_password> <user_app_password>"
	echo "do not forget you need to have admin creds to run this"
	echo "==================================================================================="

	#check if the current user is root or uses sudo command
	if [ "$(id -nu)" != "root" ]; then
		echo "Your account does not have enough administrative privileges"
		exit 1
	fi
	
	echo "Please wait while checking status of the needed packages"
	
	package_installed=()
	package_not_installed=()

	if hash php 2>/dev/null; then
		package_installed+=("php")
	else
		package_not_installed+=("php")
		package_not_installed+=("php-mysql")
		package_not_installed+=("php-mbstring")
		package_not_installed+=("php-zip")
		package_not_installed+=("php-gd")
		package_not_installed+=("php-json")
		package_not_installed+=("php-curl")
	fi
		
	if hash mysql 2>/dev/null; then
		package_installed+=("mariadb-server")
	else
		package_not_installed+=("mariadb-server")
	fi
	
	if hash apache2 2>/dev/null; then
		package_installed+=("apache2")
	else
		package_not_installed+=("apache2")
		package_not_installed+=("libapache2-mod-pdp")
	fi	

	if hash git 2>/dev/null; then
		package_installed+=("git")
	else
		package_not_installed+=("git")
	fi

	if hash curl 2>/dev/null; then
		package_installed+=("curl")
	else
		package_not_installed+=("curl")
	fi		
		
	if [ ${#package_installed[@]} -gt 0 ]; then
		echo "number of installed packages : "
		echo ${#package_installed[@]}
		for package in "${package_installed[@]}"; do
			echo "$package"
		done
	else
		echo "It requires a complete installation"
	fi

	if [ ${#package_not_installed[@]} -gt 0 ]; then
		echo "number of packages not installed : "
		echo ${#package_not_installed[@]}
		echo "The next packages will be installed:"
		for package in "${package_not_installed[@]}"; do
			echo "$package"
		done
	else
		echo "All packages are installed"
	fi

	if [ ${#package_not_installed[@]} -gt 0 ]; then
		echo "updating system"
		apt update

		echo "installing...."
		for package in "${package_not_installed[@]}"; do
			apt install $package -y
		done
		echo "Package installation done"
	fi
	sleep 1
}

function health_check() {
	packages_up=()
	packages_down=()
	
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

	if php --version > /dev/null 2>&1; then
		packages_up+=("php")
	else
		packages_down+=("php")
	fi

	if git --version > /dev/null 2>&1; then
		packages_up+=("git")
	else
		packages_down+=("git")
	fi

	if curl --version > /dev/null 2>&1; then
		packages_up+=("curl")
	else
		packages_down+=("curl")
	fi

	echo "Packages up and running:"
	for package in "${packages_up[@]}"; do
		echo "$package"
	done	


	if [ ${#packages_down[@]} -gt 0 ]; then
		echo "packages with error status:"
		for package in "${packages_down[@]}"; do
			echo "$package"
		done
		exit 1
	fi

	echo "All packages are set and ready for the next stage"
}

main() {
	stage1
	health_check

	sleep 1
	echo "Installing code base..."
	
}

main
