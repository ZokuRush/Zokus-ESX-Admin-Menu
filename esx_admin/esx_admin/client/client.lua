ESX              = nil
local PlayerData = {}
local isMenuOpen = false

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

RegisterNetEvent('esx_admin:OpenMenu')
AddEventHandler('esx_admin:OpenMenu', function()
    OpenMenu()
end)

function OpenMenu()
    isMenuOpen = true
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admin_menu', {
    	title    = 'Admin Menu',
		align    = 'top-left',
		elements = {
        {label = "Player Control", value = 'player_control'},
        {label = "Vehicle Control", value = 'vehicle_control'},
        {label = "Developer Options", value = 'developer_options'}
    }}, function(data, menu)
        if data.current.value == 'player_control' then
            local elements = {
					{label = ('Ban Player'), value = 'BanPlayer'},
                    {label = ('Kick Player'), value = 'KickPlayer'},
                    {label = ('Bring Player'), value = 'BringPlayer'},
                    {label = ('Teleport To Player'), value = 'TeleportToPlayer'},
                    {label = ('Revive Player'), value = 'RevivePlayer'},
                    {label = ('Heal Player'), value = 'HealPlayer'},
                    {label = ('Reset Hunger/Thirst'), value = 'ResetFoodThirst'}
            }

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_control', {
                title    = 'Admin Menu',
                align    = 'top-left',
                elements = elements
            }, function(data, menu)

                if data.current.value == 'BanPlayer' then
                    -- To do
                end
                if data.current.value == 'KickPlayer' then
                    -- To do
                end
                if data.current.value == 'BringPlayer' then
                    -- To do
                end
                if data.current.value == 'TeleportToPlayer' then
                    -- To do
                end
                if data.current.value == 'RevivePlayer' then
                    TriggerEvent('esx_admin:RevivePlayer')
                end
                if data.current.value == 'HealPlayer' then
                    TriggerEvent('esx_admin:HealPlayer')
                end
                if data.current.value == 'ResetFoodThirst' then
                    TriggerEvent('esx_admin:ResetFoodThirst')
                end
            end, function(data, menu)
                menu.close()
            end)
        elseif data.current.value == 'vehicle_control' then
            local elements = {
					{label = ('Get Keys'), value = 'GetCarKeys'},
                    {label = ('Spawn Vehicle (Model)'), value = 'SpawnVehicle'},
                    {label = ('Delete Vehicle'), value = 'DeleteVehicle'},
                    {label = ('Vehicle Mods'), value = 'VehicleMods'},
                    {label = ('Repair Vehicle'), value = 'RepairVehicle'},
                    {label = ('Clean Vehicle'), value = 'CleanVehicle'},
                    {label = ('Flip Vehicle'), value = 'FlipVehicle'},
                    {label = ('Max Fuel'), value = 'MaxFuel'}
            }

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_control', {
                title    = 'Admin Menu',
                align    = 'top-left',
                elements = elements
            }, function(data, menu)

                if data.current.value == 'GetCarKeys' then
                    TriggerEvent('esx_admin:GetCarKeys')
                end
                if data.current.value == 'SpawnVehicle' then
                    -- To do
                end
                if data.current.value == 'DeleteVehicle' then
                    TriggerEvent('esx_admin:DeleteVehicle')
                end
                if data.current.value == 'VehicleMods' then
                    -- To do
                end
                if data.current.value == 'RepairVehicle' then
                    TriggerEvent('esx_admin:RepairVehicle')
                end
                if data.current.value == 'CleanVehicle' then
                    TriggerEvent('esx_admin:CleanVehicle')
                end
                if data.current.value == 'FlipVehicle' then
                    TriggerEvent('esx_admin:FlipVehicle')
                end
                if data.current.value == 'MaxFuel' then
                    TriggerEvent('esx_admin:MaxFuel')
                end
            end, function(data, menu)
                menu.close()
            end)
        elseif data.current.value == 'developer_options' then
            local elements = {
                    {label = ('Spawn Item'), value = 'SpawnItem'},
                    {label = ('Teleport To Waypoint'), value = 'TPM'},
                    {label = ('Edit Player Model'), value = 'PlayerSkin'},
                    {label = ('Toggle Coords'), value = 'Coords'},
                    {label = ('Toggle Noclip'), value = 'Noclip'},
                    {label = ('Toggle Godmode'), value = 'Godmode'},
                    {label = ('Toggle Invisible'), value = 'Invisible'}
            }

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'developer_options', {
                title    = 'Admin Menu',
                align    = 'top-left',
                elements = elements
            }, function(data, menu)

                if data.current.value == 'SpawnItem' then
                    -- To do
                end
                if data.current.value == 'TPM' then
                    TriggerEvent('esx_admin:TPM')
                end
                if data.current.value == 'PlayerSkin' then
                    TriggerEvent('esx_skin:openSaveableMenu')
                end
                if data.current.value == 'Coords' then
                    ToggleCoords()
                end
                if data.current.value == 'Noclip' then
                    TriggerEvent('esx_admin:Noclip')
                end
                if data.current.value == 'Godmode' then
                    TriggerEvent('esx_admin:Godmode')
                end
                if data.current.value == 'Invisible' then
                    TriggerEvent('esx_admin:Invisible')
                end
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end