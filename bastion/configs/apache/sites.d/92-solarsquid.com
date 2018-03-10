Listen *:92
<VirtualHost *:92>
    ServerName      solarsquid.com
    ServerAlias     www.solarsquid.com
    DocumentRoot    /home/jdarr/solarsquid.com/html
    ErrorLog        /var/log/httpd/home.solarsquid.local.error_log
    CustomLog       /var/log/httpd/home.solarsquid.local.access_log combined

    Options +Indexes
</VirtualHost>
