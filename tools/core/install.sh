#!/bin/bash
#    install supercmd to PATH
#
#    Author: Steve Göring

#    This file is part of supercmd.
#
#    supercmd is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    supercmd is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with supercmd.  If not, see <http://www.gnu.org/licenses/>.

#
#    Load libaries and toolkits.
#
scriptPath=${0%/*}
. "$scriptPath"/../../libs/bashhelper.sh
. "$scriptPath"/../../libs/shflags

check_tools "ln"

#
#    Define usage screen.
#
usage() {
    echo "
Usage:
    $(basename "$0")

Description:
    Installs supercmd to PATH.

Examples:
    $(basename "$0")
"
    exit 1
}

#
#    Define command line arguments and parse them.
#
FLAGS_HELP=$(usage)
export FLAGS_HELP
FLAGS "$@" || exit 1  # Parse command line arguments.
eval set -- "${FLAGS_ARGV}"

#
#
#
main() {
    logInfo "Install supercmd to path."
    logWarn "Sudo required."
    supercmdcmdrootpath="$(readlink -f -- $scriptPath/../../)/"
    logDebug "$supercmdcmdrootpath"

    sudo ln -s "$supercmdcmdrootpath/supercmd.py" "/usr/bin/supercmd"


}

#
#    Start programm with parameters.
#
main "$@"
