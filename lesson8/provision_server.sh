#!/bin/bash
DOMAIN=$1
SERVER_IP="172.17.177.2"

echo "nastrojka servera"
apt-get update
apt-get install apache2 -y
a2enmod ssl
a2enmod rewrite
mkdir -p /etc/apache2/ssl

echo "OpenSSL cert"
cat <<EOF > /tmp/openssl.cnf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = $DOMAIN
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
DNS.2 = www.$DOMAIN
EOF

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt -config /tmp/openssl.cnf
cp /etc/apache2/ssl/apache.crt /vagrant/server.crt

echo "site files"
mkdir -p /var/www/$DOMAIN
cat <<EOF > /var/www/$DOMAIN/index.html
<!DOCTYPE html>
<html>
<head><title>apache</title></head>
<body><h1>welcome to my domain </h1></body>
</html>
EOF

echo "apache conf"
cat <<EOF > /etc/apache2/sites-available/$DOMAIN.conf
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    RewriteEngine On
    RewriteRule ^(.*)\$ https://$DOMAIN\$1 [R=301,L]
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot /var/www/$DOMAIN
    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/apache.crt
    SSLCertificateKeyFile /etc/apache2/ssl/apache.key
    RewriteEngine On
    RewriteCond %{HTTP_HOST} ^www\.(.*)\$ [NC]
    RewriteRule ^(.*)\$ https://%1\$1 [R=301,L]
    <Directory /var/www/$DOMAIN>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2dissite 000-default.conf
a2ensite $DOMAIN.conf
systemctl restart apache2
echo "completed server"