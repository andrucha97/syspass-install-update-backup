#!/bin/bash


echo "This script will install sysPass"

read -r -p "Do you want to start? [y/n] " input
 
case $input in

 [yY][eE][sS]|[yY])

 echo "Installing ..."

 read -r -p "Please choose which Branch you want to use [heads/tags] " branch
 
 case $branch in

  heads)
  echo "*****"
  git ls-remote --heads https://github.com/nuxsmin/sysPass.git | cut -d "/" -f "3"
  echo "*****"
  ;;

  tags)
  echo "*****"
  git ls-remote --tags https://github.com/nuxsmin/sysPass.git | cut -d "/" -f "3"
  echo "*****"
  ;;

  *)
  echo "Invalid input..."
  exit 1
  ;;

 esac

 echo "Please choose which Version you want to install. Type in the Version to move on"
 read version

 COMMITID=$(git ls-remote https://github.com/nuxsmin/sysPass.git refs/$branch/$version|cut -c-40)

 echo "Thanks we have: $branch as Branch and: $version as Version registerd"
 echo "The Commit ID for this installation is $COMMITID"

 echo "Checking out sysPass repository with provided commit id ..."
  if [ ! -d "cd /tmp/sysPass" ]; then
	mkdir -p /tmp/sysPass
	cd /tmp/
	git clone https://github.com/nuxsmin/sysPass.git
  fi
 cd /tmp/sysPass
 git stash drop
 git stash
 git pull
 git reset --hard
 git checkout $COMMITID

 echo "*****"

 echo "Check number"
 echo $COMMITID|cut -c-8
 read -r -p "Are the numbers above identical?[y/n]" numcheck

 case $numcheck in

  [yY][eE][sS]|[yY])

  echo "Great now we can go on..."

  read -r -p "Can we install to /var/www/html/ ? [y/n] " path

  case $path in

   [yY][eE][sS]|[yY])
   path=/var/www/html
   echo "Ok the installation will start right now and can be found in $path ..."

sudo apt install apache2 mysql-server php7.0 php7.0-ldap php7.0-xml php7.0-curl php7.0-json php7.0-gd php7.0-pdo php7.0-mbstring php7.0-cli php7.0-mysqlnd wget phpmyadmin php-mbstring php-gettext php-xdebug

   cd /tmp/sysPass
   rsync -a ./ "$path"/

   echo "Getting Composer ..."
   EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
   php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
   ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

   if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
   then
	>&2 echo 'ERROR: Invalid installer signature'
	rm composer-setup.php
	exit 1
   fi

   php composer-setup.php
   rm composer-setup.php

   echo "Installing Composer modules ..."
   php composer.phar install
   php composer.phar update

   chown -R www-data:www-data "$path"/
   chmod -R 750 "$path"/
   chmod 750 "$path"/app/config/ "$path"/app/backup/
   chmod 761 "$path"/app/cache/
   mv "$path"/index.html ..

   ;;

   [nN][oO]|[nN])
   echo "Where can we install?"
   read path;
   echo "You coosed following path: $path"

sudo apt install apache2 mysql-server php7.0 php7.0-ldap php7.0-xml php7.0-curl php7.0-json php7.0-gd php7.0-pdo php7.0-mbstring php7.0-cli php7.0-mysqlnd wget phpmyadmin php-mbstring php-gettext php-xdebug

   cd /tmp/sysPass
   rsync -a ./ "$path"/

   echo "Getting Composer ..."
   EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
   php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
   ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

   if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
   then
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        exit 1
   fi

   php composer-setup.php
   rm composer-setup.php

   echo "Installing Composer modules ..."
   php composer.phar install
   php composer.phar update

   chown -R www-data:www-data "$path"/
   chmod -R 750 "$path"/
   chmod 750 "$path"/app/config/ "$path"/app/backup/
   chmod 761 "$path"/app/cache/
   mv "$path"/index.html ..

   ;;

   *)
   echo "Invalid input..."
   exit 1
   ;;

  esac


  ;;

  [nN][oO]|[nN])

  echo "We canceled the installation becouse the numbers are not identical. Please restart or contact the developer"
  exit 1
  ;;

  *)

  echo "Invalid input..."
  exit 1
  ;;

 esac





 ;;

 [nN][oO]|[nN])

 echo "We canceled the installation, becouse you didn't want to install"
 exit 1
 ;;

 *)

 echo "Invalid input..."
 exit 1
 ;;

esac
