#cleans all folders and resets to original condition

#Clean the fabric-ca folders
cd /vagrant/fabric-ca/scripts
./clean.sh

#Clean the orderer folders
cd /vagrant/orderer/scripts
./clean.sh

#Clean the peer folders
cd /vagrant/peers/scripts
./clean.sh


# cleanup bins,artefacts, misc/*
echo "===> Removing fabric components"
if [ "$1" = "all" ]; then
    # remove all the binaries
    rm /vagrant/bin/*  2>   /dev/null
    rm -rf /vagrant/misc/*   2>   /dev/null
fi

# Clean up the folder .vagrant
echo "==> Done."
echo "1. To Remove VM. Please run the command   'vagrant destroy' on host machine"
echo "2. To Re-install fabric use scripts under the scritps folder."