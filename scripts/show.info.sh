#!/bin/bash
#
# Show some information about the script.
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

show_info () {

	echo "#######################################################################################"
	echo "#                                                                                     #"
	echo "# This script sets up an ubuntu 16.04., Debian 8.x, or Debian 9.x standard            #"
	echo "# installation for building libreoffice online to use with nextcloud.                 #"
	echo "#                                                                                     #"
	echo "# The first thing to do is updating the installation and installing the necessary     #"
	echo "# tools and packages.                                                                 #"
	echo "#                                                                                     #"
	echo "# After a reboot the script continues to build libreoffice online.                    #"
	echo "#                                                                                     #"
	echo "# Before you continue, please have a look in the configuration file                   #"
	echo "# ${CONFIG_DIR}/lool-config.sh"
	echo "#                                                                                     #"
	echo "#######################################################################################"
	echo

}
