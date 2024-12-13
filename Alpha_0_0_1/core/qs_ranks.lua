QS.Ranks = {}
QS.Ranks.Table = { }
local x = 1
local rankProperties = {
    // Placeholders and Default Values
    // Don't touch.... TSG
    index = "template_idx",
    title = "template",
    color = Color(255,255,255),
    order = "-1",
    isAdmin = false, 
    isSuperAdmin = false,
    isImmune = false,
    targetOthers = false,
    privileges = {""},
    restrictions = {""},
}
// Create, Load, Check for rank folder
qsTag() MsgC(QS.Config.Colors.INFO, "Checking for RANK folder... ")
if !file.Exists("quicksilver/ranks","DATA") then
	MsgC(QS.Config.Colors.WARN, "NONE, creating folder \n")
	file.CreateDir("quicksilver/ranks") 
	else
        MsgC(QS.Config.Colors.WARN, "OK \n")
end

// Add check for owner rank, make sure it contains
// allcmds priv, don't change the rank if it exists.
// If the rank doesn't exist then create one.

//table.Copy(rankdefs)

// Takes a rank table and writes to disk. Does not support partial ranks
function QS.Ranks.SaveRank(rank)
    if rank == nil then print("WHAT ARE YOU DOING! \n") return end
	if !rank.index or type(rank.index) != "string" then 
        qsTag() MsgC(QS.Config.Colors.WARN,"Invalid or Bad Index\n")
    return {} end
    
    local index = rank.index
	local rank = util.TableToJSON(rankProperties)
    
	file.Write("quicksilver/ranks/" .. index .. ".txt", rank)
    qsTag() MsgC(QS.Config.Colors.INFO, "Saved [ " .. index .. " ] Rank to disk")
end

// Requires index and order passed when creating a rank.
function QS.Ranks.CreateRank(userTable) 
    local t = table.Copy(rankProperties)
    if userTable.index == nil then 
        qsTag() MsgC(QS.Config.Colors.ERROR,"CreateRank: Requires index when creating new rank\n")
        return nil end

    if userTable.order == nil then 
        qsTag() MsgC(QS.Config.Colors.ERROR,"CreateRank: Requires order when creating new rank\n")
        return nil end

    for key, value in pairs(userTable) do
        if t[key] != nil then
            t[key] = value
    end end

    QS.Ranks.SaveRank(t)
    return t
end

local tab = {
    index = "asdf",
    order = 123
}

QS.Ranks.CreateRank(tab)

//QS.Ranks.SaveRank({})

function QS.Ranks.DeleteRank(rank) end

function QS.Ranks.ChangeIndex(rank, index) end

function QS.Ranks.ChangeTitle(rank, title) end

function QS.Ranks.ChangeOrder(rank, order) end

function QS.Ranks.SetAdmin(rank, bool) end

function QS.Ranks.SetSuperAdmin(rank, bool) end

function QS.Ranks.SetImmune() end

function QS.Ranks.TargetOthers() end

function QS.Ranks.Privileges(rank, table) end

function QS.Ranks.Restrictions(rank, table) end
