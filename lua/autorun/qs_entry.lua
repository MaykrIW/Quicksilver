QS = {} // Quicksilver
QS.Version = "ALPHA v0.2.0"
QS.Config = {}
QS.ServerStartDate = os.date("%Y-%m-%d")
QS.ServerStartTime = os.date("%H%M")

QS.Color = {
    INFO    = Color(255,255,255),
    WARN    = Color(255,255,0),
    ERROR   = Color(155,0,0),
	SUCCESS = Color(19,161,14),
    PRIMARY = Color(0,168,214),
}


MsgC(QS.Color.PRIMARY, "[QS]: ", "Starting Quicksilver.... \n")
MsgC(QS.Color.PRIMARY, "[QS]: ", os.date("%Y-%m-%d") .. " | Time: " .. os.date("%H:%M") .. "\n")

//if SERVER then AddCSLuaFile("quicksilver/qs_config.lua") end

// Load library files
if SERVER then
    // Load/Create Data folder
    MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.WARN, "Checking for DATA folder... ")
    if !file.Exists("quicksilver", "DATA") then
            MsgC(QS.Color.ERROR, "NONE\n")
            MsgC(QS.Color.PRIMARY, "[QS]: ", QS.Color.WARN,"Creating new DATA folder... ")
            file.CreateDir("quicksilver")
            MsgC(QS.Color.WARN,"OK \n")
        else
            MsgC(QS.Color.INFO, "OK \n")
        end
    // Config, Logger
    include("quicksilver/qs_config.lua")
    include("quicksilver/qs_logger.lua")

    // Common Admin Mod Interface
    include("quicksilver/shared/sh_cami.lua")

    // Load Shared (Don't change load order)
    include("quicksilver/qs_ranks.lua")

    // Load Core (Don't change load order)
    // include("quicksilver/*filename*.lua")

    
end

// IMPORTANT // DO NOT HOT RELOAD CORE or LIB


if CLIENT then

	for _,f in pairs(file.Find("quicksilver/client/*.lua","LUA")) do
		local S,ER = pcall(function() include("quicksilver/client/" .. f) end) 
		if (S) then qsTag() print("Loaded CLIENT: " .. f  .. "\n") else
            qsTag() MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.INFO, f, "\n")
		end
	end

    // This function listens for the net message from the server
    net.Receive("QS:ChatPrint", function()
        local msg = net.ReadTable()
        chat.AddText(Color(255, 0, 0), "Server: " .. msg.msg)
    end)
 

    
end


MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.SUCCESS, "Quicksilver has full loaded! \n \n \n \n \n")