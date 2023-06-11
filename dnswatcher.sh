#!/bin/bash

# Set the DNS name to check
DNS_NAME="mydomain.com"

# Set the service to restart
SERVICE="haproxy"

# Get the current IP address for the DNS name
OLD_IP=$(dig +short $DNS_NAME)

while true; do
    # Get the current IP address for the DNS name
    CURRENT_IP=$(dig +short $DNS_NAME)

    # Check if the IP address has changed
    if [ "$CURRENT_IP" != "$OLD_IP" ]; then
        # Restart the haproxy service
        systemctl restart $SERVICE
        #Print a log message when the IP changes and is updateds
        logger -t dnswatcher "IP address changed from $OLD_IP to $CURRENT_IP"
        logger -t dnswatcher "Restarting $SERVICE service due to IP address change"
        /bin/echo "$(date) IP address changed from $OLD_IP to $CURRENT_IP" >> /var/log/dnswatcher
        /bin/echo "$(date) Restarting $SERVICE service due to IP address change" >> /var/log/dnswatcher
        
        # Update the old IP address with the new one
        OLD_IP=$CURRENT_IP
    
    fi

    # Sleep for 15 mins before checking again
    sleep 900 
done
