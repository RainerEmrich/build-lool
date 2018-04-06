#!/bin/bash
#
# Enable the source repositories in /etc/apt/sources.list.
#
# Copyright 2017, 2018 Rainer Emrich, <rainer@emrich-ebersheim.de>
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

enable_source_repositories () {

	if [ "${ENABLE_SOURCE_REPOSITORIES_DONE}" != "1" ] ; then
		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Enabling source repositories in /etc/apt/sources.list."
		echo "#"
		echo "#######################################################################################"
		echo

		REPOSITORIES=$(grep "^deb http" /etc/apt/sources.list)
		oIFS="$IFS"
		IFS=$'\n'
		for LINE in $REPOSITORIES ; do
			SRC_LINE=$(echo $LINE | sed "s%^deb%deb-src%")
			sudo sed --in-place "s%# ${SRC_LINE}%${SRC_LINE}%" /etc/apt/sources.list
		done
		IFS="$oIFS"

		touch ${STAMP_DIR}/enable_source_repositories_done

		echo
		echo "#######################################################################################"
		echo "#"
		echo "# Enabling source repositories finished."
		echo "#"
		echo "#######################################################################################"
		echo

	fi

}
