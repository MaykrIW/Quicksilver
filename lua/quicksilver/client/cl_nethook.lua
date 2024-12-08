net.Receive("QS:ChatPrint", function()
	print(net.ReadTable())
	chat.AddText(unpack(net.ReadTable()))
end)
