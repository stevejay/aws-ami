
#
# Redirect all non-www to www
#

server {
    listen 80;
    server_name  walkdesigner.com;
	return 301 $scheme://www.walkdesigner$request_uri;
}

#
# www
#

server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;

	root /data/www/web-public;
	#index index.html;

	server_name www.walkdesigner.com www-green.walkdesigner.com;

	location / {
		# First attempt to serve request as file, then fall back to displaying a 404.
		try_files $uri $uri/index.html =404;
		# Uncomment to enable naxsi on this location
		# include /etc/nginx/naxsi.rules
	}
	
	location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 365d;
    }

	# Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
	#location /RequestDenied {
	#	proxy_pass http://127.0.0.1:8080;    
	#}

	#error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	#
	#error_page 500 502 503 504 /50x.html;
	#location = /50x.html {
	#	root /usr/share/nginx/html;
	#}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}


# another virtual host using mix of IP-, name-, and port-based configuration
#
#server {
#	listen 8000;
#	listen somename:8080;
#	server_name somename alias another.alias;
#	root html;
#	index index.html index.htm;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}


# HTTPS server
#
#server {
#	listen 443;
#	server_name localhost;
#
#	root html;
#	index index.html index.htm;
#
#	ssl on;
#	ssl_certificate cert.pem;
#	ssl_certificate_key cert.key;
#
#	ssl_session_timeout 5m;
#
#	ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
#	ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
#	ssl_prefer_server_ciphers on;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}
