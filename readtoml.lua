
function split(line,delim)
    local ret = {}
    local pat = "[^" .. delim .. "]+"
    local i = 1
    for group in string.gmatch(line, pat) do
        ret[i] = group
        i = i + 1
    end
    return ret
end

function loadstr(str)
    InLabel = {}
    InLabelArray = {}
    ret = {}
    Label = ret
    ArrayTable = 0
    count = 0
    for line in string.gmatch(str,"[^\n]+") do
        line = string.format( "%s", line:match( "^%s*(.-)%s*$" )) 
        if string.sub(line,1,1) == "[" then
            if string.sub(line,1,2) == "[[" then
                ArrayTable = 1
                line = string.sub(line,3,#line -2) 
                if InLabelArray[line] == nil then 
                    InLabelArray[line] = true
                    count = 0
                end
            else
                line = string.sub(line,2,#line -1) 
                ArrayTable = 0
            end
            Label = ret
            arrays = split(line,".")
            for i, value in pairs(arrays) do
                if Label[value] ~= nil then --if in the value
                    if i == table.maxn(arrays) then
                        if InLabel[value] ~= nil then
                            InLabel[value] = nil
                        else
                            print("double")
                        end
                    end
                else
                    if i ~= table.maxn(arrays) then
                        InLabel[value] = true
                    end
                    Label[value] = {} 
                end
                Label = Label[value]
            end
            if ArrayTable == 1 then
                count = count + 1
                Label[count] = {}
            end 
        elseif line:match("=") ~= nil then
            formula = split(line,"=")
            formula[1] = string.format( "%s", formula[1]:match( "^%s*(.-)%s*$" )) 
            formula[2] = string.format( "%s", formula[2]:match( "^%s*(.-)%s*$" )) 
            if ArrayTable == 1 then
                Label[count][formula[1]]=formula[2]
            else
                Label[formula[1]]=formula[2]
            end
        end
    end
    return ret
end
