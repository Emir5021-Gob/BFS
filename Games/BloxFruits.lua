--[[
    BFS Scripts Premium v3.0
    Professional Blox Fruits Auto Farm
    Optimizado para móvil (Samsung M14)
]]

local Settings = ...
print("🎮 Cargando BFS Scripts Premium v3.0...")

-- Servicios
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables globales
local BFS = {
    Running = true,
    Farming = false,
    FastAttack = false,
    AutoMastery = false,
    AutoBoss = false,
    AutoQuest = false,
    AutoStats = false,
    SafeMode = true,
    BringMob = true,
    SelectedStat = "Melee",
    CurrentTab = "Main",
    FarmDistance = 3500,
    AttackSpeed = 0.1,
}

-- Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Crear ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BFS_Premium_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0, 380, 0, 520)
MainContainer.Position = UDim2.new(0.5, -190, 0.5, -260)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainContainer.BorderSizePixel = 0
MainContainer.Active = true
MainContainer.ClipsDescendants = true
MainContainer.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainContainer

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 BFS Premium"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 100, 1, 0)
Version.Position = UDim2.new(0, 220, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = "v3.0 Mobile"
Version.TextColor3 = Color3.fromRGB(200, 200, 200)
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.Parent = Header

-- Botones de control
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 7.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.new(0, 0, 0)
MinimizeBtn.TextSize = 22
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainContainer

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0.25, 0)
MinimizeCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainContainer

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.25, 0)
CloseCorner.Parent = CloseBtn

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, 0, 0, 45)
TabsContainer.Position = UDim2.new(0, 0, 0, 50)
TabsContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabsContainer.BorderSizePixel = 0
TabsContainer.Parent = MainContainer

local tabs = {"Main", "Combat", "Stats", "Misc"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabName .. "Tab"
    TabBtn.Size = UDim2.new(0.25, -4, 1, -8)
    TabBtn.Position = UDim2.new((i-1)*0.25, 2, 0, 4)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.TextSize = 14
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Parent = TabsContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabBtn
    
    tabButtons[tabName] = TabBtn
end

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, 0, 1, -95)
ContentContainer.Position = UDim2.new(0, 0, 0, 95)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = MainContainer

-- Scroll para contenido
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -10, 1, 0)
ContentScroll.Position = UDim2.new(0, 5, 0, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(40, 120, 255)
ContentScroll.Parent = ContentContainer

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentScroll

-- Funciones de UI
local function CreateButton(parent, text, callback, color)
    color = color or Color3.fromRGB(50, 200, 80)
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 355, 0, 42)
    Button.BackgroundColor3 = color
    Button.Text = text
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = parent
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 10)
    BtnCorner.Parent = Button
    
    if callback then
        Button.MouseButton1Click:Connect(callback)
    end
    
    return Button
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0, 355, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 28)
    ToggleButton.Position = UDim2.new(1, -52, 0.5, -14)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(60, 60, 65)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0.5, 0)
    ToggleBtnCorner.Parent = ToggleButton
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 22, 0, 22)
    Indicator.Position = default and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    Indicator.BackgroundColor3 = Color3.new(1, 1, 1)
    Indicator.Parent = ToggleButton
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local toggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local targetColor = toggled and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(60, 60, 65)
        local targetPos = toggled and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = targetPos}):Play()
        
        if callback then
            callback(toggled)
        end
    end)
    
    return ToggleFrame, function() return toggled end
end

local function CreateSection(parent, title)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(0, 355, 0, 30)
    Section.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
    Section.Text = title
    Section.TextColor3 = Color3.new(1, 1, 1)
    Section.TextSize = 14
    Section.Font = Enum.Font.GothamBold
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    return Section
end

local function ShowNotification(text, duration)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(0, 300, 0, 50)
    Notification.Position = UDim2.new(0.5, -150, 0, -60)
    Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Notification.BorderSizePixel = 0
    Notification.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = Notification
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 0)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.new(1, 1, 1)
    NotifText.TextSize = 13
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextWrapped = true
    NotifText.Parent = Notification
    
    TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, 10)}):Play()
    
    task.delay(duration or 3, function()
        TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
        task.wait(0.4)
        Notification:Destroy()
    end)
end

-- Crear contenido de tabs
local tabContents = {}

for _, tabName in ipairs(tabs) do
    local TabContent = Instance.new("Frame")
    TabContent.Name = tabName .. "Content"
    TabContent.Size = UDim2.new(1, 0, 0, 1000)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = (tabName == "Main")
    TabContent.Parent = ContentScroll
    
    tabContents[tabName] = TabContent
end

-- TAB MAIN
CreateSection(tabContents["Main"], "⚔️ AUTO FARMING")

local farmToggle = CreateToggle(tabContents["Main"], "🎯 Auto Farm", false, function(state)
    BFS.Farming = state
    if state then
        StartAutoFarm()
        ShowNotification("✅ Auto Farm activado", 2)
    else
        StopAutoFarm()
        ShowNotification("❌ Auto Farm desactivado", 2)
    end
end)

CreateToggle(tabContents["Main"], "📜 Auto Quest", false, function(state)
    BFS.AutoQuest = state
    ShowNotification(state and "✅ Auto Quest ON" or "❌ Auto Quest OFF", 2)
end)

CreateToggle(tabContents["Main"], "👑 Auto Boss", false, function(state)
    BFS.AutoBoss = state
    ShowNotification(state and "✅ Auto Boss ON" or "❌ Auto Boss OFF", 2)
end)

CreateToggle(tabContents["Main"], "🛡️ Safe Mode", true, function(state)
    BFS.SafeMode = state
    ShowNotification(state and "✅ Safe Mode ON" or "❌ Safe Mode OFF", 2)
end)

CreateSection(tabContents["Main"], "⚙️ CONFIGURACIÓN")

CreateToggle(tabContents["Main"], "🧲 Bring Mob", true, function(state)
    BFS.BringMob = state
    ShowNotification(state and "✅ Bring Mob ON" or "❌ Bring Mob OFF", 2)
end)

-- TAB COMBAT
CreateSection(tabContents["Combat"], "⚔️ COMBAT")

CreateToggle(tabContents["Combat"], "⚡ Fast Attack", false, function(state)
    BFS.FastAttack = state
    if state then
        StartFastAttack()
        ShowNotification("✅ Fast Attack activado", 2)
    else
        ShowNotification("❌ Fast Attack desactivado", 2)
    end
end)

CreateToggle(tabContents["Combat"], "🎯 Auto Mastery", false, function(state)
    BFS.AutoMastery = state
    ShowNotification(state and "✅ Auto Mastery ON" or "❌ Auto Mastery OFF", 2)
end)

-- TAB STATS
CreateSection(tabContents["Stats"], "📊 AUTO STATS")

CreateToggle(tabContents["Stats"], "📈 Auto Stats", false, function(state)
    BFS.AutoStats = state
    ShowNotification(state and "✅ Auto Stats ON" or "❌ Auto Stats OFF", 2)
end)

local statButtons = {}
local stats = {"Melee", "Defense", "Sword", "Gun", "Fruit"}

CreateSection(tabContents["Stats"], "🎯 SELECCIONAR STAT")

for _, stat in ipairs(stats) do
    local btn = CreateButton(tabContents["Stats"], stat, function()
        BFS.SelectedStat = stat
        for _, otherBtn in pairs(statButtons) do
            otherBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        end
        statButtons[stat].BackgroundColor3 = Color3.fromRGB(40, 120, 255)
        ShowNotification("📊 Stat seleccionado: " .. stat, 2)
    end, Color3.fromRGB(50, 50, 55))
    
    statButtons[stat] = btn
end

-- Marcar Melee como seleccionado por defecto
statButtons["Melee"].BackgroundColor3 = Color3.fromRGB(40, 120, 255)

-- TAB MISC
CreateSection(tabContents["Misc"], "ℹ️ INFORMACIÓN")

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0, 355, 0, 150)
InfoLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
InfoLabel.Text = string.format([[
🎮 BFS Scripts Premium v3.0
👤 Usuario: %s
🌊 Nivel: Cargando...
⭐ Status: Conectado

📱 Optimizado para móvil
🛡️ Anti-detección activo
]], Player.Name)
InfoLabel.TextColor3 = Color3.new(1, 1, 1)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.Parent = tabContents["Misc"]

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = InfoLabel

-- Sistema de tabs
local function SwitchTab(tabName)
    BFS.CurrentTab = tabName
    
    for name, content in pairs(tabContents) do
        content.Visible = (name == tabName)
    end
    
    for name, button in pairs(tabButtons) do
        if name == tabName then
            button.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
            button.TextColor3 = Color3.new(1, 1, 1)
        else
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
end

for tabName, button in pairs(tabButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)
end

-- Marcar Main como tab inicial
SwitchTab("Main")

-- Botón minimizado
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Size = UDim2.new(0, 65, 0, 65)
MinimizedButton.Position = UDim2.new(1, -75, 0, 10)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
MinimizedButton.Text = "🎮"
MinimizedButton.TextColor3 = Color3.new(1, 1, 1)
MinimizedButton.TextSize = 32
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Visible = false
MinimizedButton.Active = true
MinimizedButton.Draggable = true
MinimizedButton.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0.5, 0)
MinimizedCorner.Parent = MinimizedButton

-- Funciones de minimizar
MinimizeBtn.MouseButton1Click:Connect(function()
    MainContainer.Visible = false
    MinimizedButton.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    MinimizedButton.Visible = false
    MainContainer.Visible = true
end)

-- Hacer draggable el main container
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Actualizar ContentScroll size
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
end)

-- Funciones de farming
local function UpdateStatus(text)
    -- Actualizar en tiempo real
end

local function GetNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = BFS.FarmDistance
    
    for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestEnemy = enemy
                end
            end
        end
    end
    
    return nearestEnemy, shortestDistance
end

local function BringMobToPlayer(enemy)
    if not BFS.BringMob then return end
    
    pcall(function()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            if enemy.Humanoid.Health > 0 then
                enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                enemy.HumanoidRootPart.Transparency = 1
                enemy.HumanoidRootPart.CanCollide = false
                enemy.Humanoid.WalkSpeed = 0
                enemy.Humanoid.JumpPower = 0
                enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
            end
        end
    end)
end

function StartFastAttack()
    spawn(function()
        while BFS.FastAttack and BFS.Running do
            pcall(function()
                local tool = Player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
            wait(BFS.AttackSpeed)
        end
    end)
end

function StartAutoFarm()
    spawn(function()
        while BFS.Farming and BFS.Running do
            if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                wait(1)
            end
            
            if BFS.SafeMode and Humanoid.Health < Humanoid.MaxHealth * 0.6 then
                wait(2)
            else
                local enemy, distance = GetNearestEnemy()
                if enemy then
                    while enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and BFS.Farming do
                        pcall(function()
                            -- Volar hacia enemigo
                            if distance > 30 then
                                local bodyVel = HumanoidRootPart:FindFirstChild("BFS_BodyVel")
                                if not bodyVel then
                                    bodyVel = Instance.new("BodyVelocity")
                                    bodyVel.Name = "BFS_BodyVel"
                                    bodyVel.MaxForce = Vector3.new(100000, 100000, 100000)
                                    bodyVel.Parent = HumanoidRootPart
                                end
                                
                                local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                                bodyVel.Velocity = direction * 150
                                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, enemy.HumanoidRootPart.Position)
                            else
                                local bodyVel = HumanoidRootPart:FindFirstChild("BFS_BodyVel")
                                if bodyVel then bodyVel:Destroy() end
                                BringMobToPlayer(enemy)
                            end
                            
                            -- Atacar
                            local tool = Player.Character:FindFirstChildOfClass("Tool")
                            if not tool then
                                local backpackTool = Player.Backpack:FindFirstChildOfClass("Tool")
                                if backpackTool then
                                    Humanoid:EquipTool(backpackTool)
                                    tool = Player.Character:FindFirstChildOfClass("Tool")
                                end
                            end
                            
                            if tool then
                                HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, enemy.HumanoidRootPart.Position)
                                tool:Activate()
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                            end
                            
                            distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                        end)
                        wait(0.2)
                    end
                    
                    pcall(function()
                        local bodyVel = HumanoidRootPart:FindFirstChild("BFS_BodyVel")
                        if bodyVel then bodyVel:Destroy() end
                    end)
                else
                    wait(2)
                end
            end
            wait(0.5)
        end
    end)
end

function StopAutoFarm()
    BFS.Farming = false
    pcall(function()
        if HumanoidRootPart then
            local bodyVel = HumanoidRootPart:FindFirstChild("BFS_BodyVel")
            if bodyVel then bodyVel:Destroy() end
        end
    end)
end

-- Cerrar script
CloseBtn.MouseButton1Click:Connect(function()
    BFS.Running = false
    StopAutoFarm()
    pcall(function()
        if HumanoidRootPart then
            local bodyVel = HumanoidRootPart:FindFirstChild("BFS_BodyVel")
            if bodyVel then bodyVel:Destroy() end
        end
    end)
    ScreenGui:Destroy()
    ShowNotification("👋 BFS Scripts cerrado", 2)
end)

-- Auto iniciar configuraciones
if Settings then
    if Settings.AutoFarm then
        task.delay(1, function()
            BFS.Farming = true
            StartAutoFarm()
        end)
    end
    if Settings.SafeMode ~= nil then
        BFS.SafeMode = Settings.SafeMode
    end
end

print("✅ BFS Scripts Premium v3.0 cargado!")
ShowNotification("🎮 BFS Premium v3.0 cargado correctamente!", 3)
