--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-28
-- Time: 下午4:00
-- To change this template use File | Settings | File Templates.
--

local json = require "cjson";
local userModel = require "model.user"
local args = ngx.req.get_uri_args();

if ngx.req.get_method() == 'GET' then

    local usr = ngx.ctx.user;
    ngx.say(json.encode({ code = 1, msg = "success", ticket = usr.tickets }));

elseif ngx.req.get_method() == 'PUT' then

    local user = ngx.ctx.user;

    if user ~= 'admin' then
        ngx.status = ngx.HTTP_FORBIDDEN;
        ngx.say(json.encode({ code = -1, msg = "forbidden" }));
        ngx.exit(ngx.HTTP_FORBIDDEN);
    end

    if not args.username or not args.type or args.count then
        ngx.status = ngx.HTTP_ILLEGAL;
        ngx.say(json.encode({ code = -1, msg = "参数缺失" }));
        ngx.exit(ngx.HTTP_ILLEGAL);
    end

    local targetUser = userModel.findByName(args.username);

    if not targetUser then
        ngx.status = ngx.HTTP_ILLEGAL;
        ngx.say(json.encode({ code = -1, msg = "用户不存在" }));
        ngx.exit(ngx.HTTP_ILLEGAL);
    end


    if args.type == "charge" then



    elseif args.type == "consume" then

    else
        ngx.status = ngx.HTTP_METHOD_NOT_IMPLEMENTED;
        ngx.say(json.encode({ code = -1, msg = "方法不支持" }));
        ngx.exit(ngx.HTTP_METHOD_NOT_IMPLEMENTED);
    end








end



