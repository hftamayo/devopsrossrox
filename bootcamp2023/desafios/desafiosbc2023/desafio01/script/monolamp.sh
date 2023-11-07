#!/bin/bash

#stage 0: instructions
function stage0() {
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
}

#stage 1: Infrastructure as Code
function stage1() {
	echo "stage 1: please wait while installing the needed packages"

	package_installed=()
	package_not_installed=()

	if [ $(dpkg -l | grep -c php) -eq 1]; then
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

	if [ $(dpkg -l | grep -c mariadb-server) -eq 1]; then
		package_installed+=("mariadb-server")
	else
		package_not_installed+=("mariadb-server")
	fi

	if [ $(dpkg -l | grep -c apache2) -eq 1]; then
		package_installed+=("apache2")
	else
		package_not_installed+=("apache2")
		package_not_installed+=("libapache2-mod-pdp")
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

	apt update

	for package in "${package_not_installed[@]}"; do
		apt install $package -y
	done

	echo "Package installation done"
}

function health_check() {
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

	echo "Packages up and running:"
	for package in "${packages_up[@]}"; do
		echo $package
	done

	if [ ${#packages_down[@]} -gt 0 ]; then
		echo "packages with error status:"
		for package in "${packages_down[@]}"; do
			echo $package
		done
		return 0
	fi

	echo "All packages are set and ready for the next stage"
	return 1
}

function stage2() {
	echo "Connecting to the source code repository..."
	sourcecode="https://github.com/roxsross/bootcamp-devops-2023/tree/clase2-linux-bash/app-295devops-travel"
	cd /var/www/html
	if [ -d "travelwebapp" ]; then
		cd travelwebapp
		git pull origin master
	else
		git clone $sourcecode travelwebapp
	fi
	
	echo "Configuring data layer..."
	mysql -e "
	CREATE DATABASE devopstravel;
	CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
	GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
	FLUSH PRIVILEGES;"
	mysql < database/devopstravel.sql

	echo "Updating Apache WebServer with full support of the Web Application..."
	sed -i '/<IfModule mod_dir.c>/i \
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm\n</IfModule>' /etc/apache2/mods-enabled/dir.conf
	systemctl restart apache2
	#it should be a call to health_check() to evaluate if Apache is running after this change

	echo "Updating DB credentials in the WebApp config..."
	sed -i 's/$dbPassword = "";\n/$dbPassword = "codepass";\n/g' config.php
	#please check if after this mod config.php has root permissions

	echo "Checking if the environment and the WebApp are ready..."
	enviro_status=$(php info.php)

	if [[ $enviro_status =~ "Loaded Configuration File" && $enviro_status=~ "PHP Version" ]]; then
		return 1
	else
		return 0
	fi
}

function stage3() {
	echo "Deploying to production..."
	systemctl reload apache2
	app_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/travelwebapp/index.php)

	if [ $app_status -eq 200 ]; then
		return 1
	else
		return 0
	fi
}

function stage4() {
	discord_key="https://discord.com/api/webhooks/1169002249939329156/7MOorDwzym-yBUs3gp0k5q7HyA42M5eYjfjpZgEwmAx1vVVcLgnlSh4TmtqZqCtbupov"
	payload=$(cat <<EOF
	{
		"Author": "Herbert Tamayo",
		"Commit ID": "b77863f",
		"Description": "Challenge 01 Web Application deploy using Bash Scripting",
		"Github Repo": "https://github.com/hftamayo/devopsrossrox",
		"Group" : "5",
		"Status" : "Online"
	}EOF)

	curl -X POST -H "Content-Type: application/json" -d "$payload" "$discord_key"
}
main() {
	stage0
	stage1
	hc_result=$(health_check)

	if [ $hc_result -eq 0]; then
		echo "the deploy of the infrastructure has failed, please notify to IT Support"
		exit 1
	fi
	
	stage2_result=$(stage2)
	if [ $stage2_result -eq 0]; then
		echo "The environment is not ready to run the application, please notify to IT Support"
		exit 1
	fi

	stage3_result=$(stage3)
	if [ $stage3_result -eq 0]; then
		echo "The application is not ready, please notify to IT Support"
		exit 1
	fi

	stage4
}
