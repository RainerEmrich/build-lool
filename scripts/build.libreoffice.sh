#!/bin/bash
#
# Build libreoffice core.
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

build_libreoffice () {

	if [ "${LIBREOFFICE_BUILD}" != "1" ] ; then
		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Build libreoffice."
		echo "#"
		echo "#######################################################################################"
		echo

		if [ "${LOC_LAST}" != "" ] ; then
			sudo /bin/rm -rf ${LOOL_PREFIX}/lib/*office*
			sudo /bin/rm -rf ${BUILD_DIR}/core-*
		fi

		cd ${BUILD_DIR}

		tar xvf ${SRC_DIR}/${LOC_VERSION}.tar.gz
		cd core-${LOC_VERSION}

		echo "lo_sources_ver=${LOC_VERSION}" >sources.ver

		./autogen.sh --prefix=${LOOL_PREFIX} --enable-release-build --without-help --without-myspell-dicts --with-parallelism | tee ${LOG_DIR}/core-${LOC_VERSION}.log 2>&1

		make fetch
		if [ $? -eq 2 ] ; then
			echo
			echo "ERROR: see ${LOG_DIR}/core-${LOC_VERSION}.log!"
			echo "Exiting..."
			echo
			exit
		fi

		make | tee -a ${LOG_DIR}/core-${LOC_VERSION}.log 2>&1
		if [ $? -eq 2 ] ; then
			echo
			echo "ERROR: see ${LOG_DIR}/core-${LOC_VERSION}.log!"
			echo "Exiting..."
			echo
			exit
		fi

		make check | tee -a ${LOG_DIR}/core-${LOC_VERSION}.log 2>&1
		if [ $? -eq 2 ] ; then
			echo
			echo "ERROR: see ${LOG_DIR}/core-${LOC_VERSION}.log!"
			echo "Exiting..."
			echo
			exit
		fi

		sudo make install | tee -a ${LOG_DIR}/core-${LOC_VERSION}.log 2>&1
		sudo make install DESTDIR="${BUILD_DIR}/install" | tee -a ${LOG_DIR}/core-${LOC_VERSION}.log 2>&1

		sudo tar -C ${BUILD_DIR}/install${LOOL_PREFIX}/ -cvJf ${PKG_DIR}/core-${LOC_VERSION}.tar.xz .

		sudo /bin/rm -rf ${BUILD_DIR}/install

		cd ${START_DIR}

		echo "${LOC_VERSION}" >${STAMP_DIR}/libreoffice_build

		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Building libreoffice finished."
		echo "#"
		echo "#######################################################################################"
		echo
	fi

}
