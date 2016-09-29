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

    if not ngx.cxt.user then

    end


elseif ngx.req.get_method() == 'POST' then



end



