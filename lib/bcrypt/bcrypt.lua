--
-- Created by IntelliJ IDEA.
-- User: xixi
-- Date: 16-9-27
-- Time: 下午5:03
-- To change this template use File | Settings | File Templates.
--

local ffi = require "ffi";
local C = ffi.C;
local _M = { _VERSION = "0.0.1" };

local findso = require "resty.find-so"

local bcryptPath = findso.find_shared_obj(package.cpath, "libbcrypt.so")
local bcrypt = ffi.load(bcryptPath);



ffi.cdef [[
int bcrypt_gensalt(int factor, char salt[64]);
int bcrypt_hashpw(const char *passwd, const char salt[64], char hash[64]);
int bcrypt_checkpw(const char *passwd, const char hash[64]);
]]


function _M.genSalt(factor)

    local salt = ffi.new("char[64]");

    bcrypt.bcrypt_gensalt(factor, salt)

    return ffi.string(salt)
end

function _M.genHash(msg, salt)
    local salt_char = ffi.new("char[64]");
    local msg_char = ffi.new("char[?]", #msg);
    local hash_char = ffi.new("char[64]");
    ffi.copy(salt_char, salt);
    ffi.copy(msg_char, msg);

    bcrypt.bcrypt_hashpw(msg_char, salt_char, hash_char);

    return ffi.string(hash_char);
end

function _M.checkHash(msg, hash)

    local msg_char = ffi.new("char[?]", #msg);
    local hash_char = ffi.new("char[64]");
    ffi.copy(msg_char, msg);
    ffi.copy(hash_char, hash);

    local res = bcrypt.bcrypt_checkpw(msg_char, hash_char);

    if res == 0 then
        return true;
    else
        return false;
    end
end

return _M;

