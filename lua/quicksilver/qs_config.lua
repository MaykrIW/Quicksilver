QS.Config = {
	UseScoreboard = true,
	UseTeams = true,
	TeamOffset = 0, // Used to represent joining/disconnect/etc non standard state
	UseRankTime = true,
	Log  = {
		// Disables entire logging system, ignore subsystem settings.
		ENABLED = false, 
		// Auto Purge removes old log files that exceed lifespan
		AUTO_PURGE = {
			enabled = true,
			lifespan = 7, // Days
		},
		// Console = writing to the servers console output
		// Disk    = writing to the associated file on disk
		SYS = { // System
			console = true,
			disk 	= true,
		},
		PLY = {	// Player
			console = true,
			disk 	= false,
		},
		BLD = { // Build
			console = true,
			disk 	= false,
		},
		EXT = { // Extensions
			console = true,
			disk 	= false,
		}
	}
	// Track enabled/disabled extentions
	// EnabledExtension = {},
}

if SERVER then 
	local data = file.Read("quicksilver/qs_config.txt","DATA")
	if !data then
		qsTag() MsgC(QS.Color.INFO, "config.txt not found, creating file \n")
		local data = util.TableToJSON(QS.Config)
        file.Write("quicksilver/qs_config.txt", data)
	else
		qsTag() MsgC(QS.Color.INFO, "Loaded Config \n")
		local data = util.JSONToTable(data)
		for k,v in pairs(data) do
				QS.Config[k] = v
		end
	end
end

if CLIENT then

end

