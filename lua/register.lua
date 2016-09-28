--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-28
-- Time: 上午11:29
-- To change this template use File | Settings | File Templates.
--
local args = ngx.req.get_uri_args();
local userModel = require "model.user";
local json = require "cjson";
if args then

    if not args.username or not args.password then
        ngx.status = ngx.HTTP_ILLEGAL;
        ngx.say(json.encode({ code = -1, msg = "参数缺失" }));
        return;
    end

    local method = ngx.req.get_method();

    if method ~= "POST" then
        ngx.status = ngx.HTTP_NOT_ALLOWED;
        ngx.say(json.encode({ code = -1, msg = "方法不支持" }));
        return;
    end

    local ok, err = userModel.register(args.username, args.password);

    if ok then
        ngx.say(json.encode({ code = 1, msg = "注册成功" }));
        return;
    else
        ngx.status = ngx.HTTP_ILLEGAL;
        ngx.say(json.encode({ code = -1, msg = err .. "失败" }));
        return;
    end

else
    ngx.exit(ngx.HTTP_ILLEGAL);
end