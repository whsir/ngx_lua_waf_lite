# ngx_lua_waf_lite

防止 CC 攻击，限制请求频率。

## 使用方法

在 `nginx.conf` 的 `http` 段添加以下配置：

```nginx
lua_package_path "/usr/local/nginx/conf/waf/?.lua";
lua_shared_dict limit 10m;
init_by_lua_file  /usr/local/nginx/conf/waf/init.lua; 
access_by_lua_file /usr/local/nginx/conf/waf/waf.lua;
```

## 配置文件 config.lua
用于开启和配置 CC 防护功能

```
whiteHostModule = "off"
-- 是否开启 Vhost 域名白名单功能。如果设置为 "on"，则对 `hostWhiteList` 中的域名或 IP 地址不受限制。如果设置为 "off"，则关闭该功能。
hostWhiteList = {"whsir.com","wlnmp.com","127.0.0.1"}
-- 需要开启 Vhost 域名白名单功能的 server_name 地址。

IPWhitelistModule = "off"
-- 是否开启访问 IP 地址白名单功能。如果设置为 "on"，则白名单中列出的 IP 地址将不受限制。如果设置为 "off"，则关闭该功能。
ipWhitelist = {"127.0.0.1", "10.10.10.1-10.10.10.255"}
-- 需要配置的客户端 IP 地址或网段。

CCDeny = "off"
-- 是否开启 CC（HTTP Flood）防护功能。如果设置为 "on"，则开启该功能，将采取相应措施防止恶意的大量请求。如果设置为 "off"，则关闭该功能。

CCrate = "120/60"
-- 指定 CC 防护的频率限制。例如，"120/60" 表示在 60 秒内允许 120 次请求。超过频率限制的请求将触发防护。

html = [[......]]
-- 触发了 CC 防护规则后显示的自定义警告内容。
```

## 联系方式
[whsir.com](https://www.whsir.com/)
