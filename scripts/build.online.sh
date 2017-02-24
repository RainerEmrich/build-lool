#!/bin/bash
#
# Build online.
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

build_online () {

	if [ "${ONLINE_BUILD}" != "1" ] ; then
		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Build online."
		echo "#"
		echo "#######################################################################################"
		echo

		LIST="loolforkit loolmap loolmount loolstress looltool loolwsd loolwsd-systemplate-setup"
		for BIN in ${LIST} ; do
			if [ -f ${LOOL_PREFIX}/bin/${BIN} ] ; then sudo /bin/rm -rf ${LOOL_PREFIX}/bin/${BIN} ; fi
		done
		if [ -d ${LOOL_PREFIX}/etc ] ; then sudo /bin/rm -rf ${LOOL_PREFIX}/etc ; fi
		if [ -d ${LOOL_PREFIX}/share/loolwsd ] ; then sudo /bin/rm -rf ${LOOL_PREFIX}/share/loolwsd ; fi

		cd ${BUILD_DIR}

		tar xvf ${SRC_DIR}/${LOOL_VERSION}.tar.gz

		cd online-${LOOL_VERSION}

		DISTRO=$(ls -1 ${LOOL_PREFIX}/lib/ | grep office)

		./autogen.sh | tee ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1

		./configure --prefix=${LOOL_PREFIX} --with-poco-includes=${POCO_PREFIX}/include --with-poco-libs=${POCO_PREFIX}/lib --with-lokit-path=../core-${LOC_VERSION}/include \
				--with-lo-path=${LOOL_PREFIX}/lib/${DISTRO} --with-logfile=${LOOL_PREFIX}/var/log/loolwsd/loolwsd.log | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1

		make -j 4 | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1
		if [ $? -eq 2 ] ; then
			echo
			echo "ERROR: see ${LOG_DIR}/online-${LOOL_VERSION}.log!"
			echo "Exiting..."
			echo
			exit
		fi

		sudo make install | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1
		sudo make install DESTDIR="${BUILD_DIR}/install" | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1

		sudo tar -C ${BUILD_DIR}/install/opt/ -cvJf ${PKG_DIR}/loolwsd-${LOOL_VERSION}.tar.xz .

		sudo /bin/rm -rf ${BUILD_DIR}/install

		cd loleaflet

		sudo make dist | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1
		if [ $? -eq 2 ] ; then
			echo
			echo "ERROR: see ${LOG_DIR}/online-${LOOL_VERSION}.log!"
			echo "Exiting..."
			echo
			exit
		fi

		sudo /bin/mv loleaflet-*.tar.gz ${PKG_DIR}/loleaflet-${LOOL_VERSION}.tar.gz

		cd ${BUILD_DIR}

		sudo /bin/rm -rf online-${LOOL_VERSION}

		cd ${START_DIR}

		echo "${LOOL_VERSION}" >${STAMP_DIR}/online_build

		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Building online finished."
		echo "#"
		echo "#######################################################################################"
		echo
	fi

}
