#!/bin/bash
#V0.3
##Variables for menucreator
declare -i MCOUNTER
declare -a MARRAY
declare MNAME
##Variables for steamlogin
declare LOGINPW
declare LOGINNOPW
declare VLOGINPW
declare VLOGINNOPW
declare STEAMUSER
declare STEAMPW
##Variables for setup portion
declare SOURCEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare STEAMCMDDIR="/opt/steam/steamcmd.sh" 
declare INITFILEDIR="/etc/init.d/starbound"
declare SERVERFILEDIR="/home/steam/Steam/SteamApps/common/Starbound/linux64/starbound_server"
#Subfunctions referenced in menu functions
fail(){
echo "$1"; exit 1
}
steamlogin(){
if [[ $LOGINPW -eq 1 && $LOGINNOPW -eq 0 && $VLOGIN -eq 0 && $VLOGINNO -eq O ]]; then
sudo su - steam -c "read -p 'Enter your Steam username: ' STEAMUSER
	read -p 'Enter your Steam password: ' STEAMPW
	/opt/steam/steamcmd.sh +login \$STEAMUSER \$STEAMPW +app_update 211820 +exit"
elif [[ $LOGINPW -eq 0 && $LOGINNOPW -eq 1 && $VLOGIN -eq 0 && $VLOGINNOPW -eq O ]]; then
sudo su - steam -c "read -p 'Enter your Steam username: ' STEAMUSER
	/opt/steam/steamcmd.sh +login \$STEAMUSER +app_update 211820 +exit"
elif [[ $LOGINPW -eq 0 && $LOGINNOPW -eq 0 && $VLOGIN -eq 1 && $VLOGINNOPW -eq O ]]; then
sudo su - steam -c "read -p 'Enter your Steam username: ' STEAMUSER
	read -p 'Enter your Steam password: ' STEAMPW
	/opt/steam/steamcmd.sh +login \$STEAMUSER \$STEAMPW +app_update 211820 -validate +exit"
elif [[ $LOGINPW -eq 0 && $LOGINNOPW -eq 0 && $VLOGIN -eq 0 && $VLOGINNOPW -eq 1 ]]; then
sudo su - steam -c "read -p 'Enter your Steam username: ' STEAMUSER
	/opt/steam/steamcmd.sh +login \$STEAMUSER +app_update 211820 -validate +exit"
else
	echo "steamlogin function failed"; exit 1 
fi
read -p "Press ENTER to return to main menu."
mmenu
}
menuprinter(){
tput clear
echo -e "\n$MNAME";
MCOUNTER=0
for MCYCLE in "${MARRAY[@]}"; do
        let "MCOUNTER++"
        printf "\n%d)%s\n" "$MCOUNTER" "$MCYCLE"
done
printf "\n"
}
#Menu functions
mmenu(){
MNAME="Main Menu"
MARRAY=("Steam management" "Server management" "Exit script")
menuprinter
read -p "Make your selection: " MMENU
case $MMENU in
	1) smenu ;;
	2) svmenu ;;
	3) exit 0;;
	*) mmenu
esac
}

#Steam
smenu(){
read -p "Are you logged into steam elsewhere? Y\\N: " SMENU
case $SMENU in
	y|Y) ssmenu1;;
	n|N) ssmenu2;;
	*) smenu;;
esac
}
ssmenu1(){
MNAME="Steam Management"
MARRAY=("Update Starbound" "Verify Starbound" "Back to Main Menu" "Exit")
menuprinter
read -p "Make your selection: " SSMENU1
case $SSMENU1 in
	1) LOGINPW=1; LOGINNOPW=0; VLOGINPW=0; VLOGINNOPW=0
		steamlogin;;
	2) LOGINPW=0; LOGINNOPW=0; VLOGINPW=1; VLOGINNOPW=0
		steamlogin;;
	3) mmenu;;
	4) exit 0;;
	*) ssmenu1;;
esac
}
ssmenu2(){
MNAME="Steam Management"
MARRAY=("Update Starbound" "Verify Starbound" "Back to Main Menu" "Exit")
menuprinter
read -p "Make your selection: " SSMENU2
case $SSMENU2 in
	1) LOGINPW=0; LOGINNOPW=1; VLOGINPW=0; VLOGINNOPW=0
		steamlogin;;
	2) LOGINPW=0; LOGINNOPW=0; VLOGINPW=0; VLOGINNOPW=1
		steamlogin;;
	3) mmenu;;
	4) exit 0;;
	*) ssmenu2;;
esac
}
#Server
svmenu(){
MNAME="Server Management"
MARRAY=("Server Daemon Management" "Server Log Options" "Server Configuration" "Back to Main Menu" "Exit")
menuprinter
read -p "Make your selection: " SVMENU
case $SVMENU in
	1) svprmenu;;
	2) svlgmenu;;
	3) svcfmenu;;
	4) mmenu;;
	5) exit 0;;
	*) svmenu;;
esac
}
svprmenu(){
MNAME="Server Daemon Management"
MARRAY=("Start Server Daemon" "Stop Server Daemon" "Restart Server Daemon" "Server Daemon Status" "Back to Server Management" "Exit")
menuprinter
read -p "Make your selection: " SVPRMENU
case $SVPRMENU in
	1) service starbound start;;
	2) service starbound stop;;
	3) service starbound restart;;
	4) service starbound status;; 
##Uncomment if direct process management is no longer obsolete.	5) if $SBPROCTEST>/dev/null; then printf "\n%s\n" "$($SBPROCLIST)"; sleep 3; svprmenu; else 
#		printf "\nStarbound Server is not running.\n"; sleep 1; svprmenu 
#		fi;;
#	6) if $SBPROCTEST>/dev/null; then sbkill; else 
#		printf "\nStarbound Server is not running.\n"; sleep 1; svprmenu 
#		fi;;
	5) svmenu;;
	6) exit 0;;
	*) svprmenu;;
esac
}
#sbkill(){
#read -p "Kill the Starbound Server Process? Y\\N: " SBKILL
#case $SBKILL in
#	y|Y) printf "\n\nKilled %s.\n" "$($SBPROCLIST)"; sleep 1; kill -9 $($SBPROCTEST); svprmenu;;
#	n|N) printf "Process Kill Canceled"; sleep 1; svprmenu;;
#	*) printf "\nInvalid entry.\n";sleep 1;sbkill;; esac
#}
svlgmenu(){
MNAME="Server Log Options"
MARRAY=("Open Log" "Review Recent Events" "Review Errors" "Server Daemon Status" "Monitor Live Changes" "Wipe Server Logs" "Back to Server Management" "Exit")
menuprinter
read -p "Make your selection: " SVLGMENU
case $SVLGMENU in
	7) svmenu;; 
	8) exit 0;;
	*) svlgmenu;;
esac
}
svcfmenu(){
MNAME="Server Configuration"
MARRAY=("Password Management" "Universe Management" "User Management" "Server Variables")
menuprinter
read -p "Make your selection: " SVCFMENU
case $SVCFMENU in
	7) mmenu;;	
	0) exit 0;;
	*) svcfmenu;;
esac
}
#THE FRAYED ENDS OF SANITY CHECKING
#THE SETUP SECTION
usertest(){
printf "\nChecking for user 'steam'.\n"
if getent passwd steam > /dev/null; then
printf "\nUser 'steam' exists. Continuing...\n" ; else
printf "\nUser 'steam' does not exist. Creating...\n"
sudo adduser --disabled-login steam
fi
}
steamtest(){
printf "\nChecking for steamcmd directory.\n"
if [ -s $STEAMCMDDIR ]; then
printf "\nSteamcmd directory exists. Continuing...\n";return;else 
printf "\nSteamcmd directory does not exist. Creating...\n"
cd /opt/ || fail "/opt/ directory does not exist, aborting script."
sudo mkdir steam
cd steam
printf "\nDownloading steamcmd\n"
sudo wget -v http://media.steampowered.com/client/steamcmd_linux.tar.gz
printf "\nUnpacking steamcmd\n"
sudo tar xzfv steamcmd_linux.tar.gz
printf "\nTidying up\n"
sudo rm -v steamcmd_linux.tar.gz
sudo chown -R steam:steam /opt/steam
printf "\nUpdating steamcmd\n"
sudo su - steam -c "/opt/steam/steamcmd.sh +exit"
fi
}
inittest(){
printf "\nChecking for init.d script\n"
if [ -s $INITFILEDIR ]; then
printf "\nInit.d script exists. Continuing...\n";return;else 
printf "\nInit.d script does not exist. Copying...\n"
printf "\nCloning initfile\n"
sudo chown steam:steam $SOURCEDIR/starbound || fail "Starbound initfile is not in script's parent folder, aborting script."
sudo cp -vp $SOURCEDIR/starbound $INITFILEDIR
printf "\nUpdating runlevels\n"
sudo update-rc.d -v starbound defaults
fi
}
servertest(){
printf "\nChecking for Starbound Server\n"
if [ -s $SERVERFILEDIR ]; then
printf "\nStarbound server exists. Your files appear to be in order.\nHit enter to proceed. \n\n";read; else 
printf "\nStarbound server does not exist. Launching steamcmd and downloading...\n"; steamsetup
fi
}
steamsetup(){
read -p "Are you logged into steam elsewhere? Y\\N: " SETUPSMENU
case $SETUPSMENU in
	y|Y) LOGINPW=1; LOGINNOPW=0; VLOGINPW=0; VLOGINNOPW=0
		steamlogin;;
	n|N) LOGINPW=0; LOGINNOPW=1; VLOGINPW=0; VLOGINNOPW=0
		steamlogin;;
        *) steamsetup;;
esac
}
sudo -vS
tput clear
usertest
steamtest
inittest
servertest
mmenu


