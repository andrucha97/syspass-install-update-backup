#!/bin/bash
# author andrucha97
# link https://github.com/andrucha97/syspass-install-update-backup
# copyright 2019, Andreas Hein info@webdesign-hein.de
#
# This update script requires the update script of vmario89
# You can get it here (the script will download it selve if not found):
# https://github.com/vmario89/sysPass-update
#
# Issues sould only reported as issue in github at:
# https://github.com/andrucha97/syspass-install-update-backup/issues

# syspass-install-update-backup is free script: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# syspass-install-update-backup is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
#  along with sysPass.  If not, see <http://www.gnu.org/licenses/>.

echo "*****"
echo "This script will update sysPass"

read -r -p "Do you want to start? [y/n] " start

case $start in
	[yY][eE][sS]|[yY])

	read -r -p "Do you want to choos the version yourselfe? (expertmode) [y/n] " expertmode

	case $expertmode in

		[yY][eE][sS]|[yY])

		echo "*****"
		echo "Important:"
		echo "heads are main Updates for example Version 3.0 or 3.1 if you want to have a stable Version we recomend to use heads. If you want to get the latest changes which are not released yet you can use tags (you can see the changes under following website: https://github.com/nuxsmin/sysPass/tags)"
		echo "*****"

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

			echo "Thanks we have: $branch as Branch and: $version as Version registerd"

			## Check if path is correct

			path=/var/www/html

                        if [ ! -d $path ]; then

                                echo "Tell me where sysPass is installed (no / at the end)"
                                read path
                        fi

                        if [ ! -f $path/lib/SP/Services/Install/Installer.php ]; then

                                echo "Could not find an installed sysPass. Try again (no / at the end):"
                                read path
                        fi

			if [ ! -f $path/lib/SP/Services/Install/Installer.php ]; then

				echo "Could not find an installed sysPass."
				echo "Cancel update..."
				exit 1
			fi

			## Check if new version is availible

			if [ -f $path/lib/SP/Services/Install/Installer.php  ]; then

				installedversion=$(grep -rwn $path/lib/SP/Services/Install/Installer.php -e 'const BUILD =' | cut -d " " -f "8" | cut -d ";" -f "1")
				selectedversion=$(curl -s https://raw.githubusercontent.com/nuxsmin/sysPass/$version/lib/SP/Services/Install/Installer.php | grep -P 'const BUILD =' | cut -d " " -f "8" | cut -d ";" -f "1")

				if [ $installedversion -ge $selectedversion ]; then

					echo "You already have the newest version"
					echo "Currently installed Version is:" $installedversion
					echo "Currently availible Version is:" $selectedversion
					exit 1

				else

					echo "You have an older version installed."
					sleep 3

				fi

			fi

			##Checking if update.sh exists

			script=/opt/sysPass-update/update.sh

			if [ ! -f $script ]; then

				echo "*****"
				echo "Could not find update script."
				echo "Downloading update script..."
				echo "*****"
				cd /opt
				git clone https://github.com/vmario89/sysPass-update.git
				chmod +x /opt/test/sysPass-update/update.sh

			fi

			if [ ! -f $script ]; then

				echo "Could not download and find the needet "update.sh" script. Tell me where the update script is located (You can download under following link https://github.com/vmario89/sysPass-update)"
				read script

			fi

			COMMITID=$(git ls-remote https://github.com/nuxsmin/sysPass.git refs/$branch/$version|cut -c-40)
			echo "The Commit ID for this installation is $COMMITID"
			sleep 5
			user=$(stat --format "%U" $path)
			echo "Installing..."
			$script -ci=$COMMITID -su=$user -p=$path


			logopath=/opt/syspass-install-update-backup/images

			if [ -d $logopath ]; then

				if [ -f $logopath/logo_icon.png ] && [ -f $logopath/logo_full_nobg_outline.png ] && [ -f $logopath/logo_full_nobg_outline_color.png ]; then

					mv $path/public/images $path/public/images-old
					cp -ra $logopath $path/public/
					chown -R $user:$user $path/public
					chmod -R 750 $path/public/images
					echo "Successfully copied your own logo"

				fi

			fi

		;;

		## Completly automatic update (you cannot choose the branch or tag
		[nN][oO]|[nN])

			## Check if path is correct

			path=/var/www/html

                        if [ ! -d $path ]; then

                                echo "Tell me where sysPass is installed (no / at the end)"
                                read path
                        fi

                        if [ ! -f $path/lib/SP/Services/Install/Installer.php ]; then

                                echo "Could not find an installed sysPass. Try again (no / at the end):"
                                read path
                        fi

			if [ ! -f $path/lib/SP/Services/Install/Installer.php ]; then

				echo "Could not find an installed sysPass."
				echo "Cancel update..."
				exit 1
			fi


			## Check if new version is availible

			if [ -f $path/lib/SP/Services/Install/Installer.php  ]; then

				installedversion=$(grep -rwn $path/lib/SP/Services/Install/Installer.php -e 'const BUILD =' | cut -d " " -f "8" | cut -d ";" -f "1")
				selectedversion=$(curl -s https://raw.githubusercontent.com/nuxsmin/sysPass/$version/lib/SP/Services/Install/Installer.php | grep -P 'const BUILD =' | cut -d " " -f "8" | cut -d ";" -f "1")

				if [ $installedversion -ge $selectedversion ]; then

					echo "You already have the newest version"
					echo "Currently installed Version is:" $installedversion
					echo "Currently availible Version is:" $selectedversion
					exit 1

				else

					echo "You have an older version installed. Updating starting..."
					sleep 3

				fi

			fi

			##Checking if update.sh exists

			script=/opt/sysPass-update/update.sh


			if [ ! -f $script ]; then

				echo "*****"
				echo "Could not find update script."
				echo "Downloading update script..."
				echo "*****"
				cd /opt
				git clone https://github.com/vmario89/sysPass-update.git
				chmod +x /opt/test/sysPass-update/update.sh

			fi


			if [ ! -f $script ]; then

				echo "Could not download and find the needet "update.sh" script. Tell me where the update script is located (You can download under following link https://github.com/vmario89/sysPass-update)"
				read script

			fi

			COMMITID=$(git ls-remote https://github.com/nuxsmin/sysPass.git refs/heads/master|cut -c-40)
			user=$(stat --format "%U" $path)
			echo "Installing..."
			sleep 5
			$script -ci=$COMMITID -su=$user -p=$path

			logopath=/opt/syspass-install-update-backup/images

			if [ -d $logopath ]; then

				if [ -f $logopath/logo_icon.png ] && [ -f $logopath/logo_full_nobg_outline.png ] && [ -f $logopath/logo_full_nobg_outline_color.png ]; then

					mv $path/public/images $path/public/images-old
					cp -ra $logopath $path/public/
					chown -R $user:$user $path/public
					chmod -R 750 $path/public/images
					echo "Successfully copied your own logo"

				fi

			fi

		;;

		*)

		echo "Invalid input..."
		exit 1

		;;

	esac

	;;


	[nN][oO]|[nN])

	echo "Cancel update..."
	exit 1

	;;

	*)

	echo "Invalid input..."
	exit 1

	;;

esac
