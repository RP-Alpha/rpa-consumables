-- Placeholder animation logic
RegisterNetEvent('rpa-consumables:client:eat', function(itemName)
    local item = Config.Consumables[itemName]
    if not item then return end

    exports['rpa-lib']:Notify("Consuming " .. itemName, "info")
    -- Add emote / animation / progress bar here
    
    -- Trigger Status Updates (using framework bridge ideally, but for now specific events)
    TriggerServerEvent('rpa-consumables:server:updateStatus', item.type, item.hunger or item.thirst)
end)
