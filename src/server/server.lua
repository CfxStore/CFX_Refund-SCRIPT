--- OWN RESOURCE LEAKED BY HTTPS://GITHUB.COM/CFXSTORE


local options = {"black_money", "money", "weapon"}

local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("redeem", function(source, args)
    -- if not IsPlayerAceAllowed(source, Config.AceAllowed.permission) and Config.AceAllowed.needAcePerm then return end


    local rdmInformation = sFunc.getRedeemInformation(source)
    redeemItems(source, rdmInformation.item, rdmInformation.quantity)
end, false)


function redeemItems(source, item, quantity)
    local discordID = sFunc.getDiscordIdentifier(source)
    local player = ESX.GetPlayerFromId(source)
    
    if item == nil then return player.showNotification("Je hebt geen refund openstaan.") end
    
    if player.hasWeapon(item) then
        return player.showNotification("Je hebt dit wapen al opzak.")
    else
        sFunc.addWeapon(item, player, quantity)
    end
    
    sFunc.addMoneyToBank(item, player, quantity)
    sFunc.addItemToInventory(player, options, item, quantity)

    
    sFunc.deleteRefundColumn(source, item, discordID)
    player.showNotification("Je hebt succesvol " .. item .. " gerefuned.")
    sFunc.sendWebhook("<@" .. discordID .. "> " .. "heeft succesvol " .. item .. " gerefuned.")

end

--- OWN RESOURCE LEAKED BY HTTPS://GITHUB.COM/CFXSTORE
