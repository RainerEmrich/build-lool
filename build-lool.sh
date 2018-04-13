#!/bin/bash
#
# This script builds libreoffice and libreoffice online on an ubuntu 16.04.,
# Debian 8.x or Debian 9.x instance. Installs and sets up all required
# packages and finally builds libreoffice and libreoffice online.
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

export START_DIR="$(pwd)"
export MYSELF="$(readlink -f "$0")"
export MYSELF_QUOTED="$(echo "${MYSELF}" | sed 's/\//\\\//g' -)"
export BASE_DIR="$(dirname "${MYSELF}")"
export BUILD_DIR="${BASE_DIR}/build"
export CONFIG_DIR="${BASE_DIR}/config"
export LOG_DIR="${BASE_DIR}/logs"
export PKG_DIR="${BASE_DIR}/packages"
export SCRIPT_DIR="${BASE_DIR}/scripts"
export SRC_DIR="${BASE_DIR}/sources"
export STAMP_DIR="${BASE_DIR}/stamps"

if [ ! -d ${BUILD_DIR} ] ; then mkdir -p ${BUILD_DIR} ; fi
if [ ! -d ${LOG_DIR} ] ; then mkdir -p ${LOG_DIR} ; fi
if [ ! -d ${PKG_DIR} ] ; then mkdir -p ${PKG_DIR} ; fi
if [ ! -d ${SRC_DIR} ] ; then mkdir -p ${SRC_DIR} ; fi
if [ ! -d ${SRC_DIR}/poco ] ; then mkdir -p ${SRC_DIR}/poco ; fi
if [ ! -d ${SRC_DIR}/core ] ; then mkdir -p ${SRC_DIR}/core ; fi
if [ ! -d ${SRC_DIR}/online ] ; then mkdir -p ${SRC_DIR}/online ; fi
if [ ! -d ${STAMP_DIR} ] ; then mkdir -p ${STAMP_DIR} ; fi


. ${SCRIPT_DIR}/setup.functions.sh

get_os_release
test_os_release

get_config
show_info

ask_to_continue


if [ "${UPGRADE_DONE}" != "1" ] ; then
	test -z "$(grep "${MYSELF}" ~/.bashrc)" && echo "${MYSELF}" >>~/.bashrc
fi


enable_source_repositories
upgrade_system
get_sources
build_poco
build_libreoffice
build_online
build_package


test ! -z "$(grep "${MYSELF}" ~/.bashrc)" && sed --in-place "/${MYSELF_QUOTED}/d" ~/.bashrc

echo
echo "#######################################################################################"
echo "#"
echo "# INFO: Script finished!"
echo "#"
echo "# You find the built packages in the following directory:"
echo "# ${PKG_DIR}"
echo "#"
echo "# Built packages:"
echo "# poco-${POCO_VERSION}.tar.xz"
echo "# core-${LOC_VERSION}.tar.xz"
echo "# loolwsd-${LOOL_VERSION}.tar.xz"

case $LOOL_VERSION in
1.* | \
2.0* | \
libreoffice-5.3.0* | \
libreoffice-5.3.1* | \
libreoffice-5.3.2* | \
libreoffice-5.3.3*)
	echo "# loleaflet-${LOOL_VERSION}.tar.gz"
	;;
*)
	;;
esac

echo "#"
echo "# Single archive for simple installation:"
echo "# ${PACKAGE_NAME}.tar.xz"
echo "#"
echo "# List of required packages:"
echo "# ${PACKAGE_NAME}-required-packages.txt"
echo "#"
echo "#######################################################################################"
echo
