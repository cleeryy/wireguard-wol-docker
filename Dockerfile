FROM lscr.io/linuxserver/wireguard:latest

# Install dependencies
RUN apk add --no-cache python3 py3-pip iptables tree \
    && pip3 install fastapi uvicorn wakeonlan --break-system-packages

# Copy custom components
COPY app /app
COPY routes /config/routes

# Persistent network configuration
RUN echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-forwarding.conf \
    && mkdir -p /config/scripts

# Custom routing rules
RUN echo "iptables -t nat -A PREROUTING -s 192.168.1.0/24 -j DNAT --to-destination 192.168.5.0/24" > /config/scripts/apply-routing.sh \
    && echo "iptables -t nat -A POSTROUTING -d 192.168.5.0/24 -j MASQUERADE" >> /config/scripts/apply-routing.sh \
    && chmod +x /config/scripts/*.sh

# Startup script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]

