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

// Used to add functions to the player. Example ply:SetRank(), ply:GetPriviledge(). or ply:GetRestriction
PLAYER_META = FindMetaTable("Player")

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

// Default Ranks are used if the RANKS folder doesn't exist/contain Owner or Default ranks
// Default Owner rank (has *root permission which gives all access)
local OwnerTmpl = table.Copy(RankTmpl)
OwnerTmpl.title = "Owner"
OwnerTmpl.superadmin = true 
OwnerTmpl.admin = true 
OwnerTmpl.only_target_self = false
OwnerTmpl.immunity = 10000
OwnerTmpl.privileges[1] = "*root"

// Default User rank (can't do anything)
local DefaultTmpl = table.Copy(RankTmpl)
DefaultTmpl.title = "Guest"
DefaultTmpl.superadmin = false  
DefaultTmpl.admin = false 
DefaultTmpl.only_target_self = true
DefaultTmpl.immunity = 1
DefaultTmpl.privileges[1] = ""


// Create load ranks function? or only allow updating the table not a full reload?

--[[ 
Check for Ranks Folder / ensure required ranks [default(guest), owner] exist
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
        file.Append("quicksilver/ranks/default.txt",util.TableToJSON(DefaultTmpl,true))
	else
        MsgC(QS.Color.WARN, "OK \n") 

        if !file.Exists("quicksilver/ranks/owner.txt", "DATA") then 
            file.Append("quicksilver/ranks/owner.txt", util.TableToJSON(OwnerTmpl,true))
        end
        if !file.Exists("quicksilver/ranks/default.txt", "DATA") then 
            file.Append("quicksilver/ranks/default.txt",util.TableToJSON(DefaultTmpl,true))
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
    if !QS.RanksTable[index] then return false, "index '"..index.."' not in RanksTable" end
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
	Name: Rank.ModProperty
    Desc: Set a restiction on a rank (can't remove)
    Arg1: string :: index - the rank to be modified
    Arg2: string :: property - the property to change on the given rank
    Arg3: any    :: value - the value to set the property 
    Returns: bool, Status/Error message
    ------------------------------------------------------------------------]]--
function QS.Rank.ModProperty(index, property, value) 
    // Should this handle multiple commands at once or get called recursivly? For now handle individual calls
    if !index or index == "" then return false, "no index passed" end 
    if !property or property == "" then return false, "no property passed" end
    if value == nil then return false, "no restriction passed" end

    index = string.lower(index)
    property = string.lower(property)
    if type(value) == "string" then value = string.lower(value) end

    if !QS.RanksTable[index] then return false, "index '"..index.."' does not exist in RanksTable" end
    if !RankProps[property] then return false, "property '"..property.."' is not a valid rank property on "..index.." rank" end
    if RankProps[property] != type(value) then return false, "value type '"..type(value).."' is incorrect type for "..property.." on "..index.." rank" end

    QS.RanksTable[index][property] = value
    
    QS.Rank.Save(index)

    return true, index.." rank property '"..property.."' was modified to '"..tostring(value).."'"
end
//print(QS.Rank.ModProperty("default","admin", false ))

--[[------------------------------------------------------------------------
	Name: Rank.ModRestriction
    Desc: Set/Modify/Remove a restiction on a rank
    Arg1: string :: index - the rank to be modified
    Arg2: string :: type - the type of restriction to add / remove (Weaps, Tools, Sents)
    Arg3: id     :: type - the type of restriction to add / remove (Weaps, Tools, Sents)
    Arg4: string :: restriction - what is the restriction?
    Arg5: bool   :: add(true) / remove(false) 
    Returns: bool, Status/Error message
    ------------------------------------------------------------------------]]--
function QS.Rank.ModRestriction(index, type_ , id, restriction, bool) 
    // Should this handle multiple commands at once or get called recursivly? For now handle individual calls
    if !index or index == "" then return false, "no index passed" end 
    if !type_ or type_ == "" then return false, "no restriction type passed" end
    if !id or type(id) != "number" then return false, "no id passed or not a number" end // TODO: Replace this once the commands system is inplace.
    if !restriction or restriction == "" then return false, "no restriction passed" end

    index = string.lower(index)
    type_ = string.lower(type_):gsub("^%l", string.upper)

    if !QS.RanksTable[index] then return false, "index '"..index.."' does not exist in RanksTabl" end
    if !QS.RanksTable[index]["restrictions"][type_] then return false, "Restriction type '"..type_.."' does not exists. Valid types are Weaps, Tools, Sents" end

    if bool then
        QS.RanksTable[index]["restrictions"][type_][id] = restriction
        QS.Rank.Save(index)
        return true, index.." rank had restriction '"..type_.."' : '"..restriction.." added"
        
    else
        QS.RanksTable[index]["restrictions"][type_][id] = nil
        QS.Rank.Save(index)
        return true, index.." rank had restriction '"..type_.."' : '"..restriction.." removed"
    end

    

    //if !QS.RanksTable[index] then return false, "index '"..index.."' does not exist in RanksTable" end
    //if !RankProps[property] then return false, "property '"..property.."' is not a valid rank property on "..index.." rank" end
    //if RankProps[property] != type(value) then return false, "value type '"..type(value).."' is incorrect type for "..property.." on "..index.." rank" end


    
end
//print(QS.Rank.ModRestriction("default","Weaps",1,"a", false))

//PrintTable(QS.RanksTable["default"])



// TODO: Function descripter
function QS.Rank.GetRestrictions(index) 
    if !index or index == "" then return false, "no index passed" end
    if !QS.RanksTable[index] then return false, "index not found in RanksTable" end
    return QS.RanksTable[index]["restrictions"]
end
//PrintTable(QS.Rank.GetRestrictions("default"))




function QS.Rank.ModPrivilage() end



--[[
restrictions = { // Restrict rank from Weapons, Tools, Sents(scripted entities)
        Weaps =  {},
        Tools = {},
        Sents = {}
    },
    privileges = {}
]]--

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

]]--

--[[ Mercury's functions
function Mercury.Ranks.AddRankProperty(property, typ_e, default) end
function Mercury.Ranks.SaveRank(index, configuration) end
function Mercury.Ranks.CreateRank(index, title, color) end
function Mercury.Ranks.DeleteRank(index) end
function Mercury.Ranks.ChangeIndex(index, newindex) end
function Mercury.Ranks.CopyRank(index, newindex) end
function Mercury.Ranks.ModProperty(index, property, value) end
function Mercury.Ranks.GetProperty(index, property) end
function Mercury.Ranks.SetRank(play, rank) end
function META:GetRank() end
function META:HasPrivilege(x, __cyclic) end
function META:GetImmunity() end
function META:CanUserTarget(x) end
function Mercury.Ranks.RefreshTeams() end
function Mercury.Ranks.UpdateUserGroups(rank) end
function Mercury.Ranks.SendRankUpdateToClients() end
net.Receive("Mercury:RankData", function() end)
function GetTemplateRank() end
function mtag(...) end
timer.Create("Mercury_UpdatePlayerInfo", 0.5, 0, function() end)
hook.Add("PlayerInitialSpawn", "MARS_Rank_Initialspawn", function() end)
timer.Create("Mercury.OverrideAdmin", 1, 0, function() end)
function metaplayer:GetUserGroup() end
function metaplayer:IsUserGroup(grp) end
function metaplayer:IsAdmin() end
function metaplayer:IsSuperAdmin() end
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

Default2 = {
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