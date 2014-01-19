server {
  listen [::]:8080 ipv6only=off;
  server_name {{ application_host }};

  root {{ app_directory}};

  access_log {{ app_directory}}/log/access.log;
  error_log {{ app_directory}}/log/error.log notice;

  charset utf-8;
  client_max_body_size 100m; # necessary for HUUUGE svg uploads

  log_subrequest on;
  rewrite_log on;

  # TODO: Enforce that /magazins/3 becomes /magazins/3/
  location ~ ^/magazins/(.*)$ {
    alias {{ app_directory}}/public/magazins/$1;

    error_page 404 /index.html;
  }

  location ~ ^/backend/assets/(.*)$ {
    proxy_pass http://localhost:9666/assets/$1;
  }

  location ~ /(backend|assets) {
    #add_header X-Frame-Options "ALLOW-FROM http://seenex.dev";

    alias {{ app_directory}}/public;

    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto http;
    proxy_hide_header X-Runtime;
    proxy_hide_header X-Rack-Cache;
    proxy_hide_header X-Frame-Options;
    # proxy_intercept_errors on;
    proxy_redirect off;
    error_page 404 /index.html;

    try_files $uri @fashionmag_proxy;
  }

  location /uploads {
    alias /vagrant/public/uploads;
  }

  location @fashionmag_proxy {
    proxy_pass http://localhost:9666;
  }
}