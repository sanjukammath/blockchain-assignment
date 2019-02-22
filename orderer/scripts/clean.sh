# cleans up the orderer process
killall orderer 2> /dev/null

rm -rf $HOME/orderer  2> /dev/null

rm ../orderer.log  2> /dev/null

rm ../../artefacts/*  2> /dev/null

echo "orderer process killed and artefacts removed"
