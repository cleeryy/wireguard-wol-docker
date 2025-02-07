#!/bin/sh

# Apply firewall rules
mkdir -p /app/scripts
iptables -t nat -A PREROUTING -d 192.168.5.0/24 -j NETMAP --to 192.168.1.0/24 > /app/scripts/apply-routing.sh
iptables -t nat -A POSTROUTING -s 192.168.5.0/24 -d 192.168.1.0/24 -j MASQUERADE >> /app/scripts/apply-routing.sh

chmod +x /app/scripts/*.sh
/app/scripts/apply-routing.sh

# Start FastAPI
python3 /app/pivpn-api/main.py &

tree /config
tree /app

# Keep container running
tail -f /dev/null

