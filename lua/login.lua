--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-23
-- Time: 下午3:09
-- To change this template use File | Settings | File Templates.
--

local args = ngx.req.get_uri_args();
local json = require "cjson";
local jwt = require "resty.jwt";
if args then

    if not args.username or not args.password then
        ngx.exit(ngx.HTTP_ILLEGAL)
    end
    local temp = {header = {typ = "JWT", alg ="HS512"},payload = {foo = "bar"} };
    local msg = jwt:sign("secret", temp);

    ngx.say(json.encode({code = 1, msg = msg}));

else

    ngx.exit(ngx.HTTP_ILLEGAL);
end

--ngx.log(ngx.INFO, args);






