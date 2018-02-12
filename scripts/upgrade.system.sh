#!/bin/bash
#
# Update the system and install the required packages.
#
# Copyright 2017 Rainer Emrich, <rainer@emrich-ebersheim.de>
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file LICENSE.  If not see
# <http://www.gnu.org/licenses/>.
#

upgrade_system () {

	if [ "${UPGRADE_DONE}" != "1" ] ; then
		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Update the system and install the required packages, then reboot."
		echo "#"
		echo "#######################################################################################"
		echo

		sudo apt-get update -y
		sudo apt-get upgrade -y
		sudo apt-get dist-upgrade -y

		sudo apt-get install apache2 -y

		sudo apt-get install apt-transport-https git libtool libegl1-mesa-dev libkrb5-dev graphviz -y

		sudo apt-get build-dep libreoffice -y

		sudo apt-get install libiodbc2 libiodbc2-dev -y

		sudo apt-get install libcunit1 libcunit1-dev libcap-dev python-polib python3-polib -y

		sudo apt-get install python-lxml python3-lxml -y

		sudo apt-get install nasm -y

		sudo apt-get install libpam0g-dev -y

		case ${DIST_ID} in
		Debian)
			case ${DIST_RELEASE} in
			8.*)
				sudo apt-get install seccomp libseccomp-dev -y

				wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
				echo "deb https://deb.nodesource.com/node_6.x ${DIST_CODENAME} main" | sudo tee /etc/apt/sources.list.d/nodesource.list
				echo "deb-src https://deb.nodesource.com/node_6.x ${DIST_CODENAME} main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
				sudo apt-get update
				sudo apt-get install nodejs -y
				;;
			*)
				sudo apt-get install npm nodejs-legacy -y
				;;
			esac
			;;
		*)
			sudo apt-get install npm nodejs-legacy -y
			;;
		esac

		sudo npm install -g jake

		sudo apt-get autoremove --purge -y

		touch ${STAMP_DIR}/upgrade_done

		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Updating system and installing required packages finished, reboot now!"
		echo "#"
		echo "#######################################################################################"
		echo

		sudo reboot
	fi

}
