Listen *:81
<VirtualHost *:81>
    ServerName      home.solarsquid.com
    ServerAlias     www.home.solarsquid.com
    ErrorLog        /var/log/httpd/home.solarsquid.com.error_log
    CustomLog       /var/log/httpd/home.solarsquid.com.access_log combined

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
    ProxyPass           / http://127.0.0.1:82/
    ProxyPassReverse    / http://127.0.0.1:82/
</VirtualHost>
