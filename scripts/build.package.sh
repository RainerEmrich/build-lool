#!/bin/bash
#
# Build an installable package including all necessary components as tar archive.
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

build_package () {

	if [ "${PACKAGE_BUILD}" != "1" ] ; then
		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Build an installable package including all necessary components as tar archive."
		echo "#"
		echo "#######################################################################################"
		echo

		cd ${START_DIR}

		LOOL_DISTRO="$(ls -1 ${LOOL_PREFIX}/etc)"
		LOC_DISTRO="$(basename $(find ${LOOL_PREFIX}/lib -maxdepth 1 -type d -name "*office"))"
		sudo mkdir -p ${LOOL_PREFIX}/var/www

		case $LOOL_VERSION in
		1.* | \
		2.0* | \
		libreoffice-5.3.0* | \
		libreoffice-5.3.1* | \
		libreoffice-5.3.2* | \
		libreoffice-5.3.3* | \
		libreoffice-5.3.4*)
			sudo tar -C ${LOOL_PREFIX}/var/www/ -xvf ${PKG_DIR}/loleaflet-${LOOL_VERSION}.tar.gz
			sudo /bin/mv ${LOOL_PREFIX}/var/www/loleaflet-* ${LOOL_PREFIX}/var/www/loleaflet
			sudo /bin/cp ${LOOL_PREFIX}/share/${LOOL_DISTRO}/* ${LOOL_PREFIX}/var/www/
			;;
		*)
			sudo /bin/mv ${LOOL_PREFIX}/share/${LOOL_DISTRO}/* ${LOOL_PREFIX}/var/www/
			;;
		esac

		sudo touch ${LOOL_PREFIX}/var/www/loleaflet/dist/branding.css
		sudo touch ${LOOL_PREFIX}/var/www/loleaflet/dist/branding.js
		sudo /bin/cp -a ${LOOL_PREFIX}/var/www/loleaflet/dist/l10n ${LOOL_PREFIX}/var/www/loleaflet/dist/admin/
		sudo chown -R root:root ${LOOL_PREFIX}/var/www/loleaflet
		sudo chmod -R g-w,o-w ${LOOL_PREFIX}/var/www/loleaflet

		sudo tar -C ${LOOL_PREFIX}/ -cvJf ${PKG_DIR}/${PACKAGE_NAME}.tar.xz .

		echo "/lib/x86_64-linux-gnu" >grep-patterns.txt
		echo "/usr/lib/x86_64-linux-gnu" >>grep-patterns.txt

		(ldd ${LOOL_PREFIX}/bin/lool* ; ldd ${LOOL_PREFIX}/lib/${LOC_DISTRO}/program/*) | grep --file=grep-patterns.txt | cut -d " " -s -f 3 | sort -u >depend-libraries.txt

		for lib in $(cat depend-libraries.txt) ; do
			echo $(dpkg -S $lib) >>packages.txt
		done

		cut packages.txt -d ":" -s -f 1 | sort -u >required-packages.txt
		echo "libcap2-bin" >>required-packages.txt
		echo "libcunit1" >>required-packages.txt
		echo "libiodbc2" >>required-packages.txt
		echo "python-polib" >>required-packages.txt
		echo "python3-polib" >>required-packages.txt

		/bin/mv required-packages.txt ${PKG_DIR}/${PACKAGE_NAME}-required-packages.txt

		/bin/rm grep-patterns.txt
		/bin/rm depend-libraries.txt
		/bin/rm packages.txt

		echo "${PACKAGE_NAME}" >${STAMP_DIR}/package_build

		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Building lool package finished."
		echo "#"
		echo "#######################################################################################"
		echo
	fi

}
