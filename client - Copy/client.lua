local QBCore = exports['qb-core']:GetCoreObject()

local active = false
local cord = Config.Coords[math.random(1, #Config.Coords)]
local cord2 = Config.ShreddingCoordinates
local vehicle = nil
local Blip1 = nil
local Blip2 = nil
local pedCreated = false
local OneSpawn = true
local VehicleDestroyStarting = false
local SelectedStandart = false
local SelectedMedium = false
local SelectedAdvanced = false
local StartOther = false
local engine = true
local WheelTime = false
local UseJack = false
local AnyVehicle = nil
local DistableAction= false

local function NpcCreate()
    RequestModel(GetHashKey(Config.Ped))
    while not HasModelLoaded(GetHashKey(Config.Ped)) do
        Wait(1)
    end
    npc = CreatePed(1, GetHashKey(Config.Ped), Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z - 1,
        Config.PedLocation.rotation, Config.PedLocation.NetworkSync, false, true)
    SetPedCombatAttributes(npc, 46, true)
    SetPedFleeAttributes(npc, 0, 0)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityAsMissionEntity(npc, true, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)

end

function VehicleSpawn()
    local carmodel
    if SelectedStandart then
        carmodel = Config.StandartVehicles[math.random(1, #Config.StandartVehicles)]
    elseif SelectedMedium then
        carmodel = Config.MediumVehicles[math.random(1, #Config.MediumVehicles)]
    else
        carmodel = Config.AdvancedVehicles[math.random(1, #Config.AdvancedVehicles)]
    end
    local hash = GetHashKey(carmodel)
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(500)
    end

    vehicle = CreateVehicle(carmodel, cord.x, cord.y, cord.z, 349, 44, 0, 0)
    exports["LegacyFuel"]:SetFuel(vehicle, 100)
    SetVehicleEngineHealth(carmodel, 1000.0)
    SetVehicleFixed(carmodel)
    SetVehicleDeformationFixed(carmodel)

    return vehicle
end

function CreateBlip()
    Blip1 = AddBlipForCoord(cord.x, cord.y, cord.z)
    SetBlipSprite(Blip1, 1)
    SetBlipColour(Blip1, 3)
    SetBlipScale(Blip1, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vehicle Location")
    EndTextCommandSetBlipName(Blip1)
    SetBlipRoute(Blip1, true)
    SetBlipRouteColour(Blip1, 3)
    SetNewWaypoint(cord.x, cord.y)
end

function CreateBlip2()
    Blip2 = AddBlipForCoord(cord2.x, cord2.y, cord2.z)
    SetBlipSprite(Blip2, 1)
    SetBlipColour(Blip2, 3)
    SetBlipScale(Blip2, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vehicle Coords")
    EndTextCommandSetBlipName(Blip2)
    SetBlipRoute(Blip2, true)
    SetBlipRouteColour(Blip2, 3)
    SetNewWaypoint(cord2.x, cord2.y)
end

CreateThread(function()
    while true do
        local sleep = 2000
        if not active then

            local Player = PlayerPedId()
            local PlayerCoords = GetEntityCoords(Player)
            local distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z,
                Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)

            if Config.PedInteraction == "DrawText" then
                if OneSpawn then
                    NpcCreate()
                    OneSpawn = false
                end
                if distance < 5 then
                    sleep = 1
                    DrawText3D(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z + 0.2,
                        "[~g~E~w~] - Süleyman Abi İle Konuş")
                    if distance < 1.5 then
                        if IsControlJustPressed(0, 38) then
                            TriggerEvent("wonev:givetask")
                        end
                    end
                end
            elseif Config.PedInteraction == "Target" then
                if not pedCreated then
                    exports['qb-target']:SpawnPed({
                        model = 'ig_josef',
                        coords = vector4(2806.37, -713.04, 3.25, 318.25),
                        minusOne = true,
                        freeze = true,
                        invincible = true,
                        blockevents = true,
                        scenario = '',
                        target = {
                            options = {{
                                type = "client",
                                event = "wonev:givetask",
                                icon = 'fas fa-user-secret',
                                label = 'Süleyman Abi İle Konuş'
                            }},
                            distance = 1.5
                        }
                    })
                    pedCreated = true
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("wonev:givetask", function()
    if not active then
        local mainMenu = {{
            header = "Stadart Level",
            txt = " Aracın Anahtarı Verilir Ve %50 İhtimalle Polise Bildirim Gider.",
            params = {
                event = "wonev:StandardLevel"
            }
        }, {
            header = "Orta Level",
            txt = "Aracın Anahtarı Verilir Ve  Polise Bildirim Gider.",
            params = {
                event = "wonev:MediumLevel"
            }
        }, {
            header = "Gelişmiş Level",
            txt = "Aracın Anahtarı Verilmez Ve %50 İhtimalle Polise Bildirim Gider.",
            params = {
                event = "wonev:AdvancedLevel"
            }
        }}
        TriggerEvent('qb-menu:client:openMenu', mainMenu)
    end
end)

RegisterNetEvent("wonev:StandardLevel", function()
    if not active then
        SelectedStandart = true
        VehicleSpawn()
        CreateBlip()
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
        QBCore.Functions.Notify("Aracın Kordinatları Haritada İşaretlendi.", "success", 3500)
        active = true

    end
end)

RegisterNetEvent("wonev:MediumLevel", function()
    if not active then
        SelectedMedium = true
        VehicleSpawn()
        CreateBlip()
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
        QBCore.Functions.Notify("Aracın Kordinatları Haritada İşaretlendi.", "success", 3500)
        active = true

    end
end)

RegisterNetEvent("wonev:AdvancedLevel", function()
    if not active then
        SelectedAdvanced = true
        VehicleSpawn()
        CreateBlip()
        QBCore.Functions.Notify("Aracın Kordinatları Haritada İşaretlendi.", "success", 3500)
        active = true
    end
end)

CreateThread(function()
    while true do
        local sleep = 2000
        if active then
            local Player = PlayerPedId()
            local PlayerCoords = GetEntityCoords(Player)
            local distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, cord.x, cord.y,
                cord.z)
            local distance2 = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, cord2.x, cord2.y,
                cord2.z)

            if distance < 3 then
                if Blip1 then
                    RemoveBlip(Blip1)
                    Blip1 = nil
                    CreateBlip2()
                    QBCore.Functions.Notify("Arac Parcalama Kordinatı Haritada İşaretlendi.", "success", 2500)
                end
            end
            if distance2 < 5 then
                if Blip2 then
                    RemoveBlip(Blip2)
                    Blip2 = nil
                    if not VehicleDestroyStarting then
                        VehicleDestroyStarting = true
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

local chopDoorParts = {
    {part = 0, bone = 'door_dside_f', text = 'Sol Ön Kapı'}, 
    {part = 1, bone = 'door_pside_f', text = 'Sağ Ön Kapı'},
    {part = 2, bone = 'door_dside_r', text = 'Sol Arka Kapı'}, 
    {part = 3,bone = 'door_pside_r',text = 'Sağ Arka Kapı'}
}
local OtherParts = {
    {part = 4,bone = 'bonnet',text = 'Kaput'}, 
    {part = 5,bone = 'boot',text = 'Bagaj'}, 
    {part = 6,bone = 'engine',text = 'Motor'}
}

CreateThread(function()
    while true do
        local sleep = 2000
        if VehicleDestroyStarting then
            local Player = PlayerPedId()
            local PlayerCoords = GetEntityCoords(Player)
            local distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, cord2.x, cord2.y,
                cord2.z)
            local PedIsIn = IsPedInAnyVehicle(Player, false)
            if distance <= 10 then
                sleep = 500
                -- if PedIsIn then
                --     exports['qb-core']:DrawText('Aracı Parçalamak İçin Araçtan İn', 'left')
                -- elseif not PedIsIn then
                --     exports['qb-core']:HideText()
                -- end
                if not PedIsIn then
                    for index, part in pairs(chopDoorParts) do
                        local boneindex = GetEntityBoneIndexByName(vehicle, part.bone)
                        if boneindex == -1 then
                            table.remove(chopDoorParts, index)
                        end
                        if boneindex ~= -1 then
                            local bonecoords = GetWorldPositionOfEntityBone(vehicle, boneindex)
                            local distanceBone = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, bonecoords.x, bonecoords.y, bonecoords.z)
                            if distanceBone < 2.0 then
                                sleep = 1
                                DrawText3D(bonecoords.x, bonecoords.y, bonecoords.z, "[E] " .. part.text .. "yı  Parçala")
                                if distanceBone < 1.0 then
                                    if IsControlJustReleased(0, 38)  then
                                        TriggerEvent("wonev:BrokenDoor", part)
                                        table.remove(chopDoorParts, index)
                                        if #chopDoorParts == 0 then
                                            print("tammadır")
                                            StartOther = true
                                        end
                                        break
                                    end
                                end

                            end
                        end

                    end
                    if StartOther then
                        for index, part in pairs(OtherParts) do
                            local boneindex = GetEntityBoneIndexByName(vehicle, part.bone)
                            if boneindex ~= -1 then
                                sleep = 1
                                local bonecoords = GetWorldPositionOfEntityBone(vehicle, boneindex)
                                if #(PlayerCoords - bonecoords) < 2 then
                                    DrawText3D(bonecoords.x, bonecoords.y, bonecoords.z,
                                        "[E] " .. part.text .. "u  Parçala")
                                    if IsControlJustReleased(0, 38) and not DistableAction then
                                        TriggerEvent("wonev:BrokenOther", part)
                                        table.remove(OtherParts, index)
                                        if #OtherParts == 0 then
                                            print("bagaj ve kaput silindi")
                                            StartOther = false
                                        end
                                        -- Kaput Gözükmüyor --
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if not engine then
            if vehicle and vehicle ~= 0 then
                sleep = 10
                SetVehicleEngineHealth(vehicle, 0.0)
                SetVehicleEngineOn(vehicle, false, false, true)
                if not UseJack then
                    UseJack = true
                end
            end
        end

        Wait(sleep)
    end

end)

RegisterNetEvent('wonev:jackVehicle')
AddEventHandler('wonev:jackVehicle', function()
    if DoesEntityExist(AnyVehicle) and not IsPedInAnyVehicle(playerPed, true) then
        if UseJack then
            print("aaaaaa")
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            AnyVehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, 0, 71)
            local hasPassenger = false
            local numOfSeats = GetVehicleModelNumberOfSeats(GetEntityModel(AnyVehicle))

            for i = -1, (numOfSeats - 2) do
                if not IsVehicleSeatFree(AnyVehicle, i) then
                    hasPassenger = true
                    break
                end
            end

            if hasPassenger then
                QBCore.Functions.Notify("Araçta biri olduğu için kriko kullanamazsın!", "error")
                return
            end
            TriggerEvent("wonev:UseJack")
        end
    end

    -- else
    --     QBCore.Functions.Notify("Yakında bir araç yok!", "error")
    -- end
end)

RegisterNetEvent("wonev:UseJack", function()
    QBCore.Functions.Progressbar("UseJack", "Aracı Havaya Kaldırıyorsun ", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
    }, {
        animDict = "amb@prop_human_bum_bin@base",
        anim = "base",
        flags = 49
    }, {}, {}, function()
        FreezeEntityPosition(AnyVehicle, true)
        local vehCoords = GetEntityCoords(AnyVehicle)
        SetEntityCoordsNoOffset(AnyVehicle, vehCoords.x, vehCoords.y, vehCoords.z + 0.3, true, false, false, true)

        local object = CreateObject(GetHashKey("prop_carjack"), vehCoords.x, vehCoords.y, vehCoords.z - 0.5, true, true,
            true)
        FreezeEntityPosition(object, true)
        WheelTime = true

    end, function()
        print("Transaction canceled!")
    end)

end)

RegisterNetEvent("wonev:BrokenDoor", function(part)

    if DoesEntityExist(vehicle) and part and part.text and part.part then
        local Player = PlayerPedId()
        TaskStartScenarioInPlace(Player, "WORLD_HUMAN_WELDING", 0, true)
        QBCore.Functions.Progressbar("Remove_door", part.text .. "yı Parçalıyorsun ", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            TriggerServerEvent("wonev:GiveDoor")
            SetVehicleDoorBroken(vehicle, part.part, true)
            ClearPedTasks(Player)

        end, function()
            print("Transaction canceled!")
        end)

    end
end)

RegisterNetEvent("wonev:BrokenOther", function(part)
    if part and part.text and part.part then
        local Player = PlayerPedId()
        if part.part == 4 or part.part == 5 then
            TaskStartScenarioInPlace(Player, "WORLD_HUMAN_WELDING", 0, true)
            QBCore.Functions.Progressbar("Remove_Others", part.text .. "u Parçalıyorsun ", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }, {}, {}, {}, function()
                if part.part == 4 then
                    TriggerServerEvent("wonev:GiveBonnet")
                else
                    TriggerServerEvent("wonev:GiveBoot")
                end

                SetVehicleDoorBroken(vehicle, part.part, true)
                ClearPedTasks(Player)

            end, function()
                print("Transaction canceled!")
            end)
        elseif part.part == 6 then
            QBCore.Functions.Progressbar("Remove_Engine", "Motoru Parçalıyorsun ", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }, {
                animDict = "amb@prop_human_bum_bin@base",
                anim = "base",
                flags = 49
            }, {}, {}, function()
                TriggerServerEvent("wonev:GiveEngine")
                if engine then
                    engine = false
                end
            end, function()
                print("Transaction canceled!")
            end)
        end

    end
end)

local WheelParts = {
    {part = 0, bone = 'wheel_lf', text = 'Front Left Wheel', prop = "prop_wheel_01"}, 
    {part = 4, bone = 'wheel_lr', text = 'Rear Left Wheel', prop = "prop_wheel_01"}, 
    {part = 5, bone = 'wheel_rr', text = 'Rear Right Wheel', prop = "prop_wheel_01"}, 
    {part = 1, bone = 'wheel_rf', text = 'Front Right Wheel', prop = "prop_wheel_01"}
}

CreateThread(function()
    while true do
        local sleep = 2000
        if WheelTime then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for index, part in pairs(WheelParts) do
                local boneindex = GetEntityBoneIndexByName(vehicle, part.bone)
                if boneindex == -1 then
                    table.remove(chopDoorParts, index)
                end
                if boneindex ~= -1 then
                    sleep = 1
                    local bonecoords = GetWorldPositionOfEntityBone(vehicle, boneindex)
                    if #(PlayerCoords - bonecoords) < 1.0 then
                        DrawText3D(bonecoords.x, bonecoords.y, bonecoords.z, "[E] Tekerleği Sök")
                        if IsControlJustPressed(0, 38) then
                            TriggerEvent("wonev:BrokenWheels", part)
                        end

                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("wonev:BrokhenWheels", function(part)
    if WheelTime and part and part.text and part.part then
        QBCore.Functions.Progressbar("Remove_Wheels", "Tekerleği Söküyorsun ", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {
            animDict = "amb@prop_human_bum_bin@base",
            anim = "base",
            flags = 49
        }, {}, {}, function()
            TriggerServerEvent("wonev:GiveWheel")
            SetVehicleWheelsCanBreak(vehicle, part.part)

        end, function()
            print("Transaction canceled!")
        end)
    end

end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.50, 0.50)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 255)
    SetDrawOrigin(x, y, z, 0)

    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawText(0.0, 0.0)

    ClearDrawOrigin()
end
