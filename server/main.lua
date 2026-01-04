-- Get player helper
local function GetPlayer(src)
    local Framework = exports['rpa-lib']:GetFramework()
    if Framework then
        return Framework.Functions.GetPlayer(src)
    end
    return nil
end

-- Register Items as usable
CreateThread(function()
    local fw = exports['rpa-lib']:GetFramework()
    local fwName = exports['rpa-lib']:GetFrameworkName()
    
    if fwName == 'qb-core' or fwName == 'qbox' then
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

-- Update player status with proper data handling
RegisterNetEvent('rpa-consumables:server:updateStatus', function(data)
    local src = source
    local fwName = exports['rpa-lib']:GetFrameworkName()

    if fwName == 'qb-core' or fwName == 'qbox' then
        local Player = GetPlayer(src)
        if not Player then return end
        
        local itemType = data.type
        local hunger = data.hunger or 0
        local thirst = data.thirst or 0
        local stress = data.stress or 0
        
        -- Get current values
        local currentHunger = Player.PlayerData.metadata['hunger'] or 0
        local currentThirst = Player.PlayerData.metadata['thirst'] or 0
        local currentStress = Player.PlayerData.metadata['stress'] or 0
        
        if itemType == 'food' then
            local newHunger = math.min(100, currentHunger + hunger)
            Player.Functions.SetMetaData('hunger', newHunger)
            TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, currentThirst)
            
        elseif itemType == 'drink' then
            local newThirst = math.min(100, currentThirst + thirst)
            Player.Functions.SetMetaData('thirst', newThirst)
            TriggerClientEvent('hud:client:UpdateNeeds', src, currentHunger, newThirst)
            
        elseif itemType == 'alcohol' then
            -- Alcohol: increases thirst, reduces stress
            local newThirst = math.min(100, currentThirst + thirst)
            local newStress = math.max(0, currentStress + stress) -- stress is negative in config
            
            Player.Functions.SetMetaData('thirst', newThirst)
            Player.Functions.SetMetaData('stress', newStress)
            TriggerClientEvent('hud:client:UpdateNeeds', src, currentHunger, newThirst)
            
        elseif itemType == 'smoke' then
            -- Smoking: only affects stress
            local newStress = math.max(0, currentStress + stress) -- stress is negative in config
            Player.Functions.SetMetaData('stress', newStress)
        end
    end
end)
