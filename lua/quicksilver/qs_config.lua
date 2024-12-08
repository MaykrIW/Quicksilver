QS.Config = {
	UseScoreboard = true,
	UseTeams = true,
	TeamOffset = 0, // ???
	UseRankTime = true,

	Colors = {
        //Primary color used for Quicksilver
        BRAND   = Color(0,168,214),
        INFO    = Color(255,255,255),
        WARN    = Color(255,255,0),
        ERROR   = Color(155,0,0),
    },

	//EnabledPackages = {},
}

if SERVER then 
	local data = file.Read("quicksilver/qs_config.txt","DATA")
	if !data then
		qtag() MsgC(QS.Config.Colors.INFO, "config.txt not found, creating file \n")
		local data = util.TableToJSON(QS.Config)
        file.Write("quicksilver/qs_config.txt", data)
	else
		qtag() MsgC(QS.Config.Colors.INFO, "Loaded Config \n")
		local data = util.JSONToTable(data)
		for k,v in pairs(data) do
				QS.Config[k] = v
		end
	end
end

if CLIENT then
	// TODO: After verifying this works, try to remove the hook and call the function only
	hook.Add("HUDPaint","QSGetConfig",function()

		net.Start("QS:Config")
		net.WriteString("GET_CONFIG")
		net.WriteTable({})
		net.SendToServer()
		
		hook.Remove("HUDPaint","QSGetConfig")
	end) 

	net.Receive("QS:Config",function()
		local cmd = net.ReadString()
		local args = net.ReadTable()
		if cmd=="SendConfig" then 
			QS.Config = args
			qtag() print("ConfigRecieved")
			QS.ModHook.Call("ConfigRecieved")
		end
	end)
end

