QS.Rank = {}
QS.RanksTable = {}



// Rank system is designed to by 1 for 1 compaible with mercury's system
local RankTmpl = {
// Index is stored as the file name / key name
// Index & Title collisions will thrown error
    title = "", // Display name shown on scoreboards
    order = 1, // High number = Higher on scoreboard (top to bottom) and rank list in menu
    color = Color(255,245,133), // Default color is Gray
    superadmin = false, // Used by CAMI, Example: Falcos Prop Protection checks this value to see if player can modify settings
    admin = false, // Same as super admin, but different settings.
    only_target_self = false, // Can the rank target other players with commands
    restrictions = { // Restrict rank from Weapons, Tools, Sents(scripted entities)
        Weaps =  {},
        Tools = {},
        Sents = {}
    },
    privileges = {}, // Commands rank has access to. Example: !goto, !tp, !rcon
    immunity = 1, // Prevents ranks with lower immunity from targeting higher.
}
local RankProps = { // Used to verify correct data types
	color = "table",
	title = "string",
	privileges = "table",
	immunity = "number",
	order = "number",
	admin = "boolean",
	superadmin = "boolean" ,
	only_target_self = "boolean"
}

// Default Ranks are used if the RANKS folder doesn't exist/contain Owner or Guest ranks
// Default Owner rank (has *root permission which gives all access)
local OwnerTmpl = table.Copy(RankTmpl)
OwnerTmpl.title = "Owner"
OwnerTmpl.superadmin = true 
OwnerTmpl.admin = true 
OwnerTmpl.only_target_self = false
OwnerTmpl.immunity = 10000
OwnerTmpl.privileges[1] = "*root"

// Default User rank (can't do anything)
local GuestTmpl = table.Copy(RankTmpl)
GuestTmpl.title = "Guest"
GuestTmpl.superadmin = false  
GuestTmpl.admin = false 
GuestTmpl.only_target_self = true
GuestTmpl.immunity = 1
GuestTmpl.privileges[1] = ""


// Create load ranks function? or only allow updating the table not a full reload?

--[[ 
Check for Ranks Folder and required ranks [default, owner]
Will create required ranks via templates above (don't change)
]]--
MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.WARN, "Checking for RANKS folder... ")
if !file.Exists("quicksilver/ranks","DATA") then
    MsgC(QS.Color.ERROR, "NONE\n")
    // Created folder
    MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.WARN, "Creating RANKS folder and [default, owner] ranks... ") 
	file.CreateDir("quicksilver/ranks")
    MsgC(QS.Color.WARN, "OK \n") 
    // Add Default Ranks [default, owner]
    file.Append("quicksilver/ranks/owner.txt",util.TableToJSON(OwnerTmpl,true))
    file.Append("quicksilver/ranks/guest.txt",util.TableToJSON(GuestTmpl,true))
	else
        MsgC(QS.Color.WARN, "OK \n") 

        if !file.Exists("quicksilver/ranks/owner.txt", "DATA") then 
            file.Append("quicksilver/ranks/owner.txt", util.TableToJSON(OwnerTmpl,true))
        end
        if !file.Exists("quicksilver/ranks/guest.txt", "DATA") then 
            file.Append("quicksilver/ranks/guest.txt",util.TableToJSON(GuestTmpl,true))
        end
        
        for _, rank in pairs(file.Find("quicksilver/ranks/*.txt", "DATA")) do
            local rdata = file.Read("quicksilver/ranks/"..rank)
            QS.RanksTable[string.lower((string.gsub(rank, "%.txt$", "")))] = util.JSONToTable(rdata)
        end
        //PrintTable(QS.RanksTable)
end


--[[------------------------------------------------------------------------
	Name: Rank.Create
	Desc: Internal Command for the logging system. Handles the formatting
          and colors for output to the console.
    Arg1: index - unique name used to represent the rank internally, not the displayed name.
    Arg2: title - display name shown on scoreboard, visible.
    Arg3: color - ranks color. // make this not mandatory?
    ------------------------------------------------------------------------]]--
function QS.Rank.Create(index, title, color) 
    if !index or index == "" then return false, "no index passed" end
    index = string.lower(index)
    if !title or title == "" then return false, "no title passed" end
    if !color then return false, "no color passed" end

    if(file.Exists("quicksilver/ranks/"..index..".txt", "DATA")) then return false, "rank with index already exists" end

    local rtab = table.Copy(RankTmpl)
        table.Merge(rtab,{
            title = title, 
            color = color,
        },true)
    file.Append("quicksilver/ranks/"..index..".txt", util.TableToJSON(rtab,true))

    return true, rtab
end
//print(QS.Rank.Create("test","testname",Color(1,1,1)))


--[[------------------------------------------------------------------------
	Name: Rank.Delete
	Desc: Take a RANK index and deletes it. Deleting "default" & "owner" are blocked actions
    Arg1: index - unique name used to represent the rank internally, not the displayed name.
    ------------------------------------------------------------------------]]--
function QS.Rank.Delete(index)
    if !index or index == ""  then return false, "no index passed" end
    index = string.lower(index)
    if index == "owner" then return false, "unable to delete while server is running" end
    if index == "default" then return false, "unable to delete while server is running" end

    if(!file.Exists("quicksilver/ranks/"..index..".txt", "DATA")) then return false, "rank with index does not exist" end
    file.Delete("quicksilver/ranks/"..index..".txt")
    QS.RanksTable[index] = nil
    return true, "deleted " .. index
end
//print(QS.Rank.Delete("test"))


--[[------------------------------------------------------------------------
	Name: Rank.Copy
	Desc: Take a RANK index and copies it to the new index
    Arg1: index - the ranks to be copies
    Arg2: new_undex - the new index to copy the rank to.
    ------------------------------------------------------------------------]]--
function QS.Rank.Copy(index, new_index) 
    if !index or index == "" then return false, "no index passed" end
    index = string.lower(index)
    if !new_index or new_index == ""  then return false, "no new_index passed" end
    new_index = string.lower(new_index)
    if(!file.Exists("quicksilver/ranks/"..index..".txt", "DATA")) then return false, "rank with index does not exist" end
    if(file.Exists("quicksilver/ranks/"..new_index..".txt", "DATA")) then return false, "rank with new_index already exist" end
    if QS.RanksTable[index] == nil then return false, "index file found, but index not in RanksTable" end
    file.Append("quicksilver/ranks/"..new_index..".txt", util.TableToJSON(QS.RanksTable[index],true))
    return true, "copied "..index.." to "..new_index
end
//print(QS.Rank.Copy("ownerasdf","owner2"))


--[[------------------------------------------------------------------------
	Name: Rank.Save
	Desc: Take a RANK index and saves it to disk
    Arg1: index - the rank to be saved
    ------------------------------------------------------------------------]]--
function QS.Rank.Save(index) 
    if !index or index == "" then return false, "no index passed" end
    index = string.lower(index)
    if QS.RanksTable[index] == nil then return false, "index not in RanksTable" end
    file.Append("quicksilver/ranks/"..index..".txt", util.TableToJSON(QS.RanksTable[index],true))
end



--[[

--function QS.Rank.Create() end
--function QS.Rank.Delete() end
--function QS.Rank.Copy() end

function QS.Rank.Get() end
function QS.Rank.Save() end
function QS.Rank.SaveAll() end

function QS.Rank.SetRestrictions() end
function QS.Rank.GetRestrictions() end
function QS.Rank.HasRestrictions() end

function QS.Rank.GetPrivileges() end
function QS.Rank.SetPrivileges() end
function QS.Rank.HasPrivileges() end

function QS.Rank.SetOrder() end
function QS.Rank.SetTitle() end
function QS.Rank.SetColor() end
function QS.Rank.SetAdmin() end
function QS.Rank.SetImmunity() end
function QS.Rank.SetSuperAdmin() end
function QS.Rank.SetTargetOnlySelf() end

function QS.Rank.Reset() end

]]--


// RANKS FROM MERCURY
// Intending to make QUICKSILVER 1 for 1 compatible with the core Mercury (ranks)
--[[
Owner = {
    order = 1,
    color = Color(255,0,255,93),
    superadmin = false,
    only_target_self = false,
    restrictions = {
        Weaps =  {},
        Tools = {},
        Sents = {}
    },
    privileges = {
        1 = "",
    privileges = {},
    immunity = 10000,
    admin = false,
    title = "Owner"
}

Guest2 = {
    order = 39693,
    color = Color(255,0,255,93),
    superadmin = false,
    only_target_self = true,
    restrictions = {
        Sents = {
            edit_shadows = true,
            combine_mine = true,
            item_ammo_pistol = true,
        },
        Tools = {
            modelmanipulator = true,
            anti_noclip_control = true,
            turret = true,
            wire_simple_explosive = true,
            hoverball = true,
            dynamite = true,
            ignite = true,
            wire_explosive = true,
            leafblower = true,
            wire_turret = true,
            permaprops = true,
            mapret = true,
            coaster_supertool = true,
            vfire = true,
            resizer = true,
        },
        Weaps = {
            weapon_simrepair = true,
            weapon_rpg = true,
            weapon_crossbow = true,
            weapon_shotgun = true,
            weapon_simmines = true,
        },
    },
    privileges = {
        1 = "",
        2 = "freezeall",
        5 = "10-13",
        6 = "weather",
        7 = "redeemkey",
        8 = "menu",
        11 = "myblame",
        12 = "wholag",
        13 = "nolimits",
        14 = "lgo",
        15 = "loclist",
        16 = "goto",
        17 = "bring",
        18 = "tp",
        19 = "return",
        20 = "noclip",
        22 = "revive",
        23 = "unseat",
        24 = "backseat",
        25 = "privacy",
        26 = "cleanup",
        27 = "extinguish",
        28 = "unfreezeall",
        30 = "swap",
        32 = "god",
        33 = "addons"
    },
    immunity: 5.0,
    admin: false,
    title: "guest2"
}
]]--


//MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.INFO,"Ranks loaded\n")