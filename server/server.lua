local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("wonev:GiveDoor", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("wonev_kapi", 1)
    end

end)

RegisterNetEvent("wonev:GiveBonnet", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("wonev_kaput", 1)
    end

end)

RegisterNetEvent("wonev:GiveBoot", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("wonev_bagaj", 1)
    end

end)

RegisterNetEvent("wonev:GiveEngine", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("wonev_motor", 1)
    end

end)
RegisterNetEvent("wonev:GiveWheel", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem("wonev_lastik", 1)
    end

end)

QBCore.Functions.CreateUseableItem('wonev_kriko', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player.Functions.GetItemByName("wonev_kriko") then return end
    TriggerClientEvent("wonev:jackVehicle", source)
end)