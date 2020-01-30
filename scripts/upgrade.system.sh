#!/bin/bash
#
# Update the system and install the required packages.
#
# Copyright (C) 2017-2019 Rainer Emrich, <rainer@emrich-ebersheim.de>
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

		sudo apt-get install libiodbc2 libiodbc2-dev uuid-runtime gnupg2 -y

		sudo apt-get install libcunit1 libcunit1-dev libcap-dev python-polib python3-polib -y

		sudo apt-get install python-lxml python3-lxml -y

		sudo apt-get install nasm -y

		sudo apt-get install libpam0g-dev -y

		case ${DIST_ID} in
		Debian)
			case ${DIST_RELEASE} in
			8.* | \
			9.*)
				sudo apt-get install seccomp libseccomp-dev libssl-dev -y

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
		Ubuntu)
			case ${DIST_RELEASE} in
			16.04)
				sudo add-apt-repository ppa:ubuntu-toolchain-r/test
				sudo apt-get update
				sudo apt-get dist-upgrade
				sudo apt-get install gcc-7 g++-7 gcc-7-locales gcc-7-doc libstdc++-7-doc
				sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 100 --slave /usr/bin/g++ g++ /usr/bin/g++-5
				sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 50 --slave /usr/bin/g++ g++ /usr/bin/g++-7
				sudo update-alternatives --config gcc
				sudo apt-get install npm -y
				sudo npm cache clean
				sudo npm install -g n
				sudo n stable
				;;
			18.04)
				sudo apt-get install libzmf-dev libstaroffice-dev libglew-dev libserf-dev librdf0-dev -y
				sudo apt-get install openjdk-8-jdk -y
				sudo apt-get remove openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre openjdk-11-jre-headless -y
				sudo apt-get install npm -y
				sudo npm install -g n
				sudo n stable
				;;
			esac
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
