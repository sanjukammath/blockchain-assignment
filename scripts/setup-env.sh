if [ -z $SUDO_USER ]
then
    echo "===== Script need to be executed with sudo ===="
    echo "Change directory to 'scripts'"
    echo "Usage: sudo ./setup-env.sh"
    exit 0
fi

cd ..
rm -rf misc
sudo rm -rf ./bin 2> /dev/null

echo "setting up go..."
sudo apt-get update
sudo apt-get -y install golang-1.10-go

# Setup the Gopath & Path
mkdir -p /vagrant/misc/gopath
source export GOPATH=/vagrant/misc/gopath
source export PATH=$PATH:/usr/lib/go-1.10/bin

echo "go installation complete."
echo "setting up fabric-ca. This may take some time..."
# Get the Fabric CA binaries
go get -u github.com/hyperledger/fabric-ca/cmd/...

# Move the binaries
sudo rm /usr/local/fabric-ca-*  2> /dev/null
sudo cp $GOPATH/bin/* /vagrant/bin
sudo mv $GOPATH/bin/*    /usr/local/bin

echo "fabric-ca setup complete."
echo "setting up fabric binaries. This may take some time..."

curl -sSL http://bit.ly/2ysbOFE -o bootstrap.sh
chmod 755 *.sh
sudo ./bootstrap.sh  1.4.0 1.4.0 0.4.10 -d

sudo mv fabric-samples/bin .
sudo cp bin/* /usr/local/bin

sudo mkdir -p misc
sudo mv fabric-samples ./misc

sudo rm bootstrap.sh

echo "fabric binaries setup completed."

chmod 755 /vagrant/orderer/scripts/*.sh
chmod 755 /vagrant/peers/scripts/*.sh
chmod 755 /vagrant/fabric-ca/scripts/*.sh

echo "Done"