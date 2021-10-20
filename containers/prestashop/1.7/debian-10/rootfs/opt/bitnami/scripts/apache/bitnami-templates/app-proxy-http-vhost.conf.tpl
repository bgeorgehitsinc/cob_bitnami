{{before_vhost_configuration}}
<VirtualHost {{http_listen_addresses}}>
  {{server_name_configuration}}
  {{proxy_configuration}}
  {{proxy_http_configuration}}
  ProxyPass / {{proxy_address}}
  ProxyPassReverse / {{proxy_address}}
  {{additional_configuration}}
</VirtualHost>
