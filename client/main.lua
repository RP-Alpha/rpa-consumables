-- Placeholder animation logic
RegisterNetEvent('rpa-consumables:client:eat', function(itemName)
    local item = Config.Consumables[itemName]
    if not item then return end

    exports['rpa-lib']:Notify("Consuming " .. itemName, "info")
    
    local ped = PlayerPedId()
    local itemModel = GetHashKey(item.model)
    RequestModel(itemModel)
    while not HasModelLoaded(itemModel) do Wait(0) end
    
    -- Prop Logic (simplified)
    local prop = CreateObject(itemModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    
    -- Anim
    if item.animation == 'drink' then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRINKING", 0, true)
    elseif item.animation == 'smoke' then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)
    else
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_EAT_SUB", 0, true)
    end

    Wait(5000) -- Consumption time
    ClearPedTasks(ped)
    DeleteObject(prop)
    
    -- Effects
    if item.type == 'alcohol' then
        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(ped, true)
        SetPedIsDrunk(ped, true)
        SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        
        -- Wear off after 60s for demo
        SetTimeout(60000, function()
             ClearTimecycleModifier()
             SetPedIsDrunk(ped, false)
             ResetPedMovementClipset(ped, 0)
        end)
    elseif item.type == 'smoke' then
         -- Particle Effect
         RequestNamedPtfxAsset("core")
         while not HasNamedPtfxAssetLoaded("core") do Wait(0) end
         UseParticleFxAsset("core")
         StartNetworkedParticleFxNonLoopedOnEntity("exp_grd_grenade_smoke", ped, 0,0,0, 0,0,0, 0.2, false, false, false)
         SetTimecycleModifier("hud_def_blur")
         SetTimeout(10000, function()
             ClearTimecycleModifier()
         end)
    end
    
    -- Trigger Status Updates
    TriggerServerEvent('rpa-consumables:server:updateStatus', item.type, item.hunger or item.thirst or item.stress)
end)
