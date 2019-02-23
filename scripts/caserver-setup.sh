if [ -z $SUDO_USER ]
then
    echo "===== Script need to be executed with sudo ===="
    echo "Change directory to 'setup'"
    echo "Usage: sudo ./caserver.sh"
    exit 0
fi

echo "=======Set up go======"
sudo apt-get update
sudo apt-get -y install golang-1.10-go

mkdir -p /vagrant/misc/gopath
export GOPATH=/vagrant/misc/gopath
export PATH=$PATH:/usr/lib/go-1.10/bin

echo "++++Fetching Fabric CA Binaries. This may take a few minutes."
go get -u github.com/hyperledger/fabric-ca/cmd/...

echo "+++Moving Fabric CA Binaries"
sudo rm /usr/local/fabric-ca-*  2> /dev/null
sudo cp $GOPATH/bin/* /vagrant/bin
sudo mv $GOPATH/bin/*    /usr/local/bin

echo "Done."
echo "Validate by running>>   fabric-ca-server   version"