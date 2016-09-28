--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-28
-- Time: 上午10:29
-- To change this template use File | Settings | File Templates.
--


--- -循环
-- for index,item in cursor:pairs() do
-- ngx.say('数据: '..index)
-- if not item['url'] then
-- ngx.say('数据:'..item["title"])
-- else
-- ngx.say('数据:'..item["title"]..item['url'])
-- ngx.say(json_decode(item['url']))
-- end
--
-- end
---- 获取单个集合
-- local res =coll:find_one({key = 150})
--
-- if res then
--
-- ngx.say(res['title'])
-- end

local _M = { _VERSION = "0.0.1" };
local mongo = require "db.mongo";
local bcrypt = require "bcrypt.bcrypt"

function _M.findByName(username)

    local db, err = mongo.init()

    if not db then
        return nil, err .. "Not connected"
    end

    local col = db:get_col("userInfo")

    local res = col:find_one({ username = username })

    if res then
        return res, nil
    else
        return nil, "Not Found"
    end


    local bson = { username = args.username, password = args.password }
    local table = { bson }
    col:insert(table, 0, 0)
end

function _M.register(username, password)

    local db, err = mongo.init();

    if not db then
        return false, err .. "Not connected";
    end

    local col = db:get_col("userInfo");

    if col then

        local res = col:find_one({ username = username });

        if res then
            return false, "User is Existed";
        end
    end

    local salt = bcrypt.genSalt(10);
    local hash = bcrypt.genHash(password, salt);

    local bson = { username = username, password = hash, tickets = 0 };
    local table = { bson };
    local rsOk = col:insert(table, 0, 0);

    if not rsOk then
        return false, "Mongo插入失败";
    else
        return true, nil;
    end
end

function _M.checkPassword(username, password)
    local db = mongo.init();

    if not db then
        return false, "Not connected";
    end

    local col = db:get_col("userInfo");

    local res = col:find_one({ username = username });

    if not res then
        return false, "User not Found";
    end

    if bcrypt.checkHash(password, res.password) then
        return true, nil
    else
        return false, "Wrong Password";
    end
end

return _M;