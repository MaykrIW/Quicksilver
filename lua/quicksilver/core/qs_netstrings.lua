//  (Did you forget to call util.AddNetworkString serverside?)

local NetStrings = {
	"QS:ChatPrint",
}

for k,v in pairs(NetStrings) do 
	util.AddNetworkString(v)
end