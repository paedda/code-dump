#!/bin/bash

bashProfile="/Users/Paedda/.bash_profile"
helpText="\nUsage: sh add-alias.sh -a [alias name] -c [command of the alias]\n"


# user input passed as options?
alias=''
command=''

while getopts ":a:c:h:" o; do
	case "${o}" in
		a)
			alias=${OPTARG}
			;;
		c)
			command=${OPTARG}
			;;
		*)
			echo ${helpText}
			exit 1

	esac
done

# validate the passed in parameter
if [[ ${alias} = ''  || ${command} = '' ]]; then
	echo "\n[Error] Missing parameter"
	echo ${helpText}
	exit 1
fi

# update hosts file
echo "alias" ${alias}"='"${command}"'" >> ${bashProfile}
echo "Updated .bash_profile"

echo "Done"
exit 0