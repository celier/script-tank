#!/bin/bash
# This script aims at maintaining backups for all files/directories listed below
# Tested for Debian Jessie only
# Kind of a very very very (very) basic versionning system
# Use for backup on my test files. Run from /path/to/directory/

# Files/directories being backed are
# file.jsp
# file2.jsp
# file3.jsp
# directory

# Checks that the correct user is executing the script; returns error and stops if not
if [ $(whoami) != 'user' ]; then
        echo "Must be user to run $0"
        exit 1;
fi

# Contains all files the script will copy to backup directory
files_array=(file.jsp file2.jsp file3.jsp directory)

# Gets the date for backup directory name
date_value=$(date '+%Y-%m-%d')

# Path to backup directory
path='/home/'$USER'backup'

# Current working directory
current_path=$(pwd)

#tests for existing backup directory.
if [ -d "$path/$date_value.tar.gz" ] ; then
# If backup direcotry exist, do
	echo "A $date_value.tar;gz directory already exist."
	
	read -p "Do you wish to update directory ? (Y/N)" -n 1 -r
	
	echo # Moves to new line; for user experience purpose only
	
	case "$REPLY" in
# Case when user answered "Y" or "y" (Yes), do
	" [[ $REPLY =~ ^[Yy]$ ]] " )
	
		# Extract archive
		tar xf "$path/$date_value.tar.gz"
	
		# Synchronise directories
		rsync --update -raz --progress --include="$current_path${files_array[@]}" "$path/$date_value" --exclude="*"
	;;
# Case when user andwered anything else, do
	" [[ $REPLY =~ ^[*]$ ]] " )
		echo "Script didn't make any change and stopped itself."
		exist 1;
	esac
	
# Else if backup direcotry doesn't existr yet, do
else
# Make a directory using the date
mkdir "$path/$date_value"

# Loops over the whole array and copy files/directories recursively to given directory with current rights
for i in ${files_array[@]}; do
		cp -ar ${i} /home/robin/backup/by_date/"$date_value"/
done

# Goes to backup directory
cd "$path"

# Compress backup directory into tarball AND(=&&) removes it if successfull
tar cf "$date_value.tar.gz" "$date_value" AND rm -Rf "$date_value"

exit 0;
