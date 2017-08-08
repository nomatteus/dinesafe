# SSL

Installing SSL Cert from Let's Encrypt using this guide:
https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04

## Updating via certbot

Run command again:

    sudo certbot certonly --webroot --webroot-path=/usr/local/nginx/html -d dinesafe.to -d www.dinesafe.to

Or run:

    sudo certbox renew

## Locations

* Certs: `/etc/letsencrypt/live/dinesafe.to`
* Strong DH Group: `/etc/ssl/certs/dhparam.pem`
* Nginx conf: `/usr/local/nginx/conf/nginx.conf`

## Install Log

Installed `certbot` according the guide above.

Added this to nginx conf:

    # for lets encrypt ssl via webroot plugin / certbot
    location ~ /.well-known {
            allow all;
    }


