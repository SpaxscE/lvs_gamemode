
util.AddNetworkString( "lvs_buymenu" )

net.Receive( "lvs_buymenu", function( len, ply )
	local class = net.ReadString()

	ply:EmitSound("lvs/tournament/store_buy.wav")
end )
