-- Helper function to load model with timeout
local function LoadModel(model, timeout)
    timeout = timeout or 5000
    local hash = type(model) == 'string' and GetHashKey(model) or model
    
    if not IsModelValid(hash) then
        return false
    end
    
    RequestModel(hash)
    local startTime = GetGameTimer()
    while not HasModelLoaded(hash) do
        if GetGameTimer() - startTime > timeout then
            return false
        end
        Wait(10)
    end
    return true
end

-- Consumable animation and effects
RegisterNetEvent('rpa-consumables:client:eat', function(itemName)
    local item = Config.Consumables[itemName]
    if not item then return end

    exports['rpa-lib']:Notify("Consuming " .. itemName, "info")
    
    local ped = PlayerPedId()
    local prop = nil
    
    -- Load and attach prop
    if item.model and LoadModel(item.model) then
        local itemModel = GetHashKey(item.model)
        prop = CreateObject(itemModel, 0, 0, 0, true, true, true)
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 18905), 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    end
    
    -- Play animation
    if item.animation == 'drink' then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRINKING", 0, true)
    elseif item.animation == 'smoke' then
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING", 0, true)
    else
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_EAT_SUB", 0, true)
    end

    Wait(5000) -- Consumption time
    ClearPedTasks(ped)
    
    -- Cleanup prop
    if prop and DoesEntityExist(prop) then
        DeleteObject(prop)
    end
    
    -- Effects based on type
    if item.type == 'alcohol' then
        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(ped, true)
        SetPedIsDrunk(ped, true)
        
        -- Load and set drunk movement clipset
        RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
        local timeout = 0
        while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
        if HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
            SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        end
        
        -- Wear off after 60s for demo
        SetTimeout(60000, function()
            ClearTimecycleModifier()
            SetPedMotionBlur(PlayerPedId(), false)
            SetPedIsDrunk(PlayerPedId(), false)
            ResetPedMovementClipset(PlayerPedId(), 0)
        end)
    elseif item.type == 'smoke' then
        -- Particle Effect
        RequestNamedPtfxAsset("core")
        local timeout = 0
        while not HasNamedPtfxAssetLoaded("core") and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
        if HasNamedPtfxAssetLoaded("core") then
            UseParticleFxAsset("core")
            StartNetworkedParticleFxNonLoopedOnEntity("exp_grd_grenade_smoke", ped, 0,0,0, 0,0,0, 0.2, false, false, false)
        end
        SetTimecycleModifier("hud_def_blur")
        SetTimeout(10000, function()
            ClearTimecycleModifier()
        end)
    end
    
    -- Send proper status updates to server with all relevant data
    TriggerServerEvent('rpa-consumables:server:updateStatus', {
        type = item.type,
        hunger = item.hunger,
        thirst = item.thirst,
        stress = item.stress
    })
end)
