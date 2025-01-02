CreateThread( function ()
	RequestScriptAudioBank( "DLC_SM_Countermeasures_Sounds" )

	RequestNamedPtfxAsset( "scr_sum_gy" )
	while not HasNamedPtfxAssetLoaded( "scr_sum_gy" ) do
		Wait( 1 )
	end

	while true do
		local veh = GetVehiclePedIsIn( PlayerPedId(), false )
		local vhash = GetEntityModel( veh )

		if IsControlJustReleased( 0, 255 ) then
			local isFound = table.hasvalue( Shared.Whitelist, vhash )
			if not isFound then return end

			FIRE_AIR_BOMB( veh )
		end

		Wait( 0 )
	end
end )

local vFrontBottomLeft = vector3( 0, 0, 0 )
local vFrontBottomRight = vector3( 0, 0, 0 )
local vBackBottomLeft = vector3( 0, 0, 0 )
local vBackBottomRight = vector3( 0, 0, 0 )

function DETERMINE_4_BOTTOM_VECTORS_FOR_VEHICLE_WEAPON( thisEntity, theModel )
	local modelMin, modelMax = GetModelDimensions( theModel )

	local tempFrontBottomLeft = vector3( 0, 0, 0 )
	local tempFrontBottomRight = vector3( 0, 0, 0 )
	local tempBackBottomLeft = vector3( 0, 0, 0 )
	local tempBackBottomRight = vector3( 0, 0, 0 )

	tempFrontBottomLeft = vector3( modelMin.x, modelMax.y, modelMin.z )
	tempFrontBottomRight = vector3( modelMax.x, modelMax.y, modelMin.z )
	tempBackBottomLeft = vector3( modelMin.x, modelMin.y, modelMin.z )
	tempBackBottomRight = vector3( modelMax.x, modelMin.y, modelMin.z )

	frontBottomLeft = GetOffsetFromEntityInWorldCoords( thisEntity, tempFrontBottomLeft.xyz )
	frontBottomRight = GetOffsetFromEntityInWorldCoords( thisEntity, tempFrontBottomRight.xyz )
	backBottomLeft = GetOffsetFromEntityInWorldCoords( thisEntity, tempBackBottomLeft.xyz )
	backBottomRight = GetOffsetFromEntityInWorldCoords( thisEntity, tempBackBottomRight.xyz )

	return frontBottomLeft, frontBottomRight, backBottomLeft, backBottomRight
end

function GET_INTERP_POINT_FLOAT_FOR_VEHICLE_WEAPON( fStartPos, fEndPos, fStartTime, fEndTime, fPointTime )
	return ((((fEndPos - fStartPos) / (fEndTime - fStartTime)) * (fPointTime - fStartTime)) + fStartPos)
end

function GET_INTERP_POINT_VECTOR_FOR_VEHICLE_WEAPON( vStartPos, vEndPos, fStartTime, fEndTime, fPointTime )
	local X = GET_INTERP_POINT_FLOAT_FOR_VEHICLE_WEAPON( vStartPos.x, vEndPos.x, fStartTime, fEndTime, fPointTime )
	local Y = GET_INTERP_POINT_FLOAT_FOR_VEHICLE_WEAPON( vStartPos.y, vEndPos.y, fStartTime, fEndTime, fPointTime )
	local Z = GET_INTERP_POINT_FLOAT_FOR_VEHICLE_WEAPON( vStartPos.z, vEndPos.z, fStartTime, fEndTime, fPointTime )

	return vector3( X, Y, Z )
end

function FIRE_AIR_BOMB( vehPlane )
	local flare_hash = `VEHICLE_WEAPON_BOMB_WATER`

	RequestModel( flare_hash )
	RequestWeaponAsset( flare_hash, 31, 26 )

	SetVehicleBombCount( vehPlane, 10 )

	local vFrontBottomLeft, vFrontBottomRight, vBackBottomLeft, vBackBottomRight = DETERMINE_4_BOTTOM_VECTORS_FOR_VEHICLE_WEAPON( vehPlane, GetEntityModel( vehPlane ) )

	local vB1 = GET_INTERP_POINT_VECTOR_FOR_VEHICLE_WEAPON( vFrontBottomLeft, vFrontBottomRight, 0.0, 1.0, 0.5 )
	local vB2 = GET_INTERP_POINT_VECTOR_FOR_VEHICLE_WEAPON( vBackBottomLeft, vBackBottomRight, 0.0, 1.0, 0.5 )

	vB1 += vector3( 0.0, 0.0, 0.4 )
	vB2 += vector3( 0.0, 0.0, 0.4 )

	local vB3 = GET_INTERP_POINT_VECTOR_FOR_VEHICLE_WEAPON( vB1, vB2, 0.0, 1.0, 0.35 )

	vB1 -= vector3( 0.0, 0.0, 0.4 )
	vB2 -= vector3( 0.0, 0.0, 0.4 )

	local vB4 = GET_INTERP_POINT_VECTOR_FOR_VEHICLE_WEAPON( vB1, vB2, 0.0, 1.0, 0.35 )

	ShootSingleBulletBetweenCoordsIgnoreEntityNew( vB3, vB4, 0, true, flare_hash, PlayerPedId(), true, true, -1.0, nil, false, false, vehPlane, true, true )
	PlaySoundFrontend( -1, "bomb_deployed", "DLC_SM_Bomb_Bay_Bombs_Sounds" )
end