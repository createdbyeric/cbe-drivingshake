local lastDamage = 0.0

-- Load configuration
local Config = LoadResourceFile(GetCurrentResourceName(), "config.lua")
if Config then
    Config = assert(load(Config))()
else
    print("[Vehicle Damage Shake] Config file not found!")
    Config = { defaultShakeRate = 125.0 } -- Default fallback
end

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            sleep = 100 -- Reduce wait time when in a vehicle

            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local curHealth = GetVehicleBodyHealth(vehicle)

            -- Only process if damage has changed
            if curHealth ~= lastDamage then
                local shakeRate = GetEntitySpeed(vehicle) / Config.defaultShakeRate -- Use configured shake rate
                ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", shakeRate)
                lastDamage = curHealth
            end
        end

        Citizen.Wait(sleep)
    end
end)
