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


dofile("readtoml.lua")
dofile("createpacket.lua")

file = io.open("bgp.conf", "r")
string = file:read("*all")
file:close()

config = loadstr(string)

local socket = require("socket")
local copas = require("copas")


local server = assert(socket.bind("*",179))
local client = server:accept()
client:settimeout(1)


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
 
while true do 
    line = client:receive(19)
    print(line:byte(1))
    if line ~= nil then
        t = string2byte(line)
        if t[19] == 1 then
            print("Receive OpenMessage")
            SendOPMsg(client)      
        elseif t[19] == 4 then
            print("Receive KeepAlive")
            SendKeepAlive(client)
        else
            print("type:" .. t[19])
        end
    else
        print("nil")
    end
    
end
    --[[t = string2byte(line)
    for i, ver in ipairs(t) do

--[[copas.addserver(server , function(c) return Handler(c,c:getpeername()) end )

function Handler(c,host,port)
    local peer = host .. ":" .. port
    print("connection form",peer)
    c:settimeout(1)
    --c = copas.wrap(c)
    local rBuf = ""
    print("ok")
    --while true do 
    --local line, err ,rBuf = c:receive("*l",rBuf)
    local line = copas.receive(c)
    copas.send(c,data)
    print("sent data")
    c:close()
    --end
    --print("data from",peer,(c:receive"*a"))
end

copas.loop()
]]--
--[[
local client = assert(socket.connect("172.17.0.4",179))
client:send(data)
sleep(2)
for i=1,10 do 
    local data = CreateKeepAliveMessage(config)
    --local client = assert(socket.connect("172.17.0.4",179))
    local client = assert(socket.connect("172.17.0.4",179))
    client:send(data)
    sleep(3)
end
client:close()
]]--

