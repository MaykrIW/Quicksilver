// Contains functions for sending messages / chats / alerts
QS.Message = {}

// Broadcast to all players
// Text must be within a msg value
function QS.Message.Broadcast(table)
    net.Start("QS:ChatPrint")
    net.WriteTable(table)
    net.Send(player.GetAll())

end

// Send a message to a specific player
// Text must be within a msg value
function QS.Message.Direct(player, table) 
    net.Start("QS:ChatPrint")
    net.WriteTable(table)
    net.Send(player)
end


