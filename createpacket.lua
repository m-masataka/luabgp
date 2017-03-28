local function string2byte(data)
    local i = 1
    local t = {}
    for i = 1, string.len(data) do 
        t[i] = data:byte(i)
    end
    return t
end

function string.fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

function ip_to_hex(ip)
    local array = {}
    array = split(ip,".")
    for i,v in pairs(array) do
        array[i] = string.format("%x", tonumber(v) * 256)
        while #array[i] ~= 4 do
           array[i] = "0" .. array[i] 
        end
        array[i] = string.sub(array[i],1,#array[i]-2)
    end
    ret = array[1] .. array[2] .. array[3] .. array[4]
    return ret
end

function zero_padding(str, size)
    while size > #str do
        str = "0" .. str
    end
    return str
end 

function CreateKeepAliveMessage(conf)
    local Marker = ("ffffffffffffffffffffffffffffffff"):fromhex()
    local Length = Marker .. ("0013"):fromhex()
    local MessageType = Length .. ("04"):fromhex()
    local data = MessageType
    return data
end 

function CreateOpenMessage(conf)
    local Marker = ("ffffffffffffffffffffffffffffffff"):fromhex()
    local Length = Marker ..  ("0035"):fromhex()
    local MessageType = Length .. ("01"):fromhex()
    local Version = MessageType .. ("04"):fromhex()
    -- AS No
    temp_str = string.format("%x", tonumber(conf.Global.GlobalConfig.As) * 256)
    temp_str = string.sub(temp_str,1,#temp_str-2)
    temp_str = zero_padding(temp_str,4)
    local MyAS = Version .. (temp_str):fromhex()
    t = string2byte(MyAS)
    -- HoldTime
    temp_str = string.format("%x", tonumber(conf.Global.GlobalConfig.HoldTime) * 256)
    temp_str = string.sub(temp_str,1,#temp_str-2)
    temp_str = zero_padding(temp_str,4)
    local HoldTime = MyAS .. (temp_str):fromhex()
    -- IP
    temp_str = conf.Global.GlobalConfig.RouterId
    temp_str = string.sub(temp_str,2,#temp_str-1)
    temp_str = ip_to_hex(temp_str)
    local BGPIdentifier = HoldTime .. (temp_str):fromhex()
    -- IP
    local OPLen = BGPIdentifier .. ("18"):fromhex()
    local OPpara1 =  OPLen .. ("0206010400010001"):fromhex()
    local OPpara2 = OPpara1 .. ("02028000"):fromhex()
    local OPpara3 = OPpara2 .. ("02020200"):fromhex()
    local OPpara4 = OPpara3 .. ("020641040000"):fromhex()
    temp_str = string.format("%x", tonumber(conf.Global.GlobalConfig.As) * 256)
    temp_str = string.sub(temp_str,1,#temp_str-2)
    temp_str = zero_padding(temp_str,4)
    local OPpara5 = OPpara4 .. (temp_str):fromhex()
    local data = OPpara5 
    return data
end



