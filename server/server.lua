RegisterNetEvent( "explosionEvent", function ( _, ev )
	local explosionType = (ev.explosionType - 1)

	local isBombWater = Shared.ExplosionType[explosionType] == "BOMB_WATER"
	if not isBombWater then return end

	-- [Disclaimer !!] Onsync need to be true for the explosion to work properly
	-- Add your code here ...
end )