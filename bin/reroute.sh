IP=$(dig $1 +short @8.8.8.8 A)
GATEWAY=$(netstat -nr | awk '/default/ { print $2; exit }')
sudo route -nv add $IP $GATEWAY

