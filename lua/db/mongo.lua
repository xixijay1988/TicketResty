--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-28
-- Time: 上午10:29
-- To change this template use File | Settings | File Templates.
--

local _M = { _VERSION = "0.0.1" };
local mongo = require "resty.mongol"

_M.conn = nil
_M.db = nil

function _M.init()

    if _M.db then
        return _M.db;
    end
    local conn = mongo:new(); -- return a conntion object
    conn:set_timeout(1000);
    local ok, err = conn:connect("127.0.0.1", 27017)

    if not ok then
        return nil, err
    end

    local db = conn:new_db_handle("ticket")
    _M.db = db;
    return db, nil;
end

function _M.close()

    if _M.conn then
        _M.conn.close()
        _M.conn = nil
    end
end




return _M;