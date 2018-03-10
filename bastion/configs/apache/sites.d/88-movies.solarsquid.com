Listen *:88
<VirtualHost *:88>
    ServerName      movies.solarsquid.com
    ServerAlias     www.movies.solarsquid.com
    ErrorLog        /var/log/httpd/movies.solarsquid.com.error_log
    CustomLog       /var/log/httpd/movies.solarsquid.com.access_log combined

    # Custom external auth module
    # http://www.server-world.info/en/note?os=CentOS_6&p=httpd&f=12
    AddExternalAuth pwauth /usr/local/libexec/pwauth
    SetExternalAuthMethod pwauth pipe

    <Location />
        AuthType Basic
        AuthBasicProvider external
        AuthExternal pwauth
        Require valid-user
        AuthName "Rectify"
    </Location>

    <Proxy *>
        Order deny,allow
        Allow from all
    </Proxy>

    ProxyRequests       Off
    ProxyPreserveHost   On
    ProxyPass           / http://192.168.0.18:5050/
    ProxyPassReverse    / http://192.168.0.18:5050/
</VirtualHost>
