Listen *:90
<VirtualHost *:90>
    ServerName      tv.solarsquid.com
    ServerAlias     www.tv.solarsquid.com
    ErrorLog        /var/log/httpd/tv.solarsquid.com.error_log
    CustomLog       /var/log/httpd/tv.solarsquid.com.access_log combined

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
    ProxyPass           / http://192.168.0.16:8989/
    ProxyPassReverse    / http://192.168.0.16:8989/
</VirtualHost>
