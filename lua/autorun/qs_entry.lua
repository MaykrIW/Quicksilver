QS = {} // Quicksilver
QS.Config = {}
QS.ProjectName = "quicksilver-admin-mod"
QS.Version = "ALPHA v0.1"
QS.Running = false
Col = { // Default hard coded colors'
    BRAND   = Color(0,168,214),
    INFO    = Color(255,255,255),
    WARN    = Color(255,255,0),
    ERROR   = Color(155,0,0),
}

if SERVER then AddCSLuaFile("quicksilver/config.lua") end
include("quicksilver/config.lua")

// Tagging func borrowed from Mercury
function qtag() 
    MsgC(Col.BRAND, "[QS]: ")
end

qtag() MsgC(Col.INFO, "Starting Quicksilver... \n")

if SERVER then
    qtag() MsgC(Col.INFO, "Checking for DATA folder... ")
    if !file.Exists(QS.ProjectName, "DATA") then
        MsgC(Col.WARN, "NONE, creating folder \n")
        file.CreateDir(QS.ProjectName)
    else
        MsgC(Col.INFO, "OK \n")
    end







end // End Server

