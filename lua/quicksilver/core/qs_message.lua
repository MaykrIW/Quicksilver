// Contains functions for sending messages / chats / alerts
QS.Message = {}


// Send a message to all players
function QS.Message.Broadcast(table)
    net.Start("QS:ChatPrint")
    net.WriteTable(table)
    net.Send(self)
end

// Send a message to a specific player
function QS.Message.Direct(player, table) 
    net.Start("QS:ChatPrint")
    net.WriteTable(table)
    net.Send(player)
end


