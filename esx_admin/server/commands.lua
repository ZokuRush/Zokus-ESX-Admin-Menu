ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterCommand('a:menu', 'admin', function(xPlayer, args, showError)
    xPlayer.triggerEvent('esx_admin:OpenMenu', args.playerId)
end, false)