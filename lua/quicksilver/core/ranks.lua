QS.Ranks = {}


// Index is saved as the file name not in the rank
local rankTemplate = {
    order = 0,
    color = {r=0,g=1,b=3},
    admin = false,
    superadmin = false,
    only_target_self = false,
    restrictions = {
        Weaps =  {},
        Tools = {},
        Sents = {}
    },
    privileges = {},
    immunity = 1,
    title = "Owner"
}





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