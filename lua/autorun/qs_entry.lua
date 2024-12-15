QS = {} // Quicksilver
QS.Version = "ALPHA v0.2.0"
QS.Config = {}
QS.ServerStartDate = os.date("%Y-%m-%d")
QS.ServerStartTime = os.date("%H%M")
//print(QS.ServerStartTime)
// Standard color values
QS.Color = {
    INFO    = Color(255,255,255),
    WARN    = Color(255,255,0),
    ERROR   = Color(155,0,0),
	SUCCESS = Color(19,161,14),
    PRIMARY = Color(0,168,214),
}
// Tagging Function yoinked from Mercury
// Used until the logger is loaded


MsgC(QS.Color.PRIMARY, "[QS]: ", "Starting Quicksilver.... \n")
MsgC(QS.Color.PRIMARY, "[QS]: ", os.date("%Y-%m-%d") .. " | Time: " .. os.date("%H:%M") .. "\n")

//if SERVER then AddCSLuaFile("quicksilver/qs_config.lua") end

// Load library files
if SERVER then
    // Load/Create Data folder
    MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.INFO, "Checking for DATA folder... ")
    if !file.Exists("quicksilver", "DATA") then
            MsgC(QS.Color.WARN, "NONE, creating folder \n")
            file.CreateDir("quicksilver")
        else
            MsgC(QS.Color.INFO, "OK \n")
        end
    // Load Config and Launch the logger
    //include("quicksilver/qs_config.lua")
    //include("quicksilver/qs_logger.lua")

    // Load Librarys
    for _, libFile in pairs(file.Find("quicksilver/lib/*.lua", "LUA")) do
        local success, error = pcall(function()
            include("quicksilver/lib/" .. libFile)
            AddCSLuaFile("quicksilver/lib/" .. libFile)
        end)
        if !success then
            MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.ERROR,"Failed to load: lib/" .. libFile .."\n")
            break 
        end
        MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.INFO,"Loaded/Sent: lib/" .. libFile .. "\n")
    end

    // Load Core
    for _, coreFile in pairs(file.Find("quicksilver/core/*.lua", "LUA")) do
        local success, error = pcall(function()
            include("quicksilver/core/" .. coreFile)
        end)
        if !success then
            MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.ERROR,"Failed to load: core/" .. coreFile .."\n")
            break 
        end
        MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.INFO,"Loaded: core/" .. coreFile .. "\n")
    end
end

// IMPORTANT // DO NOT HOT RELOAD CORE or LIB


if CLIENT then

	for _,f in pairs(file.Find("quicksilver/client/*.lua","LUA")) do
		local S,ER =	pcall(function() include("quicksilver/client/" .. f) end) 
		if (S) then qsTag() print("Loaded CLIENT: " .. f  .. "\n") else
            qsTag() print("Loaded: " .. f .. "\n")
		end
	end


    -- This function listens for the net message from the server
    net.Receive("QS:ChatPrint", function()
        local msg = net.ReadTable()
        chat.AddText(Color(255, 0, 0), "Server: " .. msg.msg)
    end)
 

    
end

//PrintTable(QS)

MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.SUCCESS, "Quicksilver has full loaded! \n \n \n \n \n")