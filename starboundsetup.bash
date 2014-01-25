#!/bin/bash ##Starbound Setup Script V0.2
##Authored by DC
declare USERNAME
declare PASSWORD 
declare SOURCEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare STEAMCMDDIR="/opt/steam/steamcmd.sh" 
declare INITFILEDIR="/etc/init.d/starbound"
declare SERVERFILEDIR="/home/steam/Steam/SteamApps/common/Starbound/linux64/launch_starbound_server.sh"

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
printf "\nStarbound server exists. Your files appear to be in order, setup is finished.\n";exit 0;else 
printf "\nStarbound server does not exist. Launching steamcmd and downloading...\n"
return; fi
}
steamsetup()
{
read -p "Are you logged into steam elsewhere? Y\\N: " SETUPSMENU
case $SETUPSMENU in
        n|N) read -p "Enter your Steam username: " USERNAME;
		sudo su - steam -c "/opt/steam/steamcmd.sh +login $USERNAME +app_update 211820 +exit";;
        y|Y) read -p "Enter your Steam username: " USERNAME;
		read -p "Enter your Steam password: " PASSWORD;
		sudo su - steam -c "/opt/steam/steamcmd.sh +login $USERNAME $PASSWORD +app_update 211820 +exit";;
        *) printf "\nInvalid entry.\n"; steamsetup
esac
}
sudo -vS
usertest
steamtest
inittest
servertest
steamsetup
exit 0

