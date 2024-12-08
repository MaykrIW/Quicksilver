QS.Ranks = {}
QS.Ranks.Table = { }
local x = 1
local rankTemplate = {
    //index = "template_idx",
    //title = "template",
    //color = Color(255,255,255),
    //order = "-1",
    //isAdmin = false, 
    //isSuperAdmin = false,
    //isImmune = false,
    //targetOthers = false,
    //privileges = {""},
}

qsTag() MsgC(QS.Config.Colors.INFO, "Checking for RANK folder... ")
if !file.Exists("quicksilver/ranks","DATA") then
	MsgC(QS.Config.Colors.WARN, "NONE, creating folder \n")
	file.CreateDir("quicksilver/ranks") 
	else
        MsgC(QS.Config.Colors.WARN, "OK \n")
end




--[[


* Index -  
* Title - 
* Color - 
* Order -

]]--