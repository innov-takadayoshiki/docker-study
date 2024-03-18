#!/bin/sh

echo ""
echo "***********************************************************"
echo " Starting NGINX PHP-FPM Docker Container                   "
echo "***********************************************************"

echo ""
echo "**********************************"
echo "     Starting Supervisord...     "
echo "***********************************"


supervisord -c /etc/supervisor/supervisord.conf