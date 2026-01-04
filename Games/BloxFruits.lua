--[[
    BFS Scripts - Blox Fruits Module v2.0
    Auto Farm, Auto Stats, Auto Quest, Safe Mode
]]

local Settings = ...
print("🎮 Cargando módulo de Blox Fruits...")

-- Servicios
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables globales
local BFS = {
    Running = true,
    Farming = false,
    AutoQuest = false,
    AutoStats = false,
    SafeMode = true,
    CurrentQuest = nil,
    SelectedStat = "Melee",
}

-- Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Crear UI mejorada
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BFS_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 550)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
Title.Text = "BFS Scripts v2.0 - Blox Fruits"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botón Auto Farm
local FarmButton = Instance.new("TextButton")
FarmButton.Size = UDim2.new(0.9, 0, 0, 45)
FarmButton.Position = UDim2.new(0.05, 0, 0, 70)
FarmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
FarmButton.Text = "🎯 Auto Farm: OFF"
FarmButton.TextColor3 = Color3.new(1, 1, 1)
FarmButton.TextSize = 16
FarmButton.Font = Enum.Font.GothamBold
FarmButton.Parent = MainFrame

local FarmCorner = Instance.new("UICorner")
FarmCorner.CornerRadius = UDim.new(0, 8)
FarmCorner.Parent = FarmButton

-- Botón Auto Quest
local QuestButton = Instance.new("TextButton")
QuestButton.Size = UDim2.new(0.9, 0, 0, 45)
QuestButton.Position = UDim2.new(0.05, 0, 0, 125)
QuestButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
QuestButton.Text = "📜 Auto Quest: OFF"
QuestButton.TextColor3 = Color3.new(1, 1, 1)
QuestButton.TextSize = 16
QuestButton.Font = Enum.Font.GothamBold
QuestButton.Parent = MainFrame

local QuestCorner = Instance.new("UICorner")
QuestCorner.CornerRadius = UDim.new(0, 8)
QuestCorner.Parent = QuestButton

-- Botón Auto Stats
local StatsButton = Instance.new("TextButton")
StatsButton.Size = UDim2.new(0.9, 0, 0, 45)
StatsButton.Position = UDim2.new(0.05, 0, 0, 180)
StatsButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
StatsButton.Text = "📊 Auto Stats: OFF (Melee)"
StatsButton.TextColor3 = Color3.new(1, 1, 1)
StatsButton.TextSize = 16
StatsButton.Font = Enum.Font.GothamBold
StatsButton.Parent = MainFrame

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsButton

-- Selector de Stats
local StatSelector = Instance.new("Frame")
StatSelector.Size = UDim2.new(0.9, 0, 0, 100)
StatSelector.Position = UDim2.new(0.05, 0, 0, 235)
StatSelector.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
StatSelector.BorderSizePixel = 0
StatSelector.Parent = MainFrame

local StatSelectorCorner = Instance.new("UICorner")
StatSelectorCorner.CornerRadius = UDim.new(0, 8)
StatSelectorCorner.Parent = StatSelector

local StatLabel = Instance.new("TextLabel")
StatLabel.Size = UDim2.new(1, 0, 0, 25)
StatLabel.BackgroundTransparency = 1
StatLabel.Text = "Seleccionar Stat:"
StatLabel.TextColor3 = Color3.new(1, 1, 1)
StatLabel.TextSize = 14
StatLabel.Font = Enum.Font.Gotham
StatLabel.Parent = StatSelector

local stats = {"Melee", "Defense", "Sword", "Gun", "Fruit"}
local statButtons = {}

for i, stat in ipairs(stats) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 0, 30)
    btn.Position = UDim2.new(0.02 + (i-1)*0.196, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = stat
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.Parent = StatSelector
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    statButtons[stat] = btn
end

-- Botón Safe Mode
local SafeButton = Instance.new("TextButton")
SafeButton.Size = UDim2.new(0.9, 0, 0, 45)
SafeButton.Position = UDim2.new(0.05, 0, 0, 345)
SafeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
SafeButton.Text = "🛡️ Safe Mode: ON"
SafeButton.TextColor3 = Color3.new(0, 0, 0)
SafeButton.TextSize = 16
SafeButton.Font = Enum.Font.GothamBold
SafeButton.Parent = MainFrame

local SafeCorner = Instance.new("UICorner")
SafeCorner.CornerRadius = UDim.new(0, 8)
SafeCorner.Parent = SafeButton

-- Stats Info
local StatsInfo = Instance.new("TextLabel")
StatsInfo.Size = UDim2.new(0.9, 0, 0, 70)
StatsInfo.Position = UDim2.new(0.05, 0, 0, 400)
StatsInfo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
StatsInfo.TextColor3 = Color3.new(1, 1, 1)
StatsInfo.TextSize = 12
StatsInfo.Font = Enum.Font.Gotham
StatsInfo.TextWrapped = true
StatsInfo.TextYAlignment = Enum.TextYAlignment.Top
StatsInfo.Text = "Nivel: 0\nMelee: 0 | Defense: 0\nSword: 0 | Gun: 0 | Fruit: 0"
StatsInfo.Parent = MainFrame

local StatsInfoCorner = Instance.new("UICorner")
StatsInfoCorner.CornerRadius = UDim.new(0, 8)
StatsInfoCorner.Parent = StatsInfo

-- Label de estado
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 480)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Estado: Esperando..."
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Botón cerrar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Funciones
local function UpdateStatus(text)
    StatusLabel.Text = "Estado: " .. text
end

local function UpdateStatsInfo()
    local level = Player.Data.Level.Value or 0
    local melee = Player.Data.Stats.Melee.Level.Value or 0
    local defense = Player.Data.Stats.Defense.Level.Value or 0
    local sword = Player.Data.Stats.Sword.Level.Value or 0
    local gun = Player.Data.Stats.Gun.Level.Value or 0
    local fruit = Player.Data.Stats["Demon Fruit"].Level.Value or 0
    
    StatsInfo.Text = string.format(
        "Nivel: %d\nMelee: %d | Defense: %d\nSword: %d | Gun: %d | Fruit: %d",
        level, melee, defense, sword, gun, fruit
    )
end

local function GetNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = math.huge
    
    for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = enemy
            end
        end
    end
    
    return nearestEnemy
end

local function FarmEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 then
        return false
    end
    
    -- Safe Mode: Check health
    if BFS.SafeMode and Humanoid.Health < Humanoid.MaxHealth * 0.5 then
        UpdateStatus("⚠️ Salud baja - Esperando...")
        wait(3)
        return false
    end
    
    -- Teletransportar al enemigo
    local targetPos = enemy.HumanoidRootPart.Position
    HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 10, 0))
    
    -- Atacar
    local tool = Player.Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool:Activate()
    end
    
    return true
end

local function TakeQuest()
    -- Buscar NPCs de quest cerca
    for _, npc in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("ProximityPrompt") then
            local distance = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if distance < 100 then
                -- Teleport al NPC
                HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
                wait(0.5)
                
                -- Intentar tomar quest
                local args = {
                    [1] = "StartQuest",
                    [2] = npc.Name,
                    [3] = 1
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                
                UpdateStatus("📜 Quest tomada: " .. npc.Name)
                return true
            end
        end
    end
    return false
end

local function AllocateStats()
    if not BFS.AutoStats then return end
    
    local points = Player.Data.Points.Value
    if points > 0 then
        local stat = BFS.SelectedStat
        local args = {
            [1] = "AddPoint",
            [2] = stat,
            [3] = points
        }
        
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        UpdateStatus("📊 +" .. points .. " puntos a " .. stat)
        UpdateStatsInfo()
    end
end

local function StartAutoFarm()
    BFS.Farming = true
    UpdateStatus("🎯 Farming activo")
    FarmButton.Text = "🎯 Auto Farm: ON"
    FarmButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    
    spawn(function()
        while BFS.Farming and BFS.Running do
            -- Auto Quest
            if BFS.AutoQuest and not Player.PlayerGui:FindFirstChild("Main").Quest.Visible then
                TakeQuest()
                wait(1)
            end
            
            -- Auto Stats
            AllocateStats()
            
            -- Farm
            local enemy = GetNearestEnemy()
            if enemy then
                UpdateStatus("⚔️ Farmeando: " .. enemy.Name)
                FarmEnemy(enemy)
            else
                UpdateStatus("🔍 Buscando enemigos...")
            end
            
            wait(0.1)
        end
    end)
end

local function StopAutoFarm()
    BFS.Farming = false
    UpdateStatus("⏸️ Farm detenido")
    FarmButton.Text = "🎯 Auto Farm: OFF"
    FarmButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
end

local function ToggleAutoQuest()
    BFS.AutoQuest = not BFS.AutoQuest
    QuestButton.Text = BFS.AutoQuest and "📜 Auto Quest: ON" or "📜 Auto Quest: OFF"
    QuestButton.BackgroundColor3 = BFS.AutoQuest and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(50, 200, 50)
    UpdateStatus(BFS.AutoQuest and "✅ Auto Quest activado" or "❌ Auto Quest desactivado")
end

local function ToggleAutoStats()
    BFS.AutoStats = not BFS.AutoStats
    StatsButton.Text = string.format("📊 Auto Stats: %s (%s)", 
        BFS.AutoStats and "ON" or "OFF", 
        BFS.SelectedStat)
    StatsButton.BackgroundColor3 = BFS.AutoStats and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(50, 200, 50)
    UpdateStatus(BFS.AutoStats and "✅ Auto Stats activado" or "❌ Auto Stats desactivado")
end

local function ToggleSafeMode()
    BFS.SafeMode = not BFS.SafeMode
    SafeButton.Text = BFS.SafeMode and "🛡️ Safe Mode: ON" or "🛡️ Safe Mode: OFF"
    SafeButton.BackgroundColor3 = BFS.SafeMode and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 100, 100)
    UpdateStatus(BFS.SafeMode and "✅ Modo seguro activado" or "❌ Modo seguro desactivado")
end

local function SelectStat(stat)
    BFS.SelectedStat = stat
    
    -- Actualizar colores de botones
    for statName, btn in pairs(statButtons) do
        if statName == stat then
            btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
            btn.TextColor3 = Color3.new(1, 1, 1)
        else
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        end
    end
    
    StatsButton.Text = string.format("📊 Auto Stats: %s (%s)", 
        BFS.AutoStats and "ON" or "OFF", 
        stat)
    UpdateStatus("Stat seleccionado: " .. stat)
end

-- Eventos de botones
FarmButton.MouseButton1Click:Connect(function()
    if BFS.Farming then
        StopAutoFarm()
    else
        StartAutoFarm()
    end
end)

QuestButton.MouseButton1Click:Connect(function()
    ToggleAutoQuest()
end)

StatsButton.MouseButton1Click:Connect(function()
    ToggleAutoStats()
end)

SafeButton.MouseButton1Click:Connect(function()
    ToggleSafeMode()
end)

for statName, btn in pairs(statButtons) do
    btn.MouseButton1Click:Connect(function()
        SelectStat(statName)
    end)
end

CloseButton.MouseButton1Click:Connect(function()
    BFS.Running = false
    ScreenGui:Destroy()
end)

-- Actualizar stats cada 5 segundos
spawn(function()
    while BFS.Running do
        UpdateStatsInfo()
        wait(5)
    end
end)

-- Auto iniciar configuraciones desde Settings
if Settings then
    if Settings.AutoFarm then
        wait(1)
        StartAutoFarm()
    end
    if Settings.AutoQuest then
        wait(0.5)
        ToggleAutoQuest()
    end
    if Settings.AutoStats then
        wait(0.5)
        ToggleAutoStats()
    end
    if Settings.SafeMode ~= nil then
        BFS.SafeMode = Settings.SafeMode
        SafeButton.Text = BFS.SafeMode and "🛡️ Safe Mode: ON" or "🛡️ Safe Mode: OFF"
        SafeButton.BackgroundColor3 = BFS.SafeMode and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 100, 100)
    end
end

-- Inicializar selección de stat
SelectStat(BFS.SelectedStat)

print("✅ BFS Scripts v2.0 cargado completamente!")
print("⌨️ Usa la interfaz en pantalla para controlar el script")
print("🎮 Características: Auto Farm, Auto Quest, Auto Stats, Safe Mode")
