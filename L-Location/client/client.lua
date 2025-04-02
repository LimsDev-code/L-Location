local isUIOpen = false
local pedEntity = nil -- Variable to store the ped entity

-- Create the ped on startup
Citizen.CreateThread(function()
    local pedModel = GetHashKey(Config.PedLocation.model)
    RequestModel(pedModel)

    while not HasModelLoaded(pedModel) do
        Citizen.Wait(10)
    end

    -- Create the ped at the location defined in Config
    pedEntity = CreatePed(4, pedModel, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z - 1.0, Config.PedLocation.heading, false, true)
    SetEntityInvincible(pedEntity, true) -- Make the ped invincible
    FreezeEntityPosition(pedEntity, true) -- Prevent the ped from moving
    SetBlockingOfNonTemporaryEvents(pedEntity, true) -- Prevent the ped from reacting to events

    -- Main loop to handle interaction with the menu
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local menuLocation = vector3(Config.MenuLocation.x, Config.MenuLocation.y, Config.MenuLocation.z)
        local menuRadius = Config.MenuLocation.radius

        -- Check if the player is near the ped
        if #(playerCoords - menuLocation) <= menuRadius then
            DrawText3D(menuLocation.x, menuLocation.y, menuLocation.z, "[E] Open Menu")

            if IsControlJustReleased(1, 38) then
                OpenUI()
            end
        end

        Citizen.Wait(0)
    end
end)

-- Function to open or close the user interface
function OpenUI()
    if not isUIOpen then
        isUIOpen = true
        SetNuiFocus(true, true)
        SendNuiMessage(json.encode{
            action = 'open'
        })
    else
        isUIOpen = false
        SetNuiFocus(false, false)
        SendNuiMessage(json.encode{
            action = 'close'
        })
    end
end

-- Function to display 3D text above the point
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

RegisterNuiCallback('closeall', function()
    if isUIOpen then
        OpenUI()
    end
end)

-- Callback to handle vehicle spawning
RegisterNuiCallback('lSpawn', function()
    local vehicleModel = 'jugular' -- Vehicle model
    RequestModel(vehicleModel)

    while not HasModelLoaded(vehicleModel) do
        Citizen.Wait(10)
    end

    local spawnLocation
    local maxAttempts = 5 -- Limit of attempts to find a free location
    local attempts = 0

    repeat
        local spawnIndex = math.random(1, #Config.VehicleSpawnLocations)
        spawnLocation = Config.VehicleSpawnLocations[spawnIndex]

        -- Check if a vehicle is already present at this location
        attempts = attempts + 1
    until not IsAnyVehicleNearPoint(spawnLocation.x, spawnLocation.y, spawnLocation.z, 3.0) or attempts >= maxAttempts

    if attempts >= maxAttempts then
        print("Unable to find a free spawn location.")
        return
    end

    -- Create the vehicle at the chosen location
    local car = CreateVehicle(vehicleModel, spawnLocation.x, spawnLocation.y, spawnLocation.z, spawnLocation.heading, false, false)

    if DoesEntityExist(car) then
        TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
    end

    if isUIOpen then
        OpenUI()
    end
end)