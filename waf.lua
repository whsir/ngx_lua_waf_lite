-- 检查是否需要拒绝 CC 攻击
if whiteip() then
elseif whitehost() then
elseif denycc() then
elseif ngx.var.http_Acunetix_Aspect then
    ngx.exit(444) -- 请求头中包含 Acunetix-Aspect 返回状态码 444
elseif ngx.var.http_X_Scan_Memo then
    ngx.exit(444) -- 请求头中包含 X_Scan_Memo 返回状态码 444
else
    return
end

