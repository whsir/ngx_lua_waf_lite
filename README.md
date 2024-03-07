# ngx_lua_waf_lite

[中文文档](https://github.com/whsir/ngx_lua_waf_lite/blob/main/README.cn.md)

Protect against CC attacks and limit request frequency.


## Usage

Add the following configuration to the http section of your nginx.conf:

```nginx
lua_package_path "/usr/local/nginx/conf/waf/?.lua";
lua_shared_dict limit 10m;
init_by_lua_file  /usr/local/nginx/conf/waf/init.lua; 
access_by_lua_file /usr/local/nginx/conf/waf/waf.lua;
```

## Configuration File config.lua
Used to enable and configure the CC protection feature.

```
whiteHostModule = "off"
-- Whether to enable the Vhost domain whitelist feature. If set to "on", domains or IP addresses listed in `hostWhiteList` will not be restricted. If set to "off", this feature is disabled.
hostWhiteList = {"whsir.com", "wlnmp.com", "127.0.0.1"}
-- Server_name addresses that need to enable the Vhost domain whitelist feature.

IPWhitelistModule = "off"
-- Whether to enable the IP address whitelist feature. If set to "on", IP addresses listed in the whitelist will not be restricted. If set to "off", this feature is disabled.
ipWhitelist = {"127.0.0.1", "10.10.10.1-10.10.10.255"}
-- Client IP addresses or network segments that need to be configured.

CCDeny = "off"
-- Whether to enable the CC (HTTP Flood) protection feature. If set to "on", this feature is enabled and appropriate measures will be taken to prevent malicious large-scale requests. If set to "off", this feature is disabled.

CCrate = "120/60"
-- Specifies the frequency limit for CC protection. For example, "120/60" means allowing 120 requests within 60 seconds. Requests exceeding the frequency limit will trigger protection.

html = [[......]]
-- Custom warning content displayed after triggering the CC protection rule.

```

## Contact

[whsir.com](https://www.whsir.com/)
