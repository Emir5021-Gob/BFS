-- BFS Simple Hub - Solo Teleports y Cofres
-- Optimizado para Delta Executor

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- Detectar Sea actual
local function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1
    elseif placeId == 4442272183 then return 2
    elseif placeId == 7449423635 then return 3
    end
    return 1
end

local CurrentSea = GetCurrentSea()

-- Variables globales
local Settings = {
    AutoChest = false,
    TweenSpeed = 300
}

-- Función de notificación
local function Notify(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 3;
    })
end

-- Función de Tween (teleport suave)
local function TweenTo(targetCFrame)
    local Character = Player.Character
    if not Character then return end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    local distance = (HRP.Position - targetCFrame.Position).Magnitude
    local duration = distance / Settings.TweenSpeed
    
    local tween = TweenService:Create(
        HRP,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    
    tween:Play()
    tween.Completed:Wait()
end

-- Lista de islas por Sea
local Islands = {
    [1] = { -- Sea 1
        {Name = "Starter Island", CFrame = CFrame.new(1071, 16, 1426)},
        {Name = "Jungle", CFrame = CFrame.new(-1150, 38, -130)},
        {Name = "Pirate Village", CFrame = CFrame.new(-1246, 45, 3669)},
        {Name = "Desert", CFrame = CFrame.new(1094, 6, 4192)},
        {Name = "Frozen Village", CFrame = CFrame.new(1198, 87, -1298)},
        {Name = "Marine Fortress", CFrame = CFrame.new(-2849, 22, -2847)},
        {Name = "Skylands", CFrame = CFrame.new(-4813, 717, -2623)},
        {Name = "Prison", CFrame = CFrame.new(4854, 5, 734)},
        {Name = "Colosseum", CFrame = CFrame.new(-1787, 7, -2842)},
        {Name = "Magma Village", CFrame = CFrame.new(-5247, 12, 8504)},
        {Name = "Underwater City", CFrame = CFrame.new(61123, 11, 1819)},
        {Name = "Upper Skylands", CFrame = CFrame.new(-7894, 5545, -380)},
        {Name = "Fountain City", CFrame = CFrame.new(5127, 37, 4050)}
    },
    [2] = { -- Sea 2
        {Name = "Kingdom of Rose", CFrame = CFrame.new(-380, 37, 298)},
        {Name = "Cafe", CFrame = CFrame.new(-382, 73, 297)},
        {Name = "Mansion", CFrame = CFrame.new(-12471, 374, -7551)},
        {Name = "Graveyard", CFrame = CFrame.new(-8653, 142, 6174)},
        {Name = "Snow Mountain", CFrame = CFrame.new(749, 408, -5274)},
        {Name = "Hot and Cold", CFrame = CFrame.new(-6063, 15, -5127)},
        {Name = "Cursed Ship", CFrame = CFrame.new(923, 125, 32885)},
        {Name = "Ice Castle", CFrame = CFrame.new(5669, 28, -6481)},
        {Name = "Forgotten Island", CFrame = CFrame.new(-3053, 240, -10148)},
        {Name = "Dark Arena", CFrame = CFrame.new(3780, 91, -3917)}
    },
    [3] = { -- Sea 3
        {Name = "Port Town", CFrame = CFrame.new(-290, 6, 5343)},
        {Name = "Hydra Island", CFrame = CFrame.new(5749, 611, -276)},
        {Name = "Great Tree", CFrame = CFrame.new(2681, 1682, -7190)},
        {Name = "Castle on the Sea", CFrame = CFrame.new(-5075, 314, -2991)},
        {Name = "Haunted Castle", CFrame = CFrame.new(-9515, 142, 5535)},
        {Name = "Sea Castle", CFrame = CFrame.new(-5073, 314, -2991)},
        {Name = "Tiki Outpost", CFrame = CFrame.new(-16542, 55, 1044)},
        {Name = "Floating Turtle", CFrame = CFrame.new(-13274, 332, -7418)}
    }
}

-- Buscar cofres
local function GetNearestChest()
    local nearestChest = nil
    local shortestDistance = math.huge
    
    local Character = Player.Character
    if not Character then return nil end
    
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return nil end
    
    -- Buscar en workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name == "Chest1" or obj.Name == "Chest2" or obj.Name == "Chest3" or obj.Name:find("Chest")) then
            local chestRoot = obj:FindFirstChild("Root") or obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if chestRoot then
                local distance = (HRP.Position - chestRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestChest = obj
                end
            end
        end
    end
    
    return nearestChest
end

-- Auto Chest
local ChestConnection
local lastChestTime = 0
local function StartAutoChest()
    if ChestConnection then return end
    
    ChestConnection = task.spawn(function()
        while Settings.AutoChest do
            local success, result = pcall(function()
                local chest = GetNearestChest()
                if chest then
                    local chestRoot = chest:FindFirstChild("Root") or chest:FindFirstChild("HumanoidRootPart") or chest.PrimaryPart
                    if chestRoot and tick() - lastChestTime > 1 then
                        local Character = Player.Character
                        if Character and Character:FindFirstChild("HumanoidRootPart") then
                            Character.HumanoidRootPart.CFrame = chestRoot.CFrame
                            lastChestTime = tick()
                            task.wait(1)
                        end
                    end
                else
                    task.wait(0.5)
                end
            end)
            
            if not success then
                task.wait(1)
            end
            
            task.wait(0.1)
        end
    end)
end

local function StopAutoChest()
    Settings.AutoChest = false
    ChestConnection = nil
end

-- Crear UI
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BFSHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Header.BorderSizePixel = 0
    Header.Font = Enum.Font.GothamBold
    Header.Text = "🎯 BFS Hub - Sea " .. CurrentSea
    Header.TextColor3 = Color3.fromRGB(255, 255, 255)
    Header.TextSize = 16
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header
    
    -- ScrollFrame
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.Parent = MainFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = ScrollFrame
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Función para crear toggle
    local function CreateToggle(text, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = ScrollFrame
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -55, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.Gotham
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(200, 200, 200)
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = ToggleFrame
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 40, 0, 20)
        Button.Position = UDim2.new(1, -45, 0.5, -10)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Button.BorderSizePixel = 0
        Button.Text = ""
        Button.Parent = ToggleFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(1, 0)
        ButtonCorner.Parent = Button
        
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 16, 0, 16)
        Indicator.Position = UDim2.new(0, 2, 0.5, -8)
        Indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Button
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = Indicator
        
        local Enabled = false
        
        Button.MouseButton1Click:Connect(function()
            Enabled = not Enabled
            
            if Enabled then
                Button.BackgroundColor3 = Color3.fromRGB(60, 180, 255)
                Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Indicator.Position = UDim2.new(1, -18, 0.5, -8)
            else
                Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                Indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                Indicator.Position = UDim2.new(0, 2, 0.5, -8)
            end
            
            callback(Enabled)
        end)
    end
    
    -- Función para crear botón de teleport
    local function CreateTeleportButton(text, targetCFrame)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
        ButtonFrame.BackgroundTransparency = 1
        ButtonFrame.Parent = ScrollFrame
        
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
        Button.BorderSizePixel = 0
        Button.Font = Enum.Font.GothamBold
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 12
        Button.Parent = ButtonFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(80, 140, 240)
            TweenTo(targetCFrame)
            wait(0.2)
            Button.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
        end)
    end
    
    -- Función para crear sección
    local function CreateSection(text)
        local Section = Instance.new("TextLabel")
        Section.Size = UDim2.new(1, 0, 0, 25)
        Section.BackgroundTransparency = 1
        Section.Font = Enum.Font.GothamBold
        Section.Text = text
        Section.TextColor3 = Color3.fromRGB(255, 255, 255)
        Section.TextSize = 14
        Section.TextXAlignment = Enum.TextXAlignment.Left
        Section.Parent = ScrollFrame
    end
    
    -- Crear contenido
    CreateSection("📦 AUTO FARM")
    CreateToggle("Auto Chest", function(value)
        Settings.AutoChest = value
        if value then
            StartAutoChest()
            Notify("Auto Chest", "Activado")
        else
            StopAutoChest()
            Notify("Auto Chest", "Desactivado")
        end
    end)
    
    CreateSection("🗺️ TELEPORT ISLAS")
    
    local currentSeaIslands = Islands[CurrentSea]
    if currentSeaIslands then
        for _, island in ipairs(currentSeaIslands) do
            CreateTeleportButton("📍 " .. island.Name, island.CFrame)
        end
    end
end

-- Inicializar
Notify("BFS Hub", "Cargando Sea " .. CurrentSea)
wait(0.5)
CreateUI()
Notify("✅ Listo", "Auto Chest y Teleports activos")
