--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-28
-- Time: 下午4:00
-- To change this template use File | Settings | File Templates.
--

local json = require "cjson";
local jwt = require "resty.jwt";
local userModel = require "model.user"
local args = ngx.req.get_uri_args();

if ngx.req.get_method() == 'GET' then

    local header = ngx.req.get_headers();
    local token = header["Authorization"];
    if not token then
        ngx.status = ngx.HTTP_UNAUTHORIZED;
        ngx.say(json.encode({ code = -1, msg = "缺少授权信息" }));
        return
    end

    local jwtObj = jwt:verify('secret', token)
    if not jwtObj then
        ngx.status = ngx.HTTP_UNAUTHORIZED;
        ngx.say(json.encode({ code = -1, msg = "授权错误" }));
        return
    end

    if jwtObj.verified then

        local payload = jwtObj.payload;
        local user = userModel.findByName(payload.username)

        if not user then
            ngx.status = ngx.HTTP_ILLEGAL;
            ngx.say(json.encode({ code = -1, msg = "用户不存在" }));
            return
        end

        ngx.say(json.encode({ code = 1, msg = "成功", ticket = user.tickets }))


    else
        ngx.status = ngx.HTTP_UNAUTHORIZED;
        ngx.say(json.encode({ code = -1, msg = "授权错误" }));
        return
    end
end


