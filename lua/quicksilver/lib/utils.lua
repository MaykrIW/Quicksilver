QS.Utils = {}

--[[------------------------------------------------------------------------
	Name: QS.Utils.ReadOnly

	Desc: Wrap around any Table and get a read-only Table back
          Does not modify and existing table. Only returns a new modified copy
--------------------------------------------------------------------------]]
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