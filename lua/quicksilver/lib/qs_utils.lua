QS.Utils = {}


--[[
Name:   ReadOnly
Args:   Table
Return: Read-only Table
Desc:   Take a table and modifies it to be read-only.
]]--
function QS.Utils.ReadOnly (t)
    local proxy = {}
    local mt = {-- create metatable
    __index = t,
    __newindex = function (...)
        error("\n>> Attempt to update a read-only table", 2)
    end
    }
    setmetatable(proxy, mt)
    return proxy
 end