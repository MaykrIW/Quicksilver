QS.Rank = {}
QS.RanksTable = {}


local RankTemplate = {
// Index is stored as the file name / key name
// Index & Title collisions will thrown error
    title = "", // Display name shown on scoreboards
    order = 1, // High number = Higher on scoreboard (top to bottom) and rank list in menu
    color = Color(100,100,100), // Default color is Gray
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
if !file.Exists("quicksilver/ranks","DATA") then
    MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.ERROR,"No ranks folder found, Creating\n")
	//MsgC(Color(255,0,0)," NO.  \n")
	file.CreateDir("quicksilver/ranks") 
    
	  //MsgN(" ") mtag() 	MsgC(Color(255,255,0),"Data folder created \n")
	else
		 //MsgC(Color(0,255,0)," OK. \n")
end


--[[

function QS.Rank.Create() end
function QS.Rank.Delete() end
function QS.Rank.Copy() end

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


MsgC(QS.Color.PRIMARY, "[QS]: ",QS.Color.INFO,"Ranks loaded\n")