QS.CFG = {
	UseScoreboard = true,
	UseTeams = true,
	TeamOffset = 5000, // Used to represent joining/disconnect/etc non standard state
	UseRankTime = true,
	Log  = {
		// Disables entire logging system, ignore subsystem settings.
		ENABLED = true, 
		// Auto Purge removes old log files that exceed lifespan
		AUTO_PURGE = {
			enabled = true,
			lifespan = 7, // Days
		},
		// Console = writing to the servers console output
		// Disk    = writing to the associated file on disk
		SYS = { // System
			console = true,
			disk 	= false,
		},
		PLY = {	// Player
			console = false,
			disk 	= false,
		},
		BLD = { // Build
			console = false,
			disk 	= false,
		},
		EXT = { // Extensions
			console = false,
			disk 	= false,
		}
	}
	// Track enabled/disabled extentions
	// EnabledExtension = {},
}

if SERVER then 
	MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.WARN, "Checking for CONFIG file... ")
	local conf = file.Read("quicksilver/config.txt","DATA")
	if conf and conf != "" then 
		MsgC(QS.Color.INFO,"OK \n")

		local json = util.JSONToTable(conf)
		for k,v in pairs(json) do
				QS.CFG[k] = v
		end
	else
		MsgC(QS.Color.ERROR,"NONE\n")
		MsgC(QS.Color.PRIMARY, "[QS]: ", QS.Color.WARN,"Creating new CONFIG file... ")
		conf = util.TableToJSON(QS.CFG,true)
		file.Write("quicksilver/config.txt",conf)
		MsgC(QS.Color.WARN, "OK \n")
	end
	
end

//PrintTable(QS.CFG)