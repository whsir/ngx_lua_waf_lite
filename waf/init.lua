require 'config'

local match = string.match
local unescape = ngx.unescape_uri
local ngxmatch = ngx.re.match
local get_headers = ngx.req.get_headers
local optionIsOn = function(options) return options == "on" and true or false end

-- 检查是否开启 WhiteHostCheck、IPWhitelistCheck、CCDeny
WhiteHostCheck = optionIsOn(whiteHostModule)
IPWhitelistCheck = optionIsOn(IPWhitelistModule)
CCDeny = optionIsOn(CCDeny)

-- 获取客户端 IP 地址
function getClientIp()
    local IP = ngx.req.get_headers()["X-Real-IP"]
    if IP == nil then
        IP = ngx.var.remote_addr
    end
    if IP == nil then
        IP = "unknown"
    end
    return IP
end

-- 将 IP 地址转换为十进制数
function ipToDecimal(ckip)
    local n = 4
    local decimalNum = 0
    local pos = 0
    for s, e in function() return string.find(ckip, '.', pos, true) end do
        n = n - 1
        decimalNum = decimalNum + tonumber(string.sub(ckip, pos, s - 1)) * (256 ^ n)
        pos = e + 1
        if n == 1 then decimalNum = decimalNum + tonumber(string.sub(ckip, pos, string.len(ckip))) end
    end
    return decimalNum
end

-- 检查请求的主机是否在白名单中
function whitehost()
    if WhiteHostCheck then
        local items = Set(hostWhiteList)
        for host in pairs(items) do
            if ngxmatch(ngx.var.host, host, "isjo") then
                return true
            end
        end
    end
    return false
end

-- 检查请求是否来自白名单中的 IP 地址
function whiteip()
    if IPWhitelistCheck then
        if next(ipWhitelist) ~= nil then
            local cIP = getClientIp()
            local numIP = 0
            if cIP ~= "unknown" then
                numIP = tonumber(ipToDecimal(cIP))
            end
            for _, ip in pairs(ipWhitelist) do
                local s, e = string.find(ip, '-', 0, true)
                local sIP, eIP
                if s == nil and cIP == ip then
                    return true
                elseif s ~= nil then
                    sIP = tonumber(ipToDecimal(string.sub(ip, 0, s - 1)))
                    eIP = tonumber(ipToDecimal(string.sub(ip, e + 1, string.len(ip))))
                    if numIP >= sIP and numIP <= eIP then
                        return true
                    end
                end
            end
        end
        return false
    else
        return false
    end
end

-- 检查是否需要拒绝 CC 攻击
function denycc()
    if CCDeny then
        local uri = ngx.var.uri
        local CCcount = tonumber(string.match(CCrate, '(.*)/'))
        local CCseconds = tonumber(string.match(CCrate, '/(.*)'))
        local token = getClientIp() .. uri
        local limit = ngx.shared.limit
        local req, _ = limit:get(token)
        if req then
            if req > CCcount then
                ngx.exit(503)
                return true
            else
                limit:incr(token, 1)
            end
        else
            limit:set(token, 1, CCseconds)
        end
    end
    return false
end

-- 设置集合
function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

