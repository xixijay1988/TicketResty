--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-29
-- Time: 上午10:23
-- To change this template use File | Settings | File Templates.
--

local jwt = require "resty.jwt";
local headers = ngx.req.get_headers();

if not headers then

    local token = headers["Authorization"];
    if not token then
        ngx.status = ngx.HTTP_UNAUTHORIZED;
        ngx.say(json.encode({ code = -1, msg = "缺少授权信息" }));
        ngx.exit(ngx.HTTP_UNAUTHORIZED);
    end

    local jwtObj = jwt:verify('secret', token)
    if not jwtObj then
        ngx.status = ngx.HTTP_UNAUTHORIZED;
        ngx.say(json.encode({ code = -1, msg = "授权错误" }));
        ngx.exit(ngx.HTTP_UNAUTHORIZED);
        return
    end

    if jwtObj.verified then

        local payload = jwtObj.payload;
        local user = userModel.findByName(payload.username)

        if not user then
            ngx.status = ngx.HTTP_ILLEGAL;
            ngx.say(json.encode({ code = -1, msg = "用户不存在" }));
            ngx.exit(ngx.HTTP_ILLEGAL);
            return
        end

        ngx.cxt.user = user;

    else
        ngx.status = ngx.HTTP_UNAUTHORIZED;
        ngx.say(json.encode({ code = -1, msg = "授权错误" }));
        ngx.exit(ngx.HTTP_UNAUTHORIZED);
        return
    end
else
    ngx.status = ngx.HTTP_UNAUTHORIZED;
    ngx.say(json.encode({ code = -1, msg = "缺少授权信息" }));
    ngx.exit(ngx.HTTP_UNAUTHORIZED);
end


