require("posix")
local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

local function string2byte(data)
    local i = 1
    local t = {}
    for i = 1, string.len(data) do 
        t[i] = data:byte(i)
    end
    return t
end


dofile( "/root/luabgp/readtoml.lua")
dofile("/root/luabgp/createpacket.lua")

file = io.open("/root/luabgp/bgp.conf", "r")
string = file:read("*all")
file:close()

config = loadstr(string)

local socket = require("socket")
local copas = require("copas")

local server = assert(socket.bind("*",179))
--local client = server:accept()
--client:settimeout(0.5)

function SendOPMsg(c)
    local data = CreateOpenMessage(config)
    c:send(data) 
    print("Send OpenMessage")
end

function SendKeepAlive(c)
    local data = CreateKeepAliveMessage(conf)
    c:send(data)
    print("Send KeepAlive")
end
 
--[[
while true do 
    local line, err,partial  = client:receive("*r")
    if line ~= nil then
        t = string2byte(line)
        if t[19] == 1 then
            print("Receive OpenMessage")
            SendOPMsg(client)      
        elseif t[19] == 4 then
            print("Receive KeepAlive")
            SendKeepAlive(client)
        end
    else
    end
end
]]--

copas.addserver(server , function(c) return Handler(c,c:getpeername()) end )

function Handler(c,host,port)
    local peer = host .. ":" .. port
    print("connection form",peer)
    c = copas.wrap(c)
    local rBuf = ""
    while true do 
        local line = c:receive("*r")
        if line ~= nil then
            t = string2byte(line)
            if t[19] == 1 then
                print("Receive OpenMessage")
                SendOPMsg(c)
            elseif t[19] == 4 then
                print("Receive KeepAlive")
                SendKeepAlive(c)
            end
        end
    end
end

copas.loop()


