#!/bin/bash
#
#    Bashhelper functions.
#
#    Project SuperCMD
#    author: Steve Göring
#    contact: stg7@gmx.de
#

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
#    Logging macros,
#        e.g. for errors, warnings, information, debug, ...
#

#
#    Printout error to stderr.
#
logError() {
    echo -e "\033[91m[ERROR]\033[0m $@ " 1>&2;
}

#
#    Printout info message.
#
logInfo() {
    echo -e "\033[92m[INFO ]\033[0m $@"
}

#
#    Printout debug info if debug enabled.
#
logDebug() {
    echo -e "\033[94m[DEBUG]\033[0m $@" 1>&2;
}

#
#    Printout warning.
#
logWarn() {
    echo -e "\033[96m[WARN ]\033[0m $@" 1>&2;
}

#
#    Printout todo things.
#
logTodo() {
    echo -e "\033[35m[TODO ]\033[0m $@" 1>&2;
}

logCall() {
    echo "$(date) : $@" >> "$_LOG_FILE"
}

#
#    Checks if needed tools are available.
#
#    \params $@ list of tools
#    Example call:
#        checktools "bash nano"
#
check_tools() {
    for tool in $@; do
        which $tool > /dev/null

        if [[ "$?" -ne 0 ]]; then
            logError "$tool is not installed."
            exit 1
        fi
    done
    logDebug "Each needed tool ($@) is installed."
}

#
#    Reads a password from stdin.
#
#    \params $1 promt message
#    \params $2 name of result variable
#    Example call:
#        read_password "Please insert your secret password ;)" passwordvar
#
read_password() {
    __resultvar="$2"
    logInfo "$1"
    read -s pw
    eval "$__resultvar=\"$pw\""
}

#
#    Reads (y)es or (n) from stdin, exit if 'y' was not choosen.
#
#    \params $1 promt message
#    \params $2 message for "no" case
#    Example call:
#        yes_no_promt "Is bash not wunderful?"
#
yes_no_promt() {
    logInfo "$1 [y|n]: "
    read yesno

    if [ "$yesno" = n ]; then
        logInfo "$2"
        exit 1
    fi

    if [ "$yesno" != n ] && [ "$yesno" != y ]; then
        logError "Error, usage: [y|n]"
        exit 1
    fi
}

#
#    SSH key exchange.
#
#    \params $1 user at host
#    \params $2 user password
#    Example call:
#        ssh_key_exchange "myuser@mypc" "mysecretpassword"
#
ssh_key_exchange() {
    userathost="$1"
    pw="$2"
    # create a ssh key if there is no one
    if [ ! -f ~/.ssh/id_rsa ]; then
        logInfo "Rsa key does not exist, create one."
        ssh-keygen -N "" -f ~/.ssh/id_rsa
    fi
    cat ~/.ssh/id_rsa.pub | sshpass -p "$pw" ssh "$userathost" \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o LogLevel=error \
        "(cat > tmp.pubkey ; \
            mkdir -p .ssh ; \
            touch .ssh/authorized_keys ; \
            sed -i.bak -e '/$(awk '{print $NF}' ~/.ssh/id_rsa.pub)/d' .ssh/authorized_keys; \
            cat tmp.pubkey >> .ssh/authorized_keys ; \
            rm tmp.pubkey)"
}
#
#    Do a ssh call
#    \params $1 user at host
#    \params $@:2 command to run
#    Example
#        ssh_call "a@hostname" "ls"
#
ssh_call() {
    host="$1"
    shift
    cmd="$@"
    ssh "$host" -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o LogLevel=error \
        -t -t "$cmd" 2> /dev/null
}

#
#    Check that host is alive.
#
#    \params $1 hostname
#    \return true if host is alive, false otherwhise.
#    Example call:
#        host_alive "mypc"
#
host_alive() {
    host="$1"

    if ping -c 1 "$host" &> /dev/null; then
        echo "true"
    else
        echo "false"
    fi
}

#
#    Check that network interface is valid.
#
#    \params $1 interface name
#    \return true if interface is available, false otherwhise.
#    Example call:
#        network_interface_available "eth0"
#
network_interface_available() {
    found=$(grep "$1" /proc/net/dev)

    if  [ -n "$found" ] ; then
        echo "true"
    else
        echo "false"
    fi
}

#
#    Create a temporary file.
#    Filename will be printed on stdout.
#
#    Note: Ubuntu12.04 has an own tempfile function,
#    but this is not general in all linux distributions.
tempfile() {
    filename=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
    echo "/tmp/$filename"
}

#
#    Get a random free tcp port
#
#    \return random free port number on stdout
#    Example:
#        get_random_port
#
get_random_port() {
    python - <<END
import socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("", 0))
print(s.getsockname()[1])
s.close()
END
}

#
#    Get owner of a file or directory
#
#    \params $@ file/dir
#    \return on stdout
#    Example:
#        get_owner "/home/"
#
get_owner() {
    stat -c %U "$@"
}

#
#    Get owner of a file or directory
#
#    \params $@ file/dir
#    \return on stdout
#    Example:
#        get_group "/home/"
#
get_group() {
    stat -c %G "$@"
}

#
#    Printout settings and check configuration.
#
main() {
    if [[ -z "$_BASHHELPER"  ]]; then
        _BASHHELPER="included"
        export _BASHHELPER
    fi
}

usage() {
    echo "helper module"
}

#
#    Call main with arguments.
#
main "$@"
