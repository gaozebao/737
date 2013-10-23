#!/bin/bash

# FOR THE FIRST RUN: sudo ./setup-script.sh --first

# FOR ALL RUNS AFTER VNCSERVER HAS SUCCESSFULLY SETUP,
# DO NOT INCLUDE THE “--first”

#script must be run as root
# sudo bash setup-script.sh

if [[ $EUID -ne 0 ]]; then
echo "You must be root user! Run as follows: sudo ./setup-script.sh" 2>&1
echo “For the first time running include the --first argument” 2>&1
exit 1
fi
SVN_URL=http://svn.code.sf.net/p/guitar/code/WebGuitar

# Get dependencies
sudo -S apt-get install -y -f openjdk-6-jre
sudo -S apt-get install -y -f openjdk-6-jdk
sudo -S apt-get install -y -f subversion
sudo -S apt-get install -y -f ant
sudo -S apt-get install -y -f vim
sudo -S apt-get install -y -f graphviz

# setup vnc server
sudo -S apt-get install -y -f vnc4server

if [[ $1 = "--first" ]]
echo “\n\n----------------------------------\n”
echo “* USER INPUT NEEDED!
echo “\n----------------------------------\n”
echo “Must set password for vncserver, which is used for running Jenkins in headless mode.\n”
echo “Note: The password can only be 8 characters long\n”

#setup vncserver password
then
sudo -u $SUDO_USER vncserver
sudo -u $SUDO_USER vncserver -kill :1
else
echo "--first argument absent, skipping vncserver setup"
fi

# get repository
sudo -u $SUDO_USER svn co $SVN_URL guitar
cd $PWD/guitar/WebGuitarSetup

# need firefox 6
sudo -u $SUDO_USER tar -xf firefox-6.0.tar.bz2

#rename directory
sudo -u $SUDO_USER mv firefox firefox-6
cd firefox-6

#remove update files, to force firefox to stay at version 6
rm update.locale
rm updater
rm updater.ini

#setup profile
sudo -u $SUDO_USER ./firefox -CreateProfile firefoxV6 -no-remote

#set firefox6 as default
sudo rm /usr/bin/firefox
newFFP=$(readlink -f .)
sudo ln -s $newFFP/firefox /usr/bin/firefox

# need selenium plugin
cd ..

# will cause firefox to open and install selenium, simply click INSTALL
echo "Click the INSTALL button when prompted!"
sleep 2
sudo -u $SUDO_USER ./firefox-6/firefox -P firefoxV6 -no-remote selenium-ide-2.0.0.xpi
echo "Setup Complete!"
