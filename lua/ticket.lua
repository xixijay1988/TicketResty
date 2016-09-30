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

    if user.username ~= 'admin' then
        ngx.status = ngx.HTTP_FORBIDDEN;
        ngx.say(json.encode({ code = -1, msg = "forbidden" }));
        ngx.exit(ngx.HTTP_FORBIDDEN);
    end

    if not args.username or not args.type or not args.count then
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

    local count = tonumber(args.count);

    if count < 0 then
        ngx.status = ngx.HTTP_ILLEGAL;
        ngx.say(json.encode({ code = -1, msg = "充值或消费数量不能小于0" }));
        ngx.exit(ngx.HTTP_ILLEGAL);
    end



    if args.type == "charge" then

        local tickets = targetUser.tickets;
        tickets = tickets + count
        userModel.updateTicket(targetUser, tickets)

        ngx.say(json.encode({ code = 1, msg = "成功", tickets = tickets }));
        return;
    elseif args.type == "consume" then
        local tickets = targetUser.tickets;
        tickets = tickets - count
        if tickets < 0 then
            ngx.status = ngx.HTTP_ILLEGAL;
            ngx.say(json.encode({ code = -1, msg = "余票不足" }));
            ngx.exit(ngx.HTTP_ILLEGAL);
        end
        userModel.updateTicket(targetUser, tickets)
        ngx.say(json.encode({ code = 1, msg = "成功", tickets = tickets }));
        return;
    else
        ngx.status = ngx.c;
        ngx.say(json.encode({ code = -1, msg = "方法不支持" }));
        ngx.exit(ngx.HTTP_METHOD_NOT_IMPLEMENTED);
    end


    ngx.say(json.encode({ code = 1, msg = "成功" }));

else
    ngx.status = ngx.HTTP_NOT_ALLOWED;
    ngx.say(json.encode({ code = -1, msg = "HTTP_NOT_ALLOWED" }));
    ngx.exit(ngx.HTTP_NOT_ALLOWED);
end



