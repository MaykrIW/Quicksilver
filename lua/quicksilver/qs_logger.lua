// Even if the Logging function is disabled Quicksilver will still generate the folders.
local timestamp = util.TableToJSON({type="START/RESTART",data="[QS]: SERVER START/RESTART "..QS.ServerStartDate.." @ "..QS.ServerStartTime})

file.CreateDir("quicksilver/logs/system","DATA")
file.CreateDir("quicksilver/logs/player","DATA")
file.CreateDir("quicksilver/logs/build","DATA")
file.CreateDir("quicksilver/logs/extenstions","DATA")
if QS.CFG.Log.SYS.disk then
    file.Append("quicksilver/logs/system".."/"..QS.ServerStartDate.."-system_log.txt",timestamp.."\n")
end
if QS.CFG.Log.PLY.disk then
    file.Append("quicksilver/logs/player".."/"..QS.ServerStartDate.."-player_log.txt",timestamp.."\n")
end
if QS.CFG.Log.BLD.disk then
    file.Append("quicksilver/logs/build".."/"..QS.ServerStartDate.."-build_log.txt",timestamp.."\n")
end
if QS.CFG.Log.EXT.disk then
    file.Append("quicksilver/logs/extenstions".."/"..QS.ServerStartDate.."-extenstions_log.txt",timestamp.."\n")
end

--[[------------------------------------------------------------------------
    Types:  SYS or sys = System
            :: Calls from core or library functions within Quicksilver
            :: DO NOT USE IN EXTENTIONS, EXCEPT VERY RARE CIRCUMSTANCES 
            PLY or ply = Player
            :: All events related to player action 
               spawn, death, kill, chat)
            BLD or bld = Build
            :: Prop Spawn/Destroy/Delete, Tool Gun, Etc
            EXT or ext = Extentions
            :: Used by extentison to log all information that does not fit PLY or BLD

    Data:   Data can contain string, numbers, tables, json
            :: When data contains a tabl
            
            --------------------------------------------------------------------------]]
--[[------------------------------------------------------------------------
	Name: WriteDisk(table) // Local Function
    
	Desc: Internal Command for the logging system. Writes to the associated
          log folder.

    Args: path      - Where the file will be written 
                      (within the quicksilver/logs folder)
          writeData - table passed from the QS.Log function. Same data requirements
--------------------------------------------------------------------------]]
local function WriteDisk(path,writeData)
    writeData.date=os.date("%Y-%m-%d")
    writeData.time=os.date("%H:%M:%S")

    local wd = {date=writeData.date, time=writeData.time,caller=writeData.caller,data=writeData.data}
    file.Append("quicksilver/logs/".. path .."/"..QS.ServerStartDate.."-system_log.txt",util.TableToJSON(wd)..",\n")
    return true
end

--[[------------------------------------------------------------------------
	Name: WriteConsole(table) // Local Function

	Desc: Internal Command for the logging system. Handles the formatting
          and colors for output to the console.

    Args: printData - table passed from QS.Log function. Same data requirements
--------------------------------------------------------------------------]]
local function WriteConsole(printData) // Prints to the console, Keeping the name inline with WriteDisk...

    local typeString = ""
    local logColor = Color(0,0,0)
    if string.lower(printData.type) == "sys" then   
        typeString = "SYSTEM_LOG"
        logColor = QS.Color.SUCCESS
    elseif string.lower(printData.type) == "ply" then
        typeString = "PLAYER_LOG"
        logColor = Color(0,255,187)
    elseif string.lower(printData.type) == "bld" then
        typeString = "BUILD_LOG"
        logColor = Color(168,168,168)
    elseif string.lower(printData.type) == "ext" then
        typeString = "EXT_LOG"
        logColor = Color(252,129,234)
    end
    
    MsgC(
        QS.Color.PRIMARY, "[QS]: ",
        logColor, typeString,
        QS.Color.INFO, os.date(" %Y-%m-%d"),
        QS.Color.WARN, " @ ",
        QS.Color.INFO, os.date("%H:%M "),
        //QS.Color.WARN, "Caller=",
        //QS.Color.INFO, (printData.caller or "None") ..", ",
        QS.Color.WARN,"// ",
        QS.Color.INFO, 
        ((type(printData.data) == "table" and util.TableToJSON(printData.data)) or printData.data)
        .."\n")

    return true
end

--[[------------------------------------------------------------------------
	Name: Log(table)

	Desc: Instead of using the print/msg/msgc commands directly call QS.Log()
          takes a table with the minimum required fields of type and data.
          Return back the same table passed in, enabling inline useage of
          the function while still logging it all!

    Args: T - Where the file will be written (within the quicksilver/logs folder)
------------------------------------------------------------------------]]--
function QS.Log( logData )
    //if !QS.CFG.Log.ENABLED then return logData end
    if type(logData) != "table" then error("\n>> Logger expected: TABLE. got " .. string.upper(type(logData)) .. "") end
    if !logData.data then error("\n>> Table passed to Logger did not contain data value") end

    if string.lower(logData.type) == "sys" then 
        _ = (QS.CFG.Log.SYS.console and WriteConsole(logData))
        _ = (QS.CFG.Log.SYS.disk and WriteDisk("system", logData))   

    elseif string.lower(logData.type) == "ply" then
        _ = (QS.CFG.Log.PLY.console and WriteConsole(logData))
        _ = (QS.CFG.Log.PLY.disk and WriteDisk("player", logData))   

    elseif string.lower(logData.type) == "bld" then
        _ = (QS.CFG.Log.BLD.console and WriteConsole(logData))
        _ = (QS.CFG.Log.BLD.disk and WriteDisk("build", logData)) 

    elseif string.lower(logData.type) == "ext" then
        _ = (QS.CFG.Log.EXT.console and WriteConsole(logData))
        _ = (QS.CFG.Log.EXT.disk and WriteDisk("extention", logData))

    else
        error("\n>> Table passed to Logger did not contain type and/or value [SYS, PLY, BLD, EXT]")
    end

    return logData
end

// TODO: Add a QS.Broadcast

// TODO:

--[[------------------------------------------------------------------------
	Name: Examples of valid table to pass QS.Log()
    
	table = {
        type = "SYS",
        data = "my cool data",
    }
        OR
    table = {
        type = "BLD",
        data = 123123,
    }
        OR
    table = {
        type = "PLY",
        data = {
            username = "bestGMODplayer7",
            passcode = "superSecurePasscode321", // Don't send passcodes btw...
        },
        caller = player or nil(server)
    }
--------------------------------------------------------------------------]]

local isEnabled = (QS.CFG.Log.ENABLED and "ENABLED") or "DISABLED"
local eStat = " -> ["..
              "CONSOLE=" ..
              ((QS.CFG.Log.SYS.console and "SYS ") or "")..
              ((QS.CFG.Log.PLY.console and "PLY ") or "")..
              ((QS.CFG.Log.BLD.console and "BLD ") or "")..
              ((QS.CFG.Log.EXT.console and "EXT ") or "")..
              ""..
              "| FILE=" .. 
              ((QS.CFG.Log.SYS.disk and "SYS ") or "")..
              ((QS.CFG.Log.PLY.disk and "PLY ") or "")..
              ((QS.CFG.Log.BLD.disk and "BLD ") or "")..
              ((QS.CFG.Log.EXT.disk and "EXT ") or "")..
              "]"

if !QS.CFG.Log.ENABLED then eStat = "" end

MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.INFO,"Logger ",isEnabled,eStat,"\n")