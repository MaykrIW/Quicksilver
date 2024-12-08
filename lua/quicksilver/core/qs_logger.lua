// Logging func. Will require settings from config to be passed 
// Useing this while I build up the logging framework
// Migrate to using the config file
QS.Log = {
    Settings = {
        logging = true,
        commands = true,
    }
}
// If logging is disabled notify and return
if !QS.Log.Settings.logging then qsTag() MsgC(QS.Config.Colors.INFO, "Logging disabled in Config\n") return end

if not file.IsDir("quicksilver/logs/commands", "DATA") then
    file.CreateDir("quicksilver/logs/commands")
end

if QS.Log.Settings.commands then
    if file.Exists("quicksilver/logs/commands/" .. QS.Utils.GetDateString() .. ".txt", "DATA") then
		qsTag() print("Commands log file exists, continuing")
	else
		file.Write("quicksilver/logs/commands/" .. QS.Utils.GetDateString() .. ".txt", "===== " .. QS.Utils.GetDateString() .. " Command Log =====\n")
		qsTag() print("Creating Commands log file")
	end
end





