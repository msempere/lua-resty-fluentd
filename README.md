# lua-resty-fluentd
Lua fluentd logger for the ngx_lua based on the cosocket API

## Synopsis

```lua
local fluentd = require "resty.fluentd"
local logger = fluentd.new()

local ok, err = logger:connect("127.0.0.1", 24224)
if not ok then
  ngx.say("failed to connect: ", err)
  return
end

logger:log("a.test.tag", {"type":"event", "timestamp":12345678})
```

## Install

```
luarocks install lua-resty-fluentd
```
