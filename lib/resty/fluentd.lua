local msgpack = require('MessagePack')
local tcp = ngx.socket.tcp

local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function (narr, nrec) return {} end
end

local _M = new_tab(0, 54)

_M._VERSION = '0.0.1'

local mt = { __index = _M }

-- constructor
function _M.new(self)
    local sock, err = tcp()
    if not sock then
        return nil, err
    end
    return setmetatable({ _sock = sock }, mt)
end

-- set timeout
function _M.set_timeout(self, timeout)
    local sock = rawget(self, "_sock")
    if not sock then
        return nil, "not initialized"
    end
    return sock:settimeout(timeout)
end

-- connect
function _M.connect(self, ...)
    local sock = rawget(self, "_sock")
    if not sock then
        return nil, "not initialized"
    end
    return sock:connect(...)
end

-- set keepalive
function _M.set_keepalive(self, ...)
    local sock = rawget(self, "_sock")
    if not sock then
        return nil, "not initialized"
    end
    return sock:setkeepalive(...)
end

-- close connection
local function close(self)
    local sock = rawget(self, "_sock")
    if not sock then
        return nil, "not initialized"
    end
    return sock:close()
end
_M.close = close

-- log
function _M.log(self, tag, data)
    local sock = rawget(self, "_sock")
    if not sock then
        return nil, "not initialized"
    end
    return sock:send(msgpack.pack({tag, ngx.time(), data}))
end

return _M
