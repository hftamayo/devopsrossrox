#!/bin/bash


BRED='\033[1;31m'       # Bold Red
BGREEN='\033[1;32m'     # Bold Green
BYELLOW='\033[1;33m'    # Bold Yellow
UCYAN='\033[4;36m'      # Underline Cyan
LGREY='\033[0;90m'      # Dark Gray
TR='\033[0m'            # Text Reset

#Global Variables
WEB_URL="localhost"

#stage 0: instructions
function stage1() {
    echo -e "${UCYAN}STAGE1${TR}"
	echo "==================================================================================="
	echo "Monolith LAMP application deployment automation script"
	echo "This version is for Debian based distro"
	echo "==================================================================================="

	#check if the current user is root or uses sudo command
	if [ "$(id -nu)" != "root" ]; then
		echo -e "${BRED}Your account does not have enough administrative privileges${TR}"
		exit 1
	fi
	
	echo -e "${BYELLOW}Please wait while checking status of the needed packages${TR}"
	
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
		
	if hash mariadb 2>/dev/null; then
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
		echo -e "${BYELLOW}Number of installed packages : ${#package_installed[@]}${TR}"
		for package in "${package_installed[@]}"; do
			echo "$package"
		done
	else
		echo -e "${BGREEN}It requires a complete installation${TR}"
	fi

	if [ ${#package_not_installed[@]} -gt 0 ]; then
		echo -e "${BYELLOW}Number of packages not installed : ${#package_not_installed[@]}${TR}"
		echo -e "${BYELLOW}The next packages will be installed: ${TR}"
		for package in "${package_not_installed[@]}"; do
			echo "$package"
		done
	else
		echo -e "${BGREEN}All packages are installed${TR}"
	fi

	if [ ${#package_not_installed[@]} -gt 0 ]; then
		echo -e "${BYELLOW}Updating system${TR}"
		apt update

		for package in "${package_not_installed[@]}"; do
			apt install $package -y
		done
		echo -e "${BGREEN}Package installation done${TR}"
	fi
	sleep 1
}

function health_check() {
    echo -e "${UCYAN}HEALTH CHECK${TR}"
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

	echo -e "${BGREEN}Packages up and running: ${TR}"
	for package in "${packages_up[@]}"; do
		echo "$package"
	done	


	if [ ${#packages_down[@]} -gt 0 ]; then
		echo -e "${BGREEN}packages with error status:${TR}"
		for package in "${packages_down[@]}"; do
			echo "$package"
		done
		exit 1
	fi

	echo -e "${BGREEN}All packages are set and ready for the next stage${TR}"
}

function stage2() {
	echo -e "${UCYAN}STAGE2${TR}"
	
	datalayer_flag=0
    WEBAPPDB="devopstravel"
	D_PROJECT="desafio01"
    SOURCODE="https://github.com/roxsross/bootcamp-devops-2023.git"
    APP_REPO="app-295devops-travel"
    GIT_BRANCH="clase2-linux-bash"

	#filepath: this is very important for redhat based distros
	filepath="/etc/apache2/mods-enabled/dir.conf"
	#I should check if the file exists
	
	#backup of the original file
	cp "$filepath" "$filepath.bk"
	
	#read the file
	dirfile=$(cat "$filepath")
	
	#adding index.php
	newdirfile=$(sed -r 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' <<< "$dirfile")
	
	#writing changes
	echo "$newdirfile" > "$filepath"
        echo -e "${BYELLOW}Restarting web server...${TR}"
	systemctl restart apache2
	#it should be a call to health_check() to evaluate if Apache is running after this change
	sleep 3
	
	echo "Checking if the database layer is already set up"
	
	mysql -u root -e "SHOW DATABASES LIKE '$WEBAPPDB';" | grep "$WEBAPPDB" > /dev/null

	if [[ $? -eq 0 ]]; then
		echo -e "${BGREEN}The database '$WEBAPPDB' exists, the data layer is ready${TR}"
		datalayer_flag="1"
	else
		echo -e "${BYELLOW}Configuring data layer access...${TR}"
		mysql < ./script-config-db.sql
	fi
	
	sleep 1

	echo -e "${BYELLOW}Connecting to the codebase...${TR}"

	if [ -d $D_PROJECT ]; then
		echo -e "${BGREEN}Application exists, searching for updates...${TR}"
		sleep 1
		cd $D_PROJECT
		git pull origin $GIT_BRANCH
	else
		echo -e "${BYELLOW}Clone repository...${TR}"
		git clone $SOURCODE $D_PROJECT
		cd $D_PROJECT
	fi
	
	#moving to the source code

	git checkout $GIT_BRANCH

	echo -e "${BYELLOW}Updating DB credentials in the WebApp config...${TR}"
	sed -i 's/$dbPassword = ""/$dbPassword = "codepass"/g' $APP_REPO/config.php
	#please check if after this mod config.php has root permissions
	
	if [[ $datalayer_flag -eq 0 ]]; then
		echo -e "${BYELLOW}Seeding data...${TR}"
		mysql < $APP_REPO/database/devopstravel.sql
	fi
	sleep 3	
	
	echo -e "${BYELLOW}Installing webApp into the Web Server sandbox...${TR}"
	cp -r $APP_REPO/ /var/www/html/$D_PROJECT
	sleep 2

    cd ..

	echo -e "${BYELLOW}Checking if the environment and the WebApp are ready...${TR}"
	enviro_status=$(php /var/www/html/$D_PROJECT/info.php)

	if [[ $enviro_status=~"Loaded Configuration File" && $enviro_status=~"PHP Version" ]]; then
		echo -e "${BGREEN}The code base is installed, up and running${TR}"
	else
		echo -e "${BYELLOW}The environment is not ready, please contact to IT support${TR}"
		exit 1
	fi
}

function stage3() {
    echo -e "${UCYAN}STAGE3${TR}"
	systemctl reload apache2
	sleep 1
	app_status=$(curl -s -o /dev/null -w "%{http_code}" http://$WEB_URL/$D_PROJECT/index.php)

	if [ $app_status -eq 200 ]; then
		echo -e "${BGREEN}The application is fully functional${TR}"
        return 1
	else
		echo -e "${BYELLOW}Unfortunately the application is not ready to enter into production. Please notify to production${TR}"
		return 0
	fi
}

function stage4() {
    echo -e "${UCYAN}STAGE4${TR}"
	discord_key="https://discord.com/api/webhooks/1169002249939329156/7MOorDwzym-yBUs3gp0k5q7HyA42M5eYjfjpZgEwmAx1vVVcLgnlSh4TmtqZqCtbupov"
    status_app=$1

    REPO_NAME=$(basename $(git rev-parse --show-toplevel))
    REPO_URL=$(git remote get-url origin)

    DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
    COMMIT="Commit: $(git rev-parse --short HEAD)"
    AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
    DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"
    MAINTAINER="Maintainer: GROUP_5"
    if [ $status_app -eq 1 ]; then
        DEPLOYMENT_INFO="Challenge 01 Web Application deploy using Bash Scripting \nPlease refer to the README.md"
    else
        DEPLOYMENT_INFO="La página web $WEB_URL no está en línea."
    fi

    MESSAGE="$DEPLOYMENT_INFO\n$DEPLOYMENT_INFO2\n$COMMIT\n$AUTHOR\n$DESCRIPTION\n$REPO_URL\n$MAINTAINER"
    
    curl -X POST -H "Content-Type: application/json" \
     -d '{
       "content": "'"${MESSAGE}"'"
     }' "$discord_key"
}


main() {
	stage1
	health_check

	sleep 1
	#it is important to check if the app is running before running the stage2	
	echo -e "${LGREY}Installing code base...${TR}"
	stage2
	
	sleep 3

	echo -e "${LGREY}Deploying to production...${TR}"

	stage3
    stage3_result=$?

	sleep 1

	echo -e "${LGREY}Sending message to discord...${TR}"
	stage4 $stage3_result
}

main
