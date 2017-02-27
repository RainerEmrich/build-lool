#!/bin/bash
#
# Source the scripts to setup the functions
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

. ${SCRIPT_DIR}/get.config.sh
. ${SCRIPT_DIR}/show.info.sh
. ${SCRIPT_DIR}/ask.to.continue.sh
. ${SCRIPT_DIR}/pause.sh
. ${SCRIPT_DIR}/upgrade.system.sh
. ${SCRIPT_DIR}/get.sources.sh
. ${SCRIPT_DIR}/build.poco.sh
. ${SCRIPT_DIR}/build.libreoffice.sh
. ${SCRIPT_DIR}/build.online.sh
. ${SCRIPT_DIR}/build.package.sh
