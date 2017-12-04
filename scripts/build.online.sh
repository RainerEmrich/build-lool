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
		if [ -d ${LOOL_PREFIX}/share ] ; then sudo /bin/rm -rf ${LOOL_PREFIX}/share ; fi
		if [ -d ${LOOL_PREFIX}/var/www ] ; then sudo /bin/rm -rf ${LOOL_PREFIX}/var/www ; fi

		cd ${BUILD_DIR}

		tar xvf ${SRC_DIR}/online/${LOOL_VERSION}.tar.gz

		cd online-${LOOL_VERSION}

		sed --in-place "s#POCOLIBDIRS=\"/usr/local/lib /opt/poco/lib\"#POCOLIBDIRS=\"${POCO_PREFIX}/lib\"#" loolwsd-systemplate-setup

		LOC_DISTRO="$(basename $(find ${LOOL_PREFIX}/lib -maxdepth 1 -type d -name "*office"))"

		case $LOOL_VERSION in
		2.1.5-5)
			sed --in-place "s/uint64_t/long long unsigned int/g" kit/DummyLibreOfficeKit.cpp
			;;
		*)
			;;
		esac

		./autogen.sh | tee ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1

		./configure --prefix=${LOOL_PREFIX} --with-poco-includes=${POCO_PREFIX}/include --with-poco-libs=${POCO_PREFIX}/lib --with-lokit-path=../core-${LOC_VERSION}/include \
				--with-lo-path=${LOOL_PREFIX}/lib/${LOC_DISTRO} --with-logfile=${LOOL_PREFIX}/var/log/loolwsd/loolwsd.log --with-max-connections=${LOOL_MAX_CON} \
				--with-max-documents=${LOOL_MAX_DOC} | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1

		case $LOOL_VERSION in
		2.1.5-5)
			make -j ${NUM_PROC} CXXFLAGS="-g -O2 -std=c++11 -Wall -Wextra -Wno-error -Wshadow" | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1
			;;
		*)
			make -j ${NUM_PROC} | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1
			;;
		esac
		if [ $? -eq 2 ] ; then
			echo
			echo "ERROR: see ${LOG_DIR}/online-${LOOL_VERSION}.log!"
			echo "Exiting..."
			echo
			exit
		fi

		sudo make install | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1
		sudo make install DESTDIR="${BUILD_DIR}/install" | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1

		sudo tar -C ${BUILD_DIR}/install${LOOL_PREFIX}/ -cvJf ${PKG_DIR}/loolwsd-${LOOL_VERSION}.tar.xz .

		sudo /bin/rm -rf ${BUILD_DIR}/install

		case $LOOL_VERSION in
		1.* | \
		2.0* | \
		libreoffice-5.3.0* | \
		libreoffice-5.3.1* | \
		libreoffice-5.3.2* | \
		libreoffice-5.3.3* | \
		libreoffice-5.3.4*)
			cd loleaflet

			sudo make -j ${NUM_PROC} dist | tee -a ${LOG_DIR}/online-${LOOL_VERSION}.log 2>&1
			if [ $? -eq 2 ] ; then
				echo
				echo "ERROR: see ${LOG_DIR}/online-${LOOL_VERSION}.log!"
				echo "Exiting..."
				echo
				exit
			fi

			sudo /bin/mv loleaflet-*.tar.gz ${PKG_DIR}/loleaflet-${LOOL_VERSION}.tar.gz
			;;
		*)
			;;
		esac

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
