QS = {} // Quicksilver
QS.Version = "ALPHA v0.1"
QS.Config = {}

// Tagging func borrowed from Mercury
function qsTag() 
    MsgC(Color(0,168,214), "[QS]: ")
end

qsTag() MsgC(Color(0,168,214), "Starting Quicksilver... \n")

if SERVER then AddCSLuaFile("quicksilver/qs_config.lua") end
include("quicksilver/qs_config.lua")


qsTag() MsgC(QS.Config.Colors.INFO, "Starting Quicksilver... \n")


if SERVER then
    qsTag() MsgC(QS.Config.Colors.INFO, "Checking for DATA folder... ")
    if !file.Exists("quicksilver", "DATA") then
        MsgC(QS.Config.Colors.WARN, "NONE, creating folder \n")
        file.CreateDir("quicksilver")
    else
        MsgC(QS.Config.Colors.WARN, "OK \n")
    end

    AddCSLuaFile() // Make sure this file makes it's way to the client

    //Load libraries first, as loading them after the core would break.
    for _, libFile in pairs(file.Find("quicksilver/lib/*.lua", "LUA")) do
        local success, err = pcall(function()
            include("quicksilver/lib/" .. libFile)
        end)
        if !success then
            qsTag() Msg("[QS]: " .. err  .. "\n")
            break 
        end
        qsTag() Msg("Loaded lib/" .. libFile .. "\n")
    end
    //Load core files
    for _, coreFile in pairs(file.Find("quicksilver/core/*.lua", "LUA")) do
        local success, err = pcall(function()
            include("quicksilver/core/" .. coreFile)
        end)
        if !success then
            qsTag() Msg("[QS]: " .. err  .. "\n")
            break
        end
        qsTag() Msg("Loaded core/" .. coreFile  .. "\n")
    end



end



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



qsTag() MsgC(Color(75,181,67) , "Quicksilver has full loaded! \n \n \n \n \n")