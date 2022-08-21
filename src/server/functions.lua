--- OWN RESOURCE LEAKED BY HTTPS://GITHUB.COM/CFXSTORE

local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


sFunc = {}

local webhook = Config.webhook.url

function sFunc.has_value(tab, val)
    for index, value in ipairs(tab) do
        if value[1] == val then
            return true
        end
    end
    return false
end


function sFunc.getDiscordIdentifier(source)
    local identifiers = {
        discord = ""
    }

    local _ids = GetPlayerIdentifiers(source)

    for k,v in pairs(_ids) do
        if string.match(v, "discord:") then
            identifiers.discord = v:gsub("discord:", "")
        end
    end

    return identifiers.discord
end

function sFunc.getRedeemInformation(source)
    local discordID = sFunc.getDiscordIdentifier(source)

    local result = MySQL.Sync.fetchAll("SELECT * FROM cfx_refunds WHERE discord = @discord", {['@discord'] = discordID})
    if result[1] ~= nil then
        local data = result[1]

        return {
            discord = data['discord'],
            item = data['item'],
            quantity = data['quantity'],
        }
    else
        return nil
    end
end


function sFunc.sendWebhook(message)
    if message == nil then return false end
    if webhook == "" then return print("[CFX_Logs] | Please enter a valid webhook url.") end

    local embed = {
        {
            title = Config.webhook.embed.title,
            description = message,
            color = Config.webhook.embed.color,
            footer = {
                text = Config.webhook.embed.footer,
            },
        }
    }

  PerformHttpRequest(webhook, 
  function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' }) 
end

function sFunc.deleteRefundColumn(source, item, discordID)
    MySQL.Sync.execute("DELETE FROM cfx_refunds WHERE discord = @discord", {['@discord'] = discordID})
end

function sFunc.addMoneyToBank(type, player, quantity)
    if type == "money" then
        player.addAccountMoney("bank", quantity)
        sFunc.deleteRefundColumn(source, item, discordID)
    end

    if type == "black_money" then
        player.addAccountMoney("black_money", quantity)
        sFunc.deleteRefundColumn(source, item, discordID)
    end
end

function sFunc.addWeapon(item, player, quantity)
    if string.find(item, "WEAPON_") and sFunc.has_value(Config.AllowedWeapons) then
        player.addWeapon(item, quantity)
        sFunc.deleteRefundColumn(source, item, discordID)
    end
end

function sFunc.addItemToInventory(player, options, item, quantity)
    if not sFunc.has_value(options, item) then
        player.addInventoryItem(item, quantity)
        sFunc.deleteRefundColumn(source, item, discordID)
    end
end


--- OWN RESOURCE LEAKED BY HTTPS://GITHUB.COM/CFXSTORE
