ESX              = nil
local PlayerData = {}
local distanceToCheck = 5.0
local numRetries = 5

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

-- Revive Player
RegisterNetEvent('esx_admin:RevivePlayer')
AddEventHandler('esx_admin:RevivePlayer', function()
	SetEntityHealth(player, GetEntityMaxHealth(player))
    ClearPedBloodDamage(player)
    SetPlayerSprint(PlayerId(), true)
    TriggerEvent('mythic_hospital:client:RemoveBleed')
    TriggerEvent('mythic_hospital:client:ResetLimbs')
    TriggerEvent('esx_ambulancejob:revive')
	exports['mythic_notify']:DoHudText('success', 'Health Reset!')
end)

-- Heal Player
RegisterNetEvent('esx_admin:HealPlayer')
AddEventHandler('esx_admin:HealPlayer', function()
	TriggerEvent('mythic_hospital:client:RemoveBleed')
    TriggerEvent('mythic_hospital:client:ResetLimbs')

	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
	exports['mythic_notify']:DoHudText('success', 'Health Reset!')
end)

-- Reset Food and Thirst
RegisterNetEvent('esx_admin:ResetFoodThirst')
AddEventHandler('esx_admin:ResetFoodThirst', function()
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	exports['mythic_notify']:DoHudText('success', 'Food and Thirst Reset!')
end)

-- Get Car Keys
RegisterNetEvent('esx_admin:GetCarKeys')
AddEventHandler('esx_admin:GetCarKeys', function(plate)
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
    	local plate = GetVehicleNumberPlateText(vehicle)
		exports["esx_locksystem"]:givePlayerKeys(plate)
		exports['mythic_notify']:DoHudText('success', 'Received Keys!')
	else
        exports['mythic_notify']:DoHudText('error', 'There is no vehicle(s) nearby!')
	end
end)

-- Reapir Car
RegisterNetEvent('esx_admin:RepairVehicle')
AddEventHandler('esx_admin:RepairVehicle', function()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
        exports['mythic_notify']:DoHudText('success', 'Vehicle has been fixed!')
	else
        exports['mythic_notify']:DoHudText('error', 'There is no vehicle(s) nearby!')
	end
end)

-- Clean Car
RegisterNetEvent('esx_admin:CleanVehicle')
AddEventHandler('esx_admin:CleanVehicle', function()
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleDirtLevel(vehicle, 0)
		exports['mythic_notify']:DoHudText('success', 'Vehicle has been cleaned!')
	else
		exports['mythic_notify']:DoHudText('error', 'There is no vehicle(s) nearby!')
	end
end)

-- Noclip
local noclip = false
RegisterNetEvent("esx_admin:Noclip")
AddEventHandler("esx_admin:Noclip", function(input)
    local player = PlayerId()
	local ped = PlayerPedId
	
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
	end

	noclip = not noclip

	end)
	
	local heading = 0
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if(noclip)then
			SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

			if(IsControlPressed(1, 34))then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			SetEntityInvincible(GetPlayerPed(-1),true)
			SetEntityVisible(GetPlayerPed(-1),true)

			if(IsControlPressed(1, 9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
			end

			if(IsControlPressed(1, 32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1, 209))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
			end

			if(IsControlPressed(1, 60))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
			end
		else
			Citizen.Wait(200)
		end
	end
end)

-- TPM
RegisterNetEvent("esx_admin:TPM")
AddEventHandler("esx_admin:TPM", function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
		exports['mythic_notify']:DoHudText('success', 'Teleported!')
    else
		exports['mythic_notify']:DoHudText('error', 'No Waypoint Set!')
    end
end)

-- Coords
local coordsVisible = false

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		
		if coordsVisible then
			sleepThread = 5

			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)

			DrawGenericText(("~o~X~w~: %s ~o~Y~w~: %s ~o~Z~w~: %s ~o~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end

		Citizen.Wait(sleepThread)
	end
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function()
	coordsVisible = not coordsVisible
end

-- Flipcar
RegisterNetEvent('esx_admin:FlipVehicle')
AddEventHandler('esx_admin:FlipVehicle', function()
	local ped = PlayerPedId()
	local pedcoords = GetEntityCoords(ped)
	VehicleData = ESX.Game.GetClosestVehicle()
	local dist = #(pedcoords - GetEntityCoords(VehicleData))
	local carCoords = GetEntityRotation(VehicleData, 2)
	SetEntityRotation(VehicleData, carCoords[1], 0, carCoords[3], 2, true)
	SetVehicleOnGroundProperly(VehicleData)
end)

-- Delete Vehicle
RegisterNetEvent("esx_admin:DeleteVehicle")
AddEventHandler("esx_admin:DeleteVehicle", function()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            end 
        else
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( ped, pos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            end 
        end 
    end 
end )

function DeleteGivenVehicle( veh, timeoutMax )
    local timeout = 0 
    SetEntityAsMissionEntity( veh, true, true )
    DeleteVehicle( veh )
    if ( DoesEntityExist( veh ) ) then
        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )
            if ( not DoesEntityExist( veh ) ) then 
            end 
            timeout = timeout + 1 
            Citizen.Wait( 500 )
            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
            end 
        end 
    end 
end 

function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    if ( IsEntityAVehicle( vehicle ) ) then 
        return vehicle
    end 
end

-- Max Fuel
RegisterNetEvent('esx_admin:MaxFuel')
AddEventHandler('esx_admin:MaxFuel', function(vehicle)
	local playerPed = PlayerPedId()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		exports["LegacyFuel"]:SetFuel(vehicle, 100)
		exports['mythic_notify']:DoHudText('success', 'Topped off the tank!')
	else
        exports['mythic_notify']:DoHudText('error', 'There is no vehicle(s) nearby!')
	end
end)

-- Godmode
RegisterNetEvent('esx_admin:Godmode')
local godmode = false

AddEventHandler('esx_admin:Godmode', function()
	local playerPed = GetPlayerPed(-1)

	if not godmode then
	    godmode = true
	    exports['mythic_notify']:DoHudText('success', 'Godmode is on!')
	elseif godmode then
	    godmode = false
		exports['mythic_notify']:DoHudText('error', 'Godmode is off!')
	end
end)

Citizen.CreateThread(function() --Godmode
	while true do
		Citizen.Wait(1)

		if godmode then
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
		elseif not godmode then
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
			SetEntityCanBeDamaged(GetPlayerPed(-1), true)
		end
	end
end)