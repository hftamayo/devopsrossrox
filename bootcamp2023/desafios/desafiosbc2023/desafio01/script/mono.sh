#!/bin/bash

#stage 0: instructions
function stage0() {
	echo "==================================================================================="
	echo "Monolith LAMP application deployment automation script"
	echo "This version is for Debian based distro"
	echo "please run the script like this: monolamp <db_admin_password> <user_app_password>"
	echo "do not forget you need to have admin creds to run this"
	echo "==================================================================================="

	#check if the current user is root or uses sudo command
	if [ "$(whoami)" != "root" ] && [ "$(groups | grep -c sudo)" -eq 0 ]; then
		echo "This script requires admin privileges for its execution"
		exit 1
	fi
	
	# check if the user belongs to the sudoers
	user_groups=$(groups "$USER")

	# Check if the "sudo" group is in the user's group memberships
	if [[ ! "$user_groups" =~ "sudo" ]]; then
	  echo "You don't have enough administrative privileges to run this command"
	  exit 1
	fi	
	
	echo "you're good to go"

}


main() {
	stage0
}

main
