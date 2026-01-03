-- Register Items as usable
CreateThread(function()
    local fw = exports['rpa-lib']:GetFramework()
    local fwName = exports['rpa-lib']:GetFrameworkName()
    
    if fwName == 'qb-core' then
        for name, data in pairs(Config.Consumables) do
            fw.Functions.CreateUseableItem(name, function(source, item)
                local Player = fw.Functions.GetPlayer(source)
                if Player.Functions.RemoveItem(name, 1) then
                    TriggerClientEvent('rpa-consumables:client:eat', source, name)
                end
            end)
        end
    end
end)

RegisterNetEvent('rpa-consumables:server:updateStatus', function(type, amount)
    local src = source
    local fw = exports['rpa-lib']:GetFramework()
    local fwName = exports['rpa-lib']:GetFrameworkName()

    if fwName == 'qb-core' then
        local Player = fw.Functions.GetPlayer(src)
        if type == 'food' then
            local new = Player.PlayerData.metadata['hunger'] + amount
            if new > 100 then new = 100 end
            Player.Functions.SetMetaData('hunger', new)
            TriggerClientEvent('hud:client:UpdateNeeds', src, new, Player.PlayerData.metadata['thirst'])
        elseif type == 'drink' then
            local new = Player.PlayerData.metadata['thirst'] + amount
            if new > 100 then new = 100 end
            Player.Functions.SetMetaData('thirst', new)
            TriggerClientEvent('hud:client:UpdateNeeds', src, Player.PlayerData.metadata['hunger'], new)
        end
    end
end)
