#!/bin/bash
#
# Build an installable package including all neccessary components as tar archive.
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
		echo "# Build an installable package including all neccessary components as tar archive."
		echo "#"
		echo "#######################################################################################"
		echo

		cd ${START_DIR}

		sudo mkdir -p ${LOOL_PREFIX}/var/www

		sudo tar -C ${LOOL_PREFIX}/var/www/ -xvf ${PKG_DIR}/loleaflet-${LOOL_VERSION}.tar.gz
		sudo /bin/mv ${LOOL_PREFIX}/var/www/loleaflet-* ${LOOL_PREFIX}/var/www/loleaflet
		sudo touch ${LOOL_PREFIX}/var/www/loleaflet/dist/branding.css
		sudo touch ${LOOL_PREFIX}/var/www/loleaflet/dist/branding.js
		sudo /bin/cp -a ${LOOL_PREFIX}/var/www/loleaflet/dist/l10n ${LOOL_PREFIX}/var/www/loleaflet/dist/admin/
		sudo chown -R root:root ${LOOL_PREFIX}/var/www/loleaflet
		sudo chmod -R g-w,o-w ${LOOL_PREFIX}/var/www/loleaflet
		sudo tar -C ${LOOL_PREFIX}/ -cvJf ${PKG_DIR}/${PACKAGE_NAME}.tar.xz .

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
