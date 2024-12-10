QS.Config = {
	UseScoreboard = true,
	UseTeams = true,
	TeamOffset = 0, // Used to represent joining/disconnect/etc non standard state
	UseRankTime = true,

	// Track enabled/disabled extentions
	// EnabledPackages = {},
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

