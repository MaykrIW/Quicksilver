QS.Rank = {}
QS.RanksTable = {}


--[[ Licensing Notice
Due to the nature of maintaining compatibility with Mercury ranks (see mercury_license) some aspects of the code below is similar to Mercury's. 
The code below was produced using example rank data generated from a server running Mercury and the "Rank template" and "Rank properties" have been borrowed from Mercury.
]]--

--[[ 
Rank system is designed to by 1 for 1 compaible with mercury's system
Warning: 
- Calling these functions directly is not recommended. Use the registerd commands contained within QCMD (Quicksilver Commands)
    This will ensure permissions / restrictions / immunity is respected. QS.Ranks only implements the functions for managing
    the commands table and saving to disk.
- When modifying ranks make sure to call the save function when done.
- Only Create, Delete, Copy, Save, SaveAll functions write to disk. 
]]--


local RankTmpl = {
// Index is stored as the file name (key name in the table)
// Index collisions will thrown error
    title = "", // Display name shown on scoreboards
    order = 1, // High number = Higher on scoreboard (top to bottom) and rank list in menu
    color = Color(255,245,133), // Default color is Gray
    superadmin = false, // Used by CAMI, Example: Falcos Prop Protection checks this value to see if player can modify addon settings
    admin = false, // Same as superadmin, but different settings.
    only_target_self = false, // Can the rank target other players with commands
    restrictions = { // Restrict rank from Weapons, Tools, Sents(scripted entities)
        Weaps =  {},
        Tools = {},
        Sents = {}
    },
    privileges = {}, // Commands rank has access to. Example: !goto, !tp, !rcon
    immunity = 1, // Prevents ranks with lower immunity from targeting higher (or modifying ranks with higher immunity maybe??).
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
Check for Ranks Folder / ensure required ranks [default, owner] exist
Will create required ranks via templates above (don't change) if missing
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
	Name: Rank.Save
	Desc: Take a RANK index and saves it to disk
    Arg1: string :: index - the rank to be saved
    Returns: bool, status/error message
------------------------------------------------------------------------]]--
function QS.Rank.Save(index)
    if !index or index == "" then return false, "no index passed" end

    index = string.lower(index)

    if QS.RanksTable[index] == nil then return false, "index not in RanksTable" end

    file.Write("quicksilver/ranks/"..index..".txt", util.TableToJSON(QS.RanksTable[index],true))

    return true, "rank index " .. index .. " saved to disk"
end
//print(QS.Rank.Save("owner"))


--[[------------------------------------------------------------------------
	Name: Rank.SaveAll
	Desc: Saves all ranks currently in the RanksTable to disk. (Overwrites)
    Returns: bool
------------------------------------------------------------------------]]--
function QS.Rank.SaveAll() 
    for rank, _ in pairs(QS.RanksTable) do
        QS.Rank.Save(rank)
    end
    return true
end
//QS.Rank.SaveAll()


--[[------------------------------------------------------------------------
	Name: Rank.Create
	Desc: Creates a new rank and inserts into the RanksTable. Returns a copy of new rank (saves to disk)
    Arg1: string :: index - unique name used to represent the rank internally, not the displayed name.
    Arg2: string :: title - display name shown on scoreboard, visible.
    Arg3: color3 :: color - ranks color. (optional argument; defaults to Color(250,255,130))
    Returns: bool, Status/Error message or copy of the rank created
    ------------------------------------------------------------------------]]--
function QS.Rank.Create(index, title, color) 
    if !index or index == "" then return false, "no index passed" end
    if !title or title == "" then return false, "no title passed" end
    if !color then color = Color(250,255,130) end

    index = string.lower(index)

    if QS.RanksTable[index] != nil then return false, "index already exists in RanksTable" end
    if file.Exists("quicksilver/ranks/"..index..".txt", "DATA") then return false, "index already exists in Ranks directory" end
    
    local rtab = table.Copy(RankTmpl)

    table.Merge(rtab,{
        title = title, 
        color = color,
    },true)
    
    QS.RanksTable[index] = rtab
    QS.Rank.Save(index)

    return true, rtab
end
//print(QS.Rank.Create("test","testname"))


--[[------------------------------------------------------------------------
	Name: Rank.Delete
	Desc: Take a RANK index and deletes it. Deleting "default" & "owner" are blocked actions (deletes from disk)
    Arg1: string :: index - unique name used to represent the rank internally, not the displayed name.
    Returns: bool, Status/Error message
    ------------------------------------------------------------------------]]--
function QS.Rank.Delete(index)
    if !index or index == ""  then return false, "no index passed" end
    if index == "owner" then return false, "unable to delete owner while server is running" end
    if index == "default" then return false, "unable to delete default while server is running" end

    index = string.lower(index)

    if !file.Exists("quicksilver/ranks/"..index..".txt", "DATA") then return false, "index does not exist in Ranks directory" end

    file.Delete("quicksilver/ranks/"..index..".txt")
    QS.RanksTable[index] = nil

    return true, "deleted rank " .. index
end
//print(QS.Rank.Delete("test"))


--[[------------------------------------------------------------------------
	Name: Rank.Copy
	Desc: Take a RANK index and copies it to the new index (saves to disk directly)
    Arg1: string :: index - the ranks to be copies
    Arg2: string :: new_undex - the new index to copy the rank to.
    Returns: bool, Status/Error message
    ------------------------------------------------------------------------]]--
function QS.Rank.Copy(index, new_index) 
    if !index or index == "" then return false, "no index passed" end
    if !new_index or new_index == ""  then return false, "no new_index passed" end

    index = string.lower(index)
    new_index = string.lower(new_index)

    if !file.Exists("quicksilver/ranks/"..index..".txt", "DATA") then return false, "index not in Ranks directory" end
    if QS.RanksTable[index] == nil then return false, "index file found, but index not in RanksTable" end
    
    if file.Exists("quicksilver/ranks/"..new_index..".txt", "DATA") then return false, "new_index already exists in Ranks directory" end
    if QS.RanksTable[new_index] != nil then return false, "new_index already in RanksTable" end
    
    file.Append("quicksilver/ranks/"..new_index..".txt", util.TableToJSON(QS.RanksTable[index],true))
    QS.RanksTable[new_index] = index

    return true, "copied rank "..index.." to "..new_index
end
//print(QS.Rank.Copy("owner","owner2"))


--[[------------------------------------------------------------------------
	Name: Rank.Get
	Desc: Take a RANK index and returns the table
    Arg1: string ::index - the rank to be fetched
    Returns: bool, Status/Error or Table
    ------------------------------------------------------------------------]]--
function QS.Rank.Get(index) 
    if !QS.RanksTable[index] then return false, "index not in RanksTable" end
    return true, QS.RanksTable[index]
end
//PrintTable(select(2,QS.Rank.Get("owner")))


--[[------------------------------------------------------------------------
	Name: Rank.GetAll
	Desc: Returns the entire loaded RankTable
    Returns: bool, RanksTable
    ------------------------------------------------------------------------]]--
function QS.Rank.GetAll() 
    return true, QS.RanksTable
end
//PrintTable(select(2,QS.Rank.GetAll()))


--[[------------------------------------------------------------------------
	Name: Rank.SetRestriction
    Desc: Set a restiction on a rank
    Arg1: string :: index - the rank to be modified
    Arg2: string :: restriction - the restriction to be applied 
    Returns: bool, Status/Error message
    ------------------------------------------------------------------------]]--
function QS.Rank.SetRestriction(index, restriction) 
    // Should this handle multiple commands at once or get called recursivly? For not handle individual calls
    if !index or index == "" then return false, "no index passed" end 
    if !restriction or restriction == "" then return false, "no restriction passed" end

    index = string.lower(index)

    if !QS.RanksTable[index] then return false, "index does not exist in RanksTable" end

    //QS.RanksTable[index].

    return true
end
// "Sents" "Tools" "Weaps" "Other"
print(QS.Rank.SetRestriction("owner","canDie"))


--[[
--function QS.Rank.Create() end
--function QS.Rank.Delete() end
--function QS.Rank.Copy() end

--function QS.Rank.Get() end
--function QS.Rank.Save() end
--function QS.Rank.SaveAll() end

-function QS.Rank.SetRestriction() end
function QS.Rank.GetRestrictions() end
function QS.Rank.HasRestriction() end

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