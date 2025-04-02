RegisterNetEvent('Llocation:vehicleDespawn')
AddEventHandler('Llocation:vehicleDespawn', function()
    local source = source
    local playerPed = GetPlayerPed(source)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        DeleteEntity(vehicle) -- Supprimer le véhicule
    end
end)