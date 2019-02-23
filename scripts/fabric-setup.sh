export PATH=$PATH:$GOROOT/bin

echo "GOPATH=$GOPATH"
echo "GOROOT=$GOROOT"

echo "=== Must execute in the setup folder ===="

cd ..

rm -rf misc

echo "====== Starting to Download Fabric ========"
curl -sSL http://bit.ly/2ysbOFE -o bootstrap.sh
chmod 755 *.sh
./bootstrap.sh  1.4.0 1.4.0 0.4.10 -d


echo "======= Copying the binaries to /usr/local/bin===="
rm -rf ./bin 2> /dev/null
mv fabric-samples/bin       .
cp bin/*    /usr/local/bin


mkdir -p misc
mv fabric-samples ./misc

rm bootstrap.sh

chmod 755 orderer/scripts/*.sh
chmod 755 peers/scripts/*.sh
chmod 755 fabric-ca/scripts/*.sh