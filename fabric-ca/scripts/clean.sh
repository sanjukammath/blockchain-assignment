# cleans up the server and client folders

killall fabric-ca-server  2> /dev/null

rm -rf ../server/*  2> /dev/null

rm -rf ../client/*   2> /dev/null

echo "Killed the CA server and removed the identities"