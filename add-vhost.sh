#!/bin/bash

hostsFile="/etc/hosts"
vhostsFile="/opt/local/apache2/conf/extra/httpd-vhosts.conf"
helpText="\nUsage: sudo sh add-vhosts.sh -u [site.url] -d [site-directory in ~/Sites]\n"

# user input passed as options?
siteUrl=''
directory=''

while getopts ":u:d:h:" o; do
	case "${o}" in
		u)
			siteUrl=${OPTARG}
			;;
		d)
			directory=${OPTARG}
			;;
		*)
			echo ${helpText}
			exit 1

	esac
done

# validate the passed in parameter
if [[ ${siteUrl} = ''  || ${directory} = '' ]]; then
	echo "\n[Error] Missing parameter"
	echo ${helpText}
	exit 1
fi

## check if we are running this with sudo
if [ "$(whoami)" != "root" ]; then
	echo "[Error] Run as sudo"
	exit 1
fi

cat <<EOL >> ${vhostsFile}

<VirtualHost *:80>
   ServerName ${siteUrl}
   DocumentRoot /Users/Paedda/Sites/${directory}
  <IfModule mod_rewrite.c>
       RewriteEngine On
       RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-d
       RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
       RewriteRule ^ /index.php [L,QSA]
  </IfModule>
  <Directory "/Users/Paedda/Sites/${directory}">
      AllowOverride All
  </Directory>
</VirtualHost>
EOL

echo "Updated httpd-vhosts.conf"

# update hosts file
echo 127.0.0.1    ${siteUrl} >> ${hostsFile}
echo "Updated /etc/hosts"
#
## restart apache
echo "Restarting Apache..."
echo `/opt/local/apache2/bin/apachectl restart`

echo "Done - check site at http://${siteUrl}"
exit 0