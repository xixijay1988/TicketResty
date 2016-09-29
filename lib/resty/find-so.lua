--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-29
-- Time: 下午4:40
-- To change this template use File | Settings | File Templates.
--

local _M = { VERSION = '0.0.1' };

local string_gmatch = string.gmatch
local string_match = string.match

-- reference https://github.com/cloudflare/lua-aho-corasick/blob/master/load_ac.lua#L22
function _M.find_shared_obj(cpath, so_name)
    for k, v in string_gmatch(cpath, "[^;]+") do
        local so_path = string_match(k, "(.*/)")
        if so_path then
            -- "so_path" could be nil. e.g, the dir path component is "."
            so_path = so_path .. so_name

            -- Don't get me wrong, the only way to know if a file exist is
            -- trying to open it.
            local f = io.open(so_path)
            if f ~= nil then
                io.close(f)
                return so_path
            end
        end
    end
end

return _M;