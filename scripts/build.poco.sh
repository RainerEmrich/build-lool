#!/bin/bash
#
# Build poco.
#
# Copyright (C) 2017-2018 Rainer Emrich, <rainer@emrich-ebersheim.de>
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

build_poco () {

	if [ "${POCO_BUILD}" != "1" ] ; then
		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Build poco."
		echo "#"
		echo "#######################################################################################"
		echo

		if [ "${POCO_LAST}" != "" ] ; then
			LIST="cpspc cpspcd  f2cpsp f2cpspd"
			for BIN in ${LIST} ; do
				if [ -f ${POCO_PREFIX}/bin/${BIN} ] ; then sudo /bin/rm -f ${POCO_PREFIX}/bin/${BIN} ; fi
			done
			if [ -d ${POCO_PREFIX}/include/Poco ] ; then sudo /bin/rm -rf ${POCO_PREFIX}/include/Poco ; fi
			sudo find ${POCO_PREFIX}/lib -maxdepth 1 -name "libPoco*.so*" -exec /bin/rm -f {} \;
		fi

		cd ${BUILD_DIR}

		tar xvf ${SRC_DIR}/poco/poco-${POCO_VERSION}-all.tar.gz
		cd poco-${POCO_VERSION}-all

		./configure --prefix=${POCO_PREFIX} 2>&1 | tee ${LOG_DIR}/poco-${POCO_VERSION}-all.log

		make -j ${NUM_PROC} 2>&1 | tee -a ${LOG_DIR}/poco-${POCO_VERSION}-all.log
		if [ $? -eq 2 ] ; then
			echo
			echo "ERROR: see ${LOG_DIR}/poco-${POCO_VERSION}-all.log!"
			echo "Exiting..."
			echo
			exit
		fi

		sudo make install 2>&1 | tee -a ${LOG_DIR}/poco-${POCO_VERSION}-all.log
		sudo make install DESTDIR="${BUILD_DIR}/install" 2>&1 | tee -a ${LOG_DIR}/poco-${POCO_VERSION}-all.log

		sudo tar -C ${BUILD_DIR}/install${POCO_PREFIX}/ -cvJf ${PKG_DIR}/poco-${POCO_VERSION}.tar.xz .

		cd ${BUILD_DIR}
		sudo /bin/rm -rf poco-${POCO_VERSION}-all
		sudo /bin/rm -rf ${BUILD_DIR}/install

		cd ${START_DIR}

		echo "${POCO_VERSION}" >${STAMP_DIR}/poco_build
	fi

}
