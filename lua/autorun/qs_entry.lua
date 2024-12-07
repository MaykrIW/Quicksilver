QS = {} // Quicksilver
QS.Version = "ALPHA v0.1"
QS.Config = {}

if SERVER then AddCSLuaFile("quicksilver/qs_config.lua") end
include("quicksilver/qs_config.lua")


// Tagging func borrowed from Mercury
function qtag() 
    MsgC(QS.Config.Colors.BRAND, "[QS]: ")
end

qtag() MsgC(QS.Config.Colors.INFO, "Starting Quicksilver... \n")

if SERVER then

    qtag() MsgC(QS.Config.Colors.INFO, "Checking for DATA folder... ")
    if !file.Exists("quicksilver-admin-mod", "DATA") then
        MsgC(QS.Config.Colors.WARN, "NONE, creating folder \n")
        file.CreateDir("quicksilver-admin-mod")
    else
        MsgC(QS.Config.Colors.INFO, "OK \n")
    end

    //Load Core Files
    for _,f in pairs(file.Find("quicksilver-admin-mod/core/*.lua","LUA")) do
		local S,ER = pcall(function() include("quicksilver-admin-mod/core/" .. f) end)
		if (S) then qtag() print("Loaded: " .. f .. "\n") else
			qtag() Msg(ER)
		end
	end
end // End Server

if CLIENT then

	for _,f in pairs(file.Find("quicksilver/client/*.lua","LUA")) do
		local S,ER =	pcall(function() include("quicksilver/client/" .. f) end) 
		if (S) then qtag() print("Pushed CLIENT: " .. f  .. "\n") else
            qtag() print("Loaded: " .. f .. "\n")
		end
	end


end