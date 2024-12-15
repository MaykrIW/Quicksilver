QS.CFG = {
	UseScoreboard = true,
	UseTeams = true,
	TeamOffset = 0, // Used to represent joining/disconnect/etc non standard state
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