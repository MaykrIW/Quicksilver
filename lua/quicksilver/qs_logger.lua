QS.Log = {}
--[[
 _                     _   _              _   _     _                 
| |                   | | | |            | | | |   (_)                
| |     ___   __ _    | |_| |__   ___    | |_| |__  _ _ __   __ _ ___ 
| |    / _ \ / _` |   | __| '_ \ / _ \   | __| '_ \| | '_ \ / _` / __|
| |___| (_) | (_| |   | |_| | | |  __/   | |_| | | | | | | | (_| \__ \
\_____/\___/ \__, |    \__|_| |_|\___|    \__|_| |_|_|_| |_|\__, |___/
              __/ |                                          __/ |    
             |___/                                          |___/     
]]--


// Even if the Logging function is disabled Quicksilver will still generate the folders.
file.CreateDir("quicksilver/logs/system","DATA")
file.CreateDir("quicksilver/logs/player","DATA")
file.CreateDir("quicksilver/logs/build","DATA")
file.CreateDir("quicksilver/logs/extenstions","DATA")

--[[------------------------------------------------------------------------
	Name: WriteDisk
    
	Desc: Internal Command for the logging system. Writes to the associated
          log folder.

    Args: path      - Where the file will be written 
                      (within the quicksilver/logs folder)
          writeData - table passed from the QS.Log function. Same data requirements
--------------------------------------------------------------------------]]
local function WriteDisk(path,writeData)
    --[[writeData = string.format(
        "[QS] %s @ %s SYSTEM_LOG, C=%s, D=%s \n",
        os.date("%Y-%m-%d"), 
        os.date("%H:%M"),
        writeData.caller or "NONE",
        // I fucking hate this btw. Ternary  operator in LUA
        (type(writeData.data) == "table" and util.TableToJSON(writeData.data)) or writeData.data
    )]]--
    writeData.date=os.date("%Y-%m-%d")
    writeData.time=os.date("%H:%M")

    local wd = {date=writeData.date, time=writeData.time,caller=writeData.caller,data=writeData.data}

    file.Append("quicksilver/logs/".. path .."/"..QS.ServerStartDate.."-system_log.txt",util.TableToJSON(wd)..",\n")
    
    //file.Append("quicksilver/logs/".. path .."/"..QS.ServerStartDate.."-system_log.txt",writeData)    
    return true
end

--[[------------------------------------------------------------------------
	Name: WriteConsole

	Desc: Internal Command for the logging system. Handles the formatting
          and colors for output to the console.

    Args: printData - table passed from QS.Log function. Same data requirements
--------------------------------------------------------------------------]]
local function WriteConsole(printData) // Prints to the console, Keeping the name inline with WriteDisk...

    local typeString = ""
    local logColor = Color(0,0,0)
    if printData.type == "SYS" then   
        typeString = "SYSTEM_LOG"
        logColor = QS.Color.SUCCESS
    elseif printData.type == "PLY" then
        typeString = "PLAYER_LOG"
        logColor = Color(0,255,187)
    elseif printData.type == "BLD" then
        typeString = "BUILD_LOG"
        logColor = Color(168,168,168)
    elseif printData.type == "EXT" then
        typeString = "EXT_LOG"
        logColor = Color(252,129,234)
    end
    
    MsgC(QS.Color.PRIMARY, "[QS] ",
         QS.Color.WARN, os.date("%Y-%m-%d "),
         QS.Color.INFO, "@",
         QS.Color.WARN, os.date(" %H:%M "),
         logColor, typeString,
         QS.Color.WARN, ", Caller",
         QS.Color.INFO, "= ".. (printData.caller or "NONE") ..", ",
         QS.Color.WARN,"Data",
         QS.Color.INFO,"= ".. 
         ((type(printData.data) == "table" and util.TableToJSON(printData.data)) or printData.data)
         .."\n")

    return true
end

--[[------------------------------------------------------------------------
	Name: QS.Log

	Desc: Instead of using the print/msg/msgc commands directly call QS.Log()
          takes a table with the minimum required fields of type and data.
          Return back the same table passed in, enabling inline useage of
          the function while still logging it all!

    Args: t      - Where the file will be written 
                      (within the quicksilver/logs folder)
--------------------------------------------------------------------------]]
function QS.Log( logData )
    if !QS.Config.Log.ENABLED then return logData end
    if type(logData) != "table" then error("\n>>. Logger expected: TABLE. got " .. string.upper(type(logData)) .. "") end
    if !logData.data then error("\n>> Table passed to Logger did not contain data value") end

    if logData.type == "SYS" then
        _ = (QS.Config.Log.SYS.console and WriteConsole(logData))
        _ = (QS.Config.Log.SYS.disk and WriteDisk("system", logData))        
    elseif logData.type == "PLY" then
        _ = (QS.Config.Log.PLY.console and WriteConsole(logData))
        _ = (QS.Config.Log.PLY.disk and WriteDisk("player", logData))   
    elseif logData.type == "BLD" then
        _ = (QS.Config.Log.BLD.console and WriteConsole(logData))
        _ = (QS.Config.Log.BLD.disk and WriteDisk("build", logData))   
    elseif logData.type == "EXT" then
        _ = (QS.Config.Log.EXT.console and WriteConsole(logData))
        _ = (QS.Config.Log.EXT.disk and WriteDisk("extention", logData))
    else
        error("\n>> Table passed to Logger did not contain type and/or value [SYS, PLY, BLD, EXT]")
    end

    return logData
end

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
            passcode = "superSecurePasscode321",
        },
        caller = player or nil(server)
    }
--------------------------------------------------------------------------]]


QS.Log({type="SYS",data="asdfasfsadf"})