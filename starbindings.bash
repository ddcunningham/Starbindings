#!/bin/bash
#V0.2
declare STEAMUPDATE="/opt/steam/steamcmd.sh +login $STEAMUSER $STEAMPW +app_update 211820 +exit"
declare STEAMVERIFY="/opt/steam/steamcmd.sh +login $STEAMUSER $STEAMPW +app_update verify 211820 +exit"
declare LOGINPW
declare LOGINNOPW
declare VLOGINPW
declare VLOGINNOPW
declare STEAMUSER
declare STEAMPW
declare SBPROCTEST="pgrep xflux"
declare SBPROCLIST="pgrep -l xflux"
declare SOURCEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare STEAMCMDDIR="/opt/steam/steamcmd.sh" 
declare INITFILEDIR="/etc/init.d/starbound"
declare SERVERFILEDIR="/home/steam/Steam/SteamApps/common/Starbound/linux64/launch_starbound_server.sh"
#Menu Functions and Submenu functions.
#Main
mmenu()
{
tput clear
printf "\nMain Menu\n\n1) Steam management\n2) Server management\n3) Setup\n4) Help\n0) Exit\n\n"
read -p "Make your selection: " MMENU
case $MMENU in
	1) smenu ;;
	2) svmenu ;;
	0) exit 0;;
	*) printf "\nInvalid Entry.\n";sleep 1;mmenu;;
esac
}
#Steam
smenu()
{
tput clear
read -p "Are you logged into steam elsewhere? Y\\N: " SMENU
case $SMENU in
	y|Y) ssmenu2;;
	n|N) ssmenu1;;
	*) printf "\nInvalid entry.\n"; sleep 1; smenu;;
esac
}
ssmenu1()
{
tput clear
printf "\nSteam Management\n\n1) Update Starbound\n2) Verify Starbound\n3) Back to Main Menu\n0) Exit\n\n"
read -p "Make your selection: " SSMENU1
case $SSMENU1 in
	1) read -p "Enter your Steam username: " STEAMUSER; $STEAMUPDATE;;
	2) read -p "Enter your Steam username: " STEAMUSER; $STEAMVERIFY;;
	3) mmenu;;
	0) exit 0;;
	*) printf "\nInvalid entry.\n";sleep 1;ssmenu1;;
esac
}
ssmenu2()
{
tput clear
printf "\nSteam Management\n\n1) Update Starbound\n2) Verify Starbound\n3) Back to Main Menu\n0) Exit\n\n"
read -p "Make your selection: " SSMENU2
case $SSMENU2 in
	1) read -p "Enter your Steam username: " STEAMUSER 
		read -p "Enter your Steam password: " STEAMPW 
		 sudo -u steam $STEAMUPDATE;;
	2) read -p "Enter your Steam username: " STEAMUSER
		read -p "Enter your Steam password: " STEAMPW 
		 sudo -u steam $STEAMVERIFY;;
	3) mmenu;;
	0) exit 0;;
	*) printf "\nInvalid entry.\n";sleep 1;ssmenu2;;
esac
}
#Server
svmenu()
{
tput clear
printf "\nServer Management\n\n1) Server Process Management\n2) Server Log Options\n"
printf "3) Server Configuration\n4) Back to Main Menu\n0) Exit\n\n"
read -p "Make your selection: " SVMENU
case $SVMENU in
	1) svprmenu;;
	2) svlgmenu;;
	3) svcfmenu;;
	4) mmenu;;
	0) exit 0;;
	*) printf "\nInvalid entry.\n";sleep 1;svmenu;;
esac
}
svprmenu()
{
tput clear
printf "\nServer Process Management\n\n1) Start Server Daemon\n2) Stop Server Daemon\n3) Restart Server Daemon\n"
printf "4) Server Daemon Status\n5) Identify Server Process \n6) Kill Server Process\n7) Back to Server Management\n0) Exit\n\n"
read -p "Make your selection: " SVPRMENU
case $SVPRMENU in
	1) service starbound start;;
	2) service starbound stop;;
	3) service starbound restart;;
	4) service starbound status;; 
	5) if $SBPROCTEST>/dev/null; then printf "\n%s\n" "$($SBPROCLIST)"; sleep 3; svprmenu; else 
		printf "\nStarbound Server is not running.\n"; sleep 1; svprmenu 
		fi;;
	6) if $SBPROCTEST>/dev/null; then sbkill; else 
		printf "\nStarbound Server is not running.\n"; sleep 1; svprmenu 
		fi;;
	7) svmenu;;
	0) exit 0;;
	*) printf "\nInvalid entry.\n";sleep 1;svprmenu;;
esac
}
sbkill()
{
read -p "Kill the Starbound Server Process? Y\\N: " SBKILL
case $SBKILL in
	y|Y) printf "\n\nKilled %s.\n" "$($SBPROCLIST)"; sleep 1; kill -9 $($SBPROCTEST); svprmenu;;
	n|N) printf "Process Kill Canceled"; sleep 1; svprmenu;;
	*) printf "\nInvalid entry.\n";sleep 1;sbkill;; esac
}
svlgmenu()
{
tput clear
printf "\nServer Log Options\n\n1) Open Log\n2) Review Recent Events\n3) Review Errors\n"
printf "4) Monitor Live Changes\n5) Wipe Server Logs\n6) Back to Server Management\n0) Exit\n\n"
read -p "Make your selection: " SVLGMENU
case $SVLGMENU in
	6) mmenu;; 
	0) exit 0;;
	*) printf "\nInvalid entry.\n";sleep 1;svlgmenu;;
esac
}
svcfmenu()
{
tput clear
printf "\nServer Configuration\n\n1) Show Connected Users\n2) Set Maximum Users\n3) Set Server Password(s)\n"
printf "4) Delete Server Universe\n5) Backup Server Universe\n6) Restore Server Universe\n7)Back to Server Management\n0) Exit\n\n"
read -p "Make your selection: " SVCFMENU
case $SVCFMENU in
	7) mmenu;;	
	0) exit 0;;
	*) printf "\nInvalid entry.\n";sleep 1;svcfmenu;;
esac
}
#THE FRAYED ENDS OF SANITY CHECKING
#THE SETUP SECTION
usertest()
{
printf "\nChecking for user 'steam'.\n"
if getent passwd steam > /dev/null; then
printf "\nUser 'steam' exists. Continuing...\n" ;return; else
printf "\nUser 'steam' does not exist. Creating...\n"
sudo adduser --disabled-login steam
fi
}
steamtest()
{
printf "\nChecking for steamcmd directory.\n"
if [ -s $STEAMCMDDIR ]; then
printf "\nSteamcmd directory exists. Continuing...\n";return;else 
printf "\nSteamcmd directory does not exist. Creating...\n"
cd /opt/
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
inittest()
{
printf "\nChecking for init.d script\n"
if [ -s $INITFILEDIR ]; then
printf "\nInit.d script exists. Continuing...\n";return;else 
printf "\nInit.d script does not exist. Copying...\n"
printf "\nCloning initfile\n"
sudo chown steam:steam $SOURCEDIR/starbound
sudo cp -vp $SOURCEDIR/starbound $INITFILEDIR
printf "\nUpdating runlevels\n"
sudo update-rc.d -v starbound defaults
fi
}
servertest()
{
printf "\nChecking for Starbound Server\n"
if [ -s $SERVERFILEDIR ]; then
printf "\nStarbound server exists. Your files appear to be in order.\nProceeding...\n\n";sleep 2;return;else 
printf "\nStarbound server does not exist. Launching steamcmd and downloading...\n"; steamsetup
fi
}
steamsetup()
{
read -p "Are you logged into steam elsewhere? Y\\N: " SETUPSMENU
case $SETUPSMENU in
        n|N) read -p "Enter your Steam username: " STEAMUSER;
		 sudo -u steam $STEAMUPDATE;;
        y|Y) read -p "Enter your Steam username: " STEAMUSER;
		read -p "Enter your Steam password: " STEAMPW;
		 sudo -u steam $STEAMUPDATE;;
        *) printf "\nInvalid entry.\n"; steamsetup
esac
}
sudo -vS
usertest
steamtest
inittest
servertest
mmenu

