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
		package_not_installed+=("libapache2-mod-php")
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

function stage2() {
	
	echo "Updating Apache WebServer with full support of the Web Application..."
	
	datalayer_flag=0
	
	#filepath: this is very important for redhat based distros
	filepath="/etc/apache2/mods-enabled/dir.conf"
	#I should check if the file exists
	
	#backup of the original file
	cp "$filepath" "$filepath.bk"
	
	#read the file
	dirfile=$(cat "$filepath")
	
	#adding index.php
	newdirfile=$(sed -r 's/DirectoryIndexs+\s+(\S+)/DirectoryIndex\s+\1/g' <<< "$dirfile")
	
	#writing changes
	echo "$newdirfile" > "$filepath"
        
        echo "Restarting web server..."
	systemctl restart apache2
	#it should be a call to health_check() to evaluate if Apache is running after this change
	sleep 3
	
	echo "Checking if the database layer is already set up"
	webappdb="devopstravel"
	
	mysql -u root -e "SHOW DATABASES LIKE '$webappdb';" | grep webappdb > /dev/null

	if [[ $? -eq 0 ]]; then
		echo "The database '$webappdb' exists, the data layer is ready"
		datalayer_flag="1"
	else
		echo "Configuring data layer access..."
		mysql -e "
		CREATE DATABASE devopstravel;
		CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
		GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
		FLUSH PRIVILEGES;"
	fi
	
	sleep 1

	echo "Connecting to the codebase..."
	sourcecode="https://github.com/roxsross/bootcamp-devops-2023.git"
	cd
	if [ -d "desafio01" ]; then
		echo "application exists, searching for updates..."
		sleep 1
		cd desafio01
		git pull origin master
	else
		git clone $sourcecode desafio01
		cd desafio01
	fi
	
	#moving to the source code

	git checkout clase2-linux-bash
	cd app-295devops-travel

	echo "Updating DB credentials in the WebApp config..."
	sed -i 's/$dbPassword = "";\n/$dbPassword = "codepass";\n/g' config.php
	#please check if after this mod config.php has root permissions
	
	if [[ $datalayer_flag -eq 0 ]]; then
		echo "Seeding data..."
		mysql < database/devopstravel.sql
	fi
	sleep 3	
	
	echo "Installing webApp into the Web Server sandbox..."
	cd ..
	cp -r app-295devops-travel/ /var/www/html/desafio01
	sleep 2

	echo "Checking if the environment and the WebApp are ready..."
	cd /var/www/html/desafio01
	enviro_status=$(php info.php)

	if [[ $enviro_status=~"Loaded Configuration File" && $enviro_status=~"PHP Version" ]]; then
		echo "The code base is installed, up and running"
	else
		echo "The environment is not ready, please contact to IT support"
		exit 1
	fi
}

function stage3() {
	systemctl reload apache2
	sleep 1
	app_status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/desafio01/index.php)

	if [ $app_status -eq 200 ]; then
		echo "The application is fully functional"
	else
		echo "Unfortunately the application is not ready to enter into production. Please notify to production"
		exit 1
	fi
}

function stage4() {
	discord_key="https://discord.com/api/webhooks/1169002249939329156/7MOorDwzym-yBUs3gp0k5q7HyA42M5eYjfjpZgEwmAx1vVVcLgnlSh4TmtqZqCtbupov"
	#	payload='{
	#		"content": "Challenge 01 Web Application deploy using Bash Scripting by hftamayo",
	#		"Author": "Herbert Tamayo",
	#		"Commit ID": "b77863f",
	#		"Description": "Challenge 01 Web Application deploy using Bash Scripting",
	#		"Github Repo": "https://github.com/hftamayo/devopsrossrox",
	#		"Group" : "5",
	#		"Status" : "Online"
	#	}'	
	
	cd
	cd desafio01
	fullpayload=(
	  "Challenge 01 Web Application deploy using Bash Scripting"
	  "CodeBase Information:"
	  "Github Repo: https://github.com/roxsross/bootcamp-devops-2023"
	  "Author: Author $(git log -1 --pretty=format:'%an')"
	  "Commit ID: $(git rev-parse --short HEAD)"
	  "Commit Message: $(git log -1 --pretty=format:'%an')"
	  "WebApp Status: Online"
	  "Automation Script Information:"
	  "Maintainer: Herbert Tamayo"
	  "Github Repo: https://github.com/hftamayo/devopsrossrox"
	  "Script details: Please refer to the README.md"

	)
	
	for payload in "${fullpayload[@]}"; do
	  curl -X POST -H "Content-Type: application/json" -d '{
	    "content": "'"$payload"'"
	  }' "$discord_key"
	done
}


main() {
	stage1
	health_check

	sleep 1
	#it is important to check if the app is running before running the stage2	
	echo "Installing code base..."
	stage2
	
	sleep 3

	echo "Deploying to production..."
	stage3
	
	sleep 1
	echo "Sending message to discord..."
	stage4
}

main
