QS.Ranks = {}
QS.Ranks.Table = { }
local x = 1
local rankProperties = {
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
// Create / Check for rank folder
qsTag() MsgC(QS.Config.Colors.INFO, "Checking for RANK folder... ")
if !file.Exists("quicksilver/ranks","DATA") then
	MsgC(QS.Config.Colors.WARN, "NONE, creating folder \n")
	file.CreateDir("quicksilver/ranks") 
	else
        MsgC(QS.Config.Colors.WARN, "OK \n")
end
//table.Copy(rankdefs)

// Requires atleast index and order passed when creating a rank.
function QS.Ranks.CreateRank(userTable) 

    local t = table.Copy(rankProperties)
    for key, value in pairs(userTable) do
        -- Check if the key exists in the rankTemplate
        if t[key] != nil then
            t[key] = value
        end
    end
    return t
end
local x = {
    index = "cool new name",
    title = "yeah",
    isSuperAdmin = true,
}
PrintTable(QS.Ranks.CreateRank(x))

function QS.Ranks.SaveRank(rank) end

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
