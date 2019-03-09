#!/bin/bash
#
# Get the required sources.
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

get_sources () {

	echo
	echo "#######################################################################################"
	echo "#"
	echo "# Get the required source packages."
	echo "#"
	echo "#######################################################################################"
	echo

	cd ${SRC_DIR}/poco
	POCO_RELEASE=$(echo ${POCO_VERSION} | sed 's/p.//')
	if [ ! -f "poco-${POCO_VERSION}-all.tar.gz" ] ; then wget https://pocoproject.org/releases/poco-${POCO_RELEASE}/poco-${POCO_VERSION}-all.tar.gz ; fi

	cd ${SRC_DIR}/core
	if [ ! -d "core" ] ; then git clone https://github.com/LibreOffice/core.git ; fi
	cd core
	git fetch --all --tags --prune

	cd ${SRC_DIR}/online
	if [ ! -d "online" ] ; then git clone https://github.com/LibreOffice/online.git ; fi
	cd online
	git fetch --all --tags --prune

	cd ${START_DIR}

	echo
	echo "#######################################################################################"
	echo "#"
	echo "# Getting the required source packages finished."
	echo "#"
	echo "#######################################################################################"
	echo

}
