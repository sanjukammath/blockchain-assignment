if [ -z $SUDO_USER ]
then
    echo "===== Script need to be executed with sudo ===="
    echo "Change directory to 'scripts'"
    echo "Usage: sudo ./setup-env.sh"
    exit 0
fi

rm -rf misc

echo "Set up go"
sudo apt-get update
sudo apt-get -y install golang-1.10-go

# Setup the Gopath & Path
mkdir -p /vagrant/misc/gopath
export GOPATH=/vagrant/misc/gopath
export PATH=$PATH:/usr/lib/go-1.10/bin

# Get the Fabric CA binaries
go get -u github.com/hyperledger/fabric-ca/cmd/...

# Move the binaries
sudo rm /usr/local/fabric-ca-*  2> /dev/null
sudo cp $GOPATH/bin/* /vagrant/bin
sudo mv $GOPATH/bin/*    /usr/local/bin

echo "fabric-ca setup complete"

curl -sSL http://bit.ly/2ysbOFE | bash 1.4.0 1.4.0 0.4.10 -d

rm -rf ./bin 2> /dev/null
mv fabric-samples/bin .
cp bin/* /usr/local/bin

mkdir -p misc
mv fabric-samples ./misc

chmod 755 orderer/scripts/*.sh
chmod 755 peers/scripts/*.sh
chmod 755 fabric-ca/scripts/*.sh