QS = {} // Quicksilver
QS.Version = "ALPHA v0.1"
QS.Config = {}

if SERVER then AddCSLuaFile("quicksilver/qs_config.lua") end
include("quicksilver/qs_config.lua")


// Tagging func borrowed from Mercury
function qsTag() 
    MsgC(QS.Config.Colors.BRAND, "[QS]: ")
end

qsTag() MsgC(QS.Config.Colors.INFO, "Starting Quicksilver... \n")


if SERVER then

    qsTag() MsgC(QS.Config.Colors.INFO, "Checking for DATA folder... ")
    if !file.Exists("quicksilver", "DATA") then
        MsgC(QS.Config.Colors.WARN, "NONE, creating folder \n")
        file.CreateDir("quicksilver")
    else
        MsgC(QS.Config.Colors.INFO, "OK \n")
    end


    include("quicksilver/core/qs_utils.lua")
    //Load Core Files
    // Core File will need to be converted to a hardcoded load order
    // to ensure that things will always work
    --[[
    for _,f in pairs(file.Find("quicksilver/core/*.lua","LUA")) do
		local S,ER = pcall(function() include("quicksilver/core/" .. f) end)
		if (S) then qsTag() print("CORE: " .. f .. "") else
			qsTag() Msg(ER)
		end
	end
    // Initialize the Logger
    //QS.Logger.Settings = QS.Config.Logger.Settings
    ]]--
    // Load Commands


end



if CLIENT then

	for _,f in pairs(file.Find("quicksilver/client/*.lua","LUA")) do
		local S,ER =	pcall(function() include("quicksilver/client/" .. f) end) 
		if (S) then qsTag() print("Pushed CLIENT: " .. f  .. "\n") else
            qsTag() print("Loaded: " .. f .. "\n")
		end
	end
end



qsTag() MsgC(QS.Config.Colors.INFO, "Quicksilver has full loaded! \n")