QS = {} // Quicksilver
QS.Version = "ALPHA v0.1.0"
QS.Config = {}

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
function qsTag() 
    MsgC(QS.Color.PRIMARY, "[QS]: ")
end

qsTag() MsgC(QS.Color.PRIMARY, "Starting Quicksilver... \n")

//if SERVER then AddCSLuaFile("quicksilver/qs_config.lua") end

// Load library files
if SERVER then
    // Load / Create Data folder
    qsTag() MsgC(QS.Color.INFO, "Checking for DATA folder... ")
    if !file.Exists("quicksilver", "DATA") then
            MsgC(QS.Color.WARN, "NONE, creating folder \n")
            file.CreateDir("quicksilver")
        else
            MsgC(QS.Color.INFO, "OK \n")
        end
    // Load Config
    include("quicksilver/qs_config.lua")
    // Load Logger
    include("quicksilver/qs_logger.lua")
    // Load Librarys
    for _, libFile in pairs(file.Find("quicksilver/lib/*.lua", "LUA")) do
        local success, error = pcall(function()
            include("quicksilver/lib/" .. libFile)
        end)
        if !success then
            qsTag() Msg("[QS]: " .. error  .. "\n")
            break 
        end
        qsTag() Msg("Loaded lib/" .. libFile .. "\n")
    end
end



if CLIENT then

	--[[for _,f in pairs(file.Find("quicksilver/client/*.lua","LUA")) do
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
 

    ]]--
end



qsTag() MsgC(QS.Color.SUCCESS, "Quicksilver has full loaded! \n \n \n \n \n")