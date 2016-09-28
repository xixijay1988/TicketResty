--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-23
-- Time: 下午3:09
-- To change this template use File | Settings | File Templates.
--


local json = require "cjson";
local jwt = require "resty.jwt";
local userModel = require "model.user";

local args = ngx.req.get_uri_args();
if args then

    if not args.username or not args.password then
        ngx.status = ngx.HTTP_ILLEGAL;
        ngx.say(json.encode({ code = -1, msg = "参数缺失" }));
        return;
    end

    if ngx.req.get_method() ~= 'GET' then
        ngx.status = ngx.HTTP_NOT_ALLOWED;
        ngx.say(json.encode({ code = -1, msg = "方法不支持" }));
        return;
    end

    local ok, err = userModel.checkPassword(args.username, args.password);

    if not ok then
        ngx.status = ngx.HTTP_ILLEGAL;
        ngx.say(json.encode({ code = -1, msg = err }));
        return;
    end

    local temp = { header = { typ = "JWT", alg = "HS256" }, payload = { username = args.username } };
    local token = jwt:sign("secret", temp);


    ngx.say(json.encode({ code = 1, msg = "Success!", token = token }));

else

    ngx.exit(ngx.HTTP_ILLEGAL);
end

--ngx.log(ngx.INFO, args);






