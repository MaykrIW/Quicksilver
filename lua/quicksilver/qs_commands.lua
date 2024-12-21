QS.CMDS = {}
QS.CMDS.CommandTable = {}

--[[
Overview of the privilage system and Overview of the restrictions system 

Commands are loaded before ranks. This ensures the global 

QS.Privilage = {
    "teleport" = 0 // Value doesn't matter, just needs set to keep index populated in the table

}

Example commands registration format

["kick"] = {
    permission = "admin.kick",
    handler = function(caller, args)
        -- Logic for the "kick" command
        print(caller .. " executed kick with args: " .. args)
    end
},
["ban"] = {
    permission = "admin.ban",
    handler = function(caller, args)
        -- Logic for the "ban" command
        print(caller .. " executed ban with args: " .. args)
    end
}
]]--

--[[

function QS.CMDS.Register() end
function QS.CMDS.Unregister() end

function QS.CMDS.() end

]]--
