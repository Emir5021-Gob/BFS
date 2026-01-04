-- BFS Premium Hub v4.0
-- Optimizado para móvil con funcionalidades completas

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Detectar Sea actual
local function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        return 1 -- Old World (Sea 1)
    elseif placeId == 4442272183 then
        return 2 -- New World (Sea 2)
    elseif placeId == 7449423635 then
        return 3 -- Third Sea (Sea 3)
    end
    return 1
end

local CurrentSea = GetCurrentSea()

-- Variables globales
local Settings = {
    AutoFarm = false,
    AutoQuest = false,
    FastAttack = false,
    BringMob = false,
    AutoStats = false,
    AutoBoss = false,
    AutoChest = false,
    AutoSeaEvent = false,
    AutoMastery = false,
    AutoRaid = false,
    AutoMirageIsland = false,
    AutoFruitMastery = false,
    UseFruitSkills = false,
    SafeMode = false,
    SelectedStat = "Melee",
    SelectedWeapon = "Combat",
    SelectedBoss = "",
    SelectedRaid = "Flame",
    AttackDistance = 3,
    FarmDistance = 350,
    TweenSpeed = 300,
    CurrentSea = CurrentSea
}

local QuestData = {
    CurrentQuest = nil,
    QuestMob = nil,
    QuestLevel = 1
}

-- Lista de quests COMPLETA por nivel y sea
local QuestList = {
    -- SEA 1 (Old World) - Nivel 1-700
    [1] = {
        {Level = 1, QuestGiver = "BanditQuest1", Enemy = "Bandit", Location = CFrame.new(1059, 16, 1544)},
        {Level = 10, QuestGiver = "MonkeyQuest1", Enemy = "Monkey", Location = CFrame.new(-1448, 49, 28)},
        {Level = 15, QuestGiver = "JungleQuest", Enemy = "Gorilla", Location = CFrame.new(-1223, 6, -486)},
        {Level = 30, QuestGiver = "BuggyQuest1", Enemy = "Pirate", Location = CFrame.new(-1142, 4, 3828)},
        {Level = 40, QuestGiver = "BuggyQuest1", Enemy = "Brute", Location = CFrame.new(-1145, 15, 4350)},
        {Level = 60, QuestGiver = "DesertQuest", Enemy = "Desert Bandit", Location = CFrame.new(897, 6, 4388)},
        {Level = 75, QuestGiver = "SnowQuest", Enemy = "Snow Bandit", Location = CFrame.new(1389, 87, -1298)},
        {Level = 90, QuestGiver = "SnowQuest", Enemy = "Snowman", Location = CFrame.new(1389, 87, -1298)},
        {Level = 100, QuestGiver = "PrisonerQuest", Enemy = "Chief Warden", Location = CFrame.new(5310, 0, 850)},
        {Level = 120, QuestGiver = "ColossumQuest", Enemy = "Swan Pirate", Location = CFrame.new(5314, 23, 719)},
        {Level = 150, QuestGiver = "MarineQuest2", Enemy = "Marine Lieutenant", Location = CFrame.new(-5234, 29, 4054)},
        {Level = 175, QuestGiver = "MarineQuest2", Enemy = "Marine Captain", Location = CFrame.new(-5234, 29, 4054)},
        {Level = 190, QuestGiver = "PiratePortQuest", Enemy = "Pirate", Location = CFrame.new(-289, 43, 5579)},
        {Level = 210, QuestGiver = "AlchemistQuest", Enemy = "Mercenary", Location = CFrame.new(-428, 73, 1835)},
        {Level = 250, QuestGiver = "MagmaQuest", Enemy = "Magma Ninja", Location = CFrame.new(-5428, 78, -5959)},
        {Level = 275, QuestGiver = "FishmanQuest", Enemy = "Fishman Warrior", Location = CFrame.new(61122, 18, 1569)},
        {Level = 300, QuestGiver = "FishmanQuest", Enemy = "Fishman Commando", Location = CFrame.new(61122, 18, 1569)},
        {Level = 325, QuestGiver = "SkyExp1Quest", Enemy = "Sky Bandit", Location = CFrame.new(-4841, 717, -2663)},
        {Level = 350, QuestGiver = "SkyExp1Quest", Enemy = "Dark Master", Location = CFrame.new(-4841, 717, -2663)},
        {Level = 375, QuestGiver = "SkyExp2Quest", Enemy = "Toga Warrior", Location = CFrame.new(-7894, 5545, -380)},
        {Level = 400, QuestGiver = "SkyExp2Quest", Enemy = "Gladiator", Location = CFrame.new(-7894, 5545, -380)},
        {Level = 425, QuestGiver = "FountainQuest", Enemy = "Military Soldier", Location = CFrame.new(5259, 37, 4050)},
        {Level = 450, QuestGiver = "FountainQuest", Enemy = "Military Spy", Location = CFrame.new(5259, 37, 4050)},
    },
    -- SEA 2 (New World) - Nivel 700-1500
    [2] = {
        {Level = 700, QuestGiver = "Area1Quest", Enemy = "Raider", Location = CFrame.new(-428, 72, 1837)},
        {Level = 725, QuestGiver = "Area1Quest", Enemy = "Mercenary", Location = CFrame.new(-428, 72, 1837)},
        {Level = 775, QuestGiver = "Area2Quest", Enemy = "Swan Pirate", Location = CFrame.new(638, 71, 918)},
        {Level = 800, QuestGiver = "Area2Quest", Enemy = "Marine Commodore", Location = CFrame.new(638, 71, 918)},
        {Level = 850, QuestGiver = "MarineQuest3", Enemy = "Marine Rear Admiral", Location = CFrame.new(-7679, 5566, -497)},
        {Level = 875, QuestGiver = "FishmanQuest", Enemy = "Fishman Lord", Location = CFrame.new(61122, 18, 1569)},
        {Level = 900, QuestGiver = "ZombieQuest", Enemy = "Zombie", Location = CFrame.new(-5494, 48, -794)},
        {Level = 925, QuestGiver = "ZombieQuest", Enemy = "Vampire", Location = CFrame.new(-5494, 48, -794)},
        {Level = 950, QuestGiver = "SnowMountainQuest", Enemy = "Snow Trooper", Location = CFrame.new(607, 401, -5370)},
        {Level = 975, QuestGiver = "SnowMountainQuest", Enemy = "Winter Warrior", Location = CFrame.new(607, 401, -5370)},
        {Level = 1000, QuestGiver = "IceSideQuest", Enemy = "Lab Subordinate", Location = CFrame.new(-6060, 15, -4902)},
        {Level = 1050, QuestGiver = "IceSideQuest", Enemy = "Horned Warrior", Location = CFrame.new(-6060, 15, -4902)},
        {Level = 1100, QuestGiver = "FireSideQuest", Enemy = "Magma Ninja", Location = CFrame.new(-5428, 15, -5299)},
        {Level = 1150, QuestGiver = "FireSideQuest", Enemy = "Lava Pirate", Location = CFrame.new(-5428, 15, -5299)},
        {Level = 1200, QuestGiver = "ShipQuest1", Enemy = "Ship Deckhand", Location = CFrame.new(1037, 125, 32911)},
        {Level = 1250, QuestGiver = "ShipQuest2", Enemy = "Ship Engineer", Location = CFrame.new(919, 125, 32882)},
        {Level = 1275, QuestGiver = "ShipQuest2", Enemy = "Ship Steward", Location = CFrame.new(919, 125, 32882)},
        {Level = 1300, QuestGiver = "ShipQuest2", Enemy = "Ship Officer", Location = CFrame.new(919, 125, 32882)},
        {Level = 1325, QuestGiver = "FrostQuest", Enemy = "Arctic Warrior", Location = CFrame.new(5669, 28, -6481)},
        {Level = 1350, QuestGiver = "FrostQuest", Enemy = "Snow Lurker", Location = CFrame.new(5669, 28, -6481)},
        {Level = 1375, QuestGiver = "FrostQuest", Enemy = "Sea Soldier", Location = CFrame.new(5669, 28, -6481)},
        {Level = 1400, QuestGiver = "IceCastleQuest", Enemy = "Yeti", Location = CFrame.new(5669, 28, -6481)},
    },
    -- SEA 3 (Third Sea) - Nivel 1500+
    [3] = {
        {Level = 1500, QuestGiver = "PiratePortQuest", Enemy = "Pirate Millionaire", Location = CFrame.new(-289, 43, 5579)},
        {Level = 1525, QuestGiver = "PiratePortQuest", Enemy = "Pistol Billionaire", Location = CFrame.new(-289, 43, 5579)},
        {Level = 1575, QuestGiver = "ForestQuest", Enemy = "Dragon Crew Warrior", Location = CFrame.new(-12555, 332, -7124)},
        {Level = 1600, QuestGiver = "ForestQuest", Enemy = "Dragon Crew Archer", Location = CFrame.new(-12555, 332, -7124)},
        {Level = 1625, QuestGiver = "TikiQuest", Enemy = "Female Islander", Location = CFrame.new(-16545, 55, 1051)},
        {Level = 1650, QuestGiver = "TikiQuest", Enemy = "Giant Islander", Location = CFrame.new(-16545, 55, 1051)},
        {Level = 1700, QuestGiver = "MarineTreeIsland", Enemy = "Marine Commodore", Location = CFrame.new(2179, 28, -6737)},
        {Level = 1725, QuestGiver = "MarineTreeIsland", Enemy = "Marine Rear Admiral", Location = CFrame.new(2179, 28, -6737)},
        {Level = 1775, QuestGiver = "DeepForestIsland", Enemy = "Mythological Pirate", Location = CFrame.new(-13231, 332, -7625)},
        {Level = 1800, QuestGiver = "DeepForestIsland2", Enemy = "Jungle Pirate", Location = CFrame.new(-12379, 332, -9424)},
        {Level = 1825, QuestGiver = "HydraIsland", Enemy = "Musketeer Pirate", Location = CFrame.new(5259, 37, 4050)},
        {Level = 1850, QuestGiver = "HydraIsland", Enemy = "Reborn Skeleton", Location = CFrame.new(5259, 37, 4050)},
        {Level = 1875, QuestGiver = "HauntedCastle", Enemy = "Living Zombie", Location = CFrame.new(-9513, 142, 5567)},
        {Level = 1900, QuestGiver = "HauntedCastle", Enemy = "Demonic Soul", Location = CFrame.new(-9513, 142, 5567)},
        {Level = 1925, QuestGiver = "HauntedCastle", Enemy = "Posessed Mummy", Location = CFrame.new(-9513, 142, 5567)},
        {Level = 2000, QuestGiver = "PeanutQuest", Enemy = "Peanut Scout", Location = CFrame.new(-2104, 37, -10192)},
        {Level = 2025, QuestGiver = "PeanutQuest", Enemy = "Peanut President", Location = CFrame.new(-2104, 37, -10192)},
        {Level = 2050, QuestGiver = "IceCreamQuest", Enemy = "Ice Cream Chef", Location = CFrame.new(-820, 65, -10965)},
        {Level = 2075, QuestGiver = "IceCreamQuest", Enemy = "Ice Cream Commander", Location = CFrame.new(-820, 65, -10965)},
        {Level = 2100, QuestGiver = "CakeQuest1", Enemy = "Cookie Crafter", Location = CFrame.new(-2020, 37, -12026)},
        {Level = 2125, QuestGiver = "CakeQuest1", Enemy = "Cake Guard", Location = CFrame.new(-2020, 37, -12026)},
        {Level = 2150, QuestGiver = "CakeQuest2", Enemy = "Baking Staff", Location = CFrame.new(-1926, 37, -12850)},
        {Level = 2175, QuestGiver = "CakeQuest2", Enemy = "Head Baker", Location = CFrame.new(-1926, 37, -12850)},
        {Level = 2200, QuestGiver = "CakeQuest2", Enemy = "Cocoa Warrior", Location = CFrame.new(-1926, 37, -12850)},
        {Level = 2225, QuestGiver = "CakeQuest2", Enemy = "Chocolate Bar Battler", Location = CFrame.new(-1926, 37, -12850)},
        {Level = 2250, QuestGiver = "CakeQuest2", Enemy = "Sweet Thief", Location = CFrame.new(-1926, 37, -12850)},
        {Level = 2275, QuestGiver = "CakeQuest2", Enemy = "Candy Rebel", Location = CFrame.new(-1926, 37, -12850)},
        {Level = 2300, QuestGiver = "CakeQuest2", Enemy = "Candy Pirate", Location = CFrame.new(-1926, 37, -12850)},
        {Level = 2325, QuestGiver = "ChocQuest1", Enemy = "Choco Commander", Location = CFrame.new(233, 24, -12200)},
        {Level = 2350, QuestGiver = "ChocQuest2", Enemy = "Isle Outlaw", Location = CFrame.new(-12400, 332, -10490)},
        {Level = 2375, QuestGiver = "ChocQuest2", Enemy = "Isle Champion", Location = CFrame.new(-12400, 332, -10490)},
        {Level = 2400, QuestGiver = "TikiQuest2", Enemy = "Sun-kissed Warrior", Location = CFrame.new(-11900, 332, -10700)},
        {Level = 2425, QuestGiver = "TikiQuest2", Enemy = "Tide Keeper", Location = CFrame.new(-11900, 332, -10700)},
        {Level = 2450, QuestGiver = "TempleQuest", Enemy = "Stone Sentinel", Location = CFrame.new(-11500, 332, -10300)},
        {Level = 2475, QuestGiver = "TempleQuest", Enemy = "Serpent Hunter", Location = CFrame.new(-11500, 332, -10300)},
        {Level = 2500, QuestGiver = "ElephantQuest", Enemy = "Elemental Entity", Location = CFrame.new(-13300, 332, -8450)},
        {Level = 2525, QuestGiver = "ElephantQuest", Enemy = "Storm Trooper", Location = CFrame.new(-13300, 332, -8450)},
        {Level = 2550, QuestGiver = "RaiderQuest", Enemy = "Leviathan Pirate", Location = CFrame.new(-2500, 15, -12000)},
        {Level = 2575, QuestGiver = "RaiderQuest", Enemy = "Beast Hunter", Location = CFrame.new(-2500, 15, -12000)},
        {Level = 2600, QuestGiver = "DarkQuest", Enemy = "Void Reaver", Location = CFrame.new(-6200, 238, -12450)},
        {Level = 2625, QuestGiver = "DarkQuest", Enemy = "Nightmare Pirate", Location = CFrame.new(-6200, 238, -12450)},
        {Level = 2650, QuestGiver = "SkylandQuest", Enemy = "Azure Raider", Location = CFrame.new(-7850, 5545, -380)},
        {Level = 2675, QuestGiver = "SkylandQuest", Enemy = "Skyborn Knight", Location = CFrame.new(-7850, 5545, -380)},
        {Level = 2700, QuestGiver = "AncientQuest", Enemy = "Ancient Sentinel", Location = CFrame.new(-9500, 142, 5650)},
        {Level = 2725, QuestGiver = "AncientQuest", Enemy = "Primordial Guardian", Location = CFrame.new(-9500, 142, 5650)},
        {Level = 2750, QuestGiver = "FrostQuest2", Enemy = "Glacial Warrior", Location = CFrame.new(5500, 85, -6100)},
        {Level = 2775, QuestGiver = "FrostQuest2", Enemy = "Frozen Sentinel", Location = CFrame.new(5500, 85, -6100)},
        {Level = 2800, QuestGiver = "FinalQuest", Enemy = "Elite Warrior", Location = CFrame.new(-5000, 314, -3000)},
    }
}

-- Lista de Bosses por Sea
local BossList = {
    [1] = { -- Sea 1
        {Name = "The Gorilla King", Location = CFrame.new(-1223, 6, -486)},
        {Name = "Bobby", Location = CFrame.new(-1140, 14, 4353)},
        {Name = "Yeti", Location = CFrame.new(1349, 87, -1292)},
        {Name = "Mob Leader", Location = CFrame.new(-2848, 7, 5342)},
        {Name = "Vice Admiral", Location = CFrame.new(-5026, 28, 4324)},
        {Name = "Warden", Location = CFrame.new(5310, 0, 850)},
        {Name = "Chief Warden", Location = CFrame.new(5310, 0, 850)},
        {Name = "Swan", Location = CFrame.new(5314, 23, 719)},
        {Name = "Magma Admiral", Location = CFrame.new(-5530, 22, -8370)},
        {Name = "Fishman Lord", Location = CFrame.new(61351, 31, 1095)},
        {Name = "Wysper", Location = CFrame.new(-7901, 5545, -636)},
        {Name = "Thunder God", Location = CFrame.new(-7748, 5606, -2305)},
        {Name = "Cyborg", Location = CFrame.new(6041, 52, 3907)},
    },
    [2] = { -- Sea 2
        {Name = "Diamond", Location = CFrame.new(-1836, 198, -24)},
        {Name = "Jeremy", Location = CFrame.new(2316, 448, 853)},
        {Name = "Fajita", Location = CFrame.new(-2085, 73, -4208)},
        {Name = "Don Swan", Location = CFrame.new(2289, 15, 863)},
        {Name = "Smoke Admiral", Location = CFrame.new(-5115, 23, -5338)},
        {Name = "Cursed Captain", Location = CFrame.new(916, 181, 33422)},
        {Name = "Darkbeard", Location = CFrame.new(3876, 24, -3820)},
        {Name = "Order", Location = CFrame.new(-6216, 16, -5007)},
    },
    [3] = { -- Sea 3
        {Name = "Stone", Location = CFrame.new(-1049, 40, 6791)},
        {Name = "Island Empress", Location = CFrame.new(5730, 602, 244)},
        {Name = "Kilo Admiral", Location = CFrame.new(2846, 423, -6985)},
        {Name = "Captain Elephant", Location = CFrame.new(-13393, 319, -8423)},
        {Name = "Beautiful Pirate", Location = CFrame.new(5182, 23, -20)},
        {Name = "Cake Queen", Location = CFrame.new(-709, 381, -11150)},
        {Name = "rip_indra True Form", Location = CFrame.new(-5359, 424, -2735)},
        {Name = "Longma", Location = CFrame.new(-10238, 389, -9549)},
        {Name = "Soul Reaper", Location = CFrame.new(-9515, 315, 6691)},
        {Name = "Dough King", Location = CFrame.new(-2151, 70, -12404)},
    }
}

-- Lista de Raids disponibles
local RaidList = {
    "Flame", "Ice", "Quake", "Light", "Dark", 
    "String", "Rumble", "Magma", "Buddha", "Spider",
    "Phoenix", "Portal", "Blizzard", "Dough"
}

-- Islas especiales que aparecen
local SpecialIslands = {
    MirageIsland = "MirageIsland",
    PrehistoricIsland = "NightIsland",
    SeaBeast = "SeaBeast"
}

-- Sistema de remotes de Blox Fruits
local function GetBloxFruitsRemote()
    local success, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    end)
    return success and result or nil
end

-- Función para crear UI compacta móvil (260x380)
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BFSHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (más pequeño)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 6, 1, 6)
    Shadow.Position = UDim2.new(0, -3, 0, -3)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 12)
    ShadowCorner.Parent = Shadow
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "BFS Hub v4.0"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -38, 0, 7)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Parent = Header
    
    local MinimizeBtnCorner = Instance.new("UICorner")
    MinimizeBtnCorner.CornerRadius = UDim.new(0, 6)
    MinimizeBtnCorner.Parent = MinimizeBtn
    
    -- ScrollingFrame compacto
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = "Scroll"
    Scroll.Size = UDim2.new(1, -20, 1, -60)
    Scroll.Position = UDim2.new(0, 10, 0, 50)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 255)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.Parent = MainFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Scroll
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Minimizar función
    local Minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            MainFrame:TweenSize(UDim2.new(0, 260, 0, 45), "Out", "Quad", 0.3, true)
            MinimizeBtn.Text = "+"
        else
            MainFrame:TweenSize(UDim2.new(0, 260, 0, 380), "Out", "Quad", 0.3, true)
            MinimizeBtn.Text = "-"
        end
    end)
    
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    return ScreenGui, Scroll
end

-- Función para crear Toggle
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
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
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.Position = UDim2.new(0, 2, 0.5, -8)
    Indicator.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = ToggleButton
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local Enabled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        if Enabled then
            TweenService:Create(Indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -18, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(80, 150, 255)
            }):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 120, 220)
            }):Play()
        else
            TweenService:Create(Indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            }):Play()
        end
        callback(Enabled)
    end)
    
    return ToggleFrame
end

-- Función para crear Section
local function CreateSection(parent, text)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 25)
    Section.BackgroundTransparency = 1
    Section.Font = Enum.Font.GothamBold
    Section.Text = text
    Section.TextColor3 = Color3.fromRGB(255, 255, 255)
    Section.TextSize = 14
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = parent
    
    return Section
end

-- Función para crear Dropdown
local function CreateDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.5, -10, 0, 25)
    Button.Position = UDim2.new(0.5, 0, 0.5, -12.5)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.Gotham
    Button.Text = options[1]
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 11
    Button.Parent = DropdownFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button
    
    local currentIndex = 1
    Button.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then
            currentIndex = 1
        end
        Button.Text = options[currentIndex]
        callback(options[currentIndex])
    end)
    
    return DropdownFrame
end

-- Sistema de Fast Attack optimizado
local FastAttackConnection
local function StartFastAttack()
    if FastAttackConnection then return end
    
    local CombatFramework = debug.getupvalues(require(Player.PlayerScripts.CombatFramework))[2]
    
    FastAttackConnection = RunService.Heartbeat:Connect(function()
        if not Settings.FastAttack then return end
        
        pcall(function()
            local ActiveController = CombatFramework.activeController
            if ActiveController then
                ActiveController.hitboxMagnitude = 60
                ActiveController.active = false
                ActiveController.timeToNextAttack = 0
                ActiveController.attacking = false
                ActiveController.increment = 3
                ActiveController.blocking = false
                
                -- Activar ataque
                if ActiveController.blade then
                    ActiveController.blade:Hit()
                end
            end
        end)
    end)
end

local function StopFastAttack()
    if FastAttackConnection then
        FastAttackConnection:Disconnect()
        FastAttackConnection = nil
    end
end

-- Obtener arma equipada
local function GetCurrentWeapon()
    for _, v in pairs(Character:GetChildren()) do
        if v:IsA("Tool") then
            return v
        end
    end
    return nil
end

-- Equipar arma
local function EquipWeapon(weaponName)
    local tool = Player.Backpack:FindFirstChild(weaponName)
    if tool then
        Humanoid:EquipTool(tool)
        return true
    end
    return false
end

-- Obtener cofre más cercano
local function GetNearestChest()
    local nearestChest = nil
    local shortestDistance = 1000
    
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v.Name:find("Chest") and v:FindFirstChild("Root") then
            local distance = (HumanoidRootPart.Position - v.Root.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestChest = v
            end
        end
    end
    
    return nearestChest
end

-- Detectar evento marítimo
local function CheckSeaEvent()
    local seaEvent = nil
    
    -- Buscar Rough Sea/Sea Beast
    pcall(function()
        if game.Workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
            seaEvent = game.Workspace.SeaBeasts.SeaBeast1
        end
    end)
    
    -- Buscar Terrorshark
    pcall(function()
        if game.Workspace.Enemies:FindFirstChild("Terrorshark") then
            seaEvent = game.Workspace.Enemies:FindFirstChild("Terrorshark")
        end
    end)
    
    -- Buscar Piranha
    pcall(function()
        if game.Workspace.Enemies:FindFirstChild("Piranha") then
            seaEvent = game.Workspace.Enemies:FindFirstChild("Piranha")
        end
    end)
    
    -- Buscar Shark
    pcall(function()
        if game.Workspace.Enemies:FindFirstChild("Shark") then
            seaEvent = game.Workspace.Enemies:FindFirstChild("Shark")
        end
    end)
    
    return seaEvent
end

-- Buscar boss específico
local function FindBoss(bossName)
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == bossName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    
    -- Buscar en ReplicatedStorage (bosses no spawneados)
    for _, v in pairs(ReplicatedStorage:GetChildren()) do
        if v.Name == bossName then
            return nil -- Boss existe pero no está spawneado
        end
    end
    
    return nil
end

-- Auto Chest
local ChestConnection
local function StartAutoChest()
    if ChestConnection then return end
    
    ChestConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoChest then return end
        
        pcall(function()
            local chest = GetNearestChest()
            
            if chest and chest:FindFirstChild("Root") then
                local distance = (HumanoidRootPart.Position - chest.Root.Position).Magnitude
                
                if distance > 5 then
                    -- Volar hacia el cofre
                    local direction = (chest.Root.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 2
                else
                    -- Activar cofre
                    if chest:FindFirstChild("Prompt") then
                        fireproximityprompt(chest.Prompt)
                    end
                end
            end
        end)
    end)
end

local function StopAutoChest()
    if ChestConnection then
        ChestConnection:Disconnect()
        ChestConnection = nil
    end
end

-- Auto Sea Event
local SeaEventConnection
local function StartAutoSeaEvent()
    if SeaEventConnection then return end
    
    SeaEventConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoSeaEvent then return end
        
        pcall(function()
            local seaEvent = CheckSeaEvent()
            
            if seaEvent and seaEvent:FindFirstChild("HumanoidRootPart") and seaEvent:FindFirstChild("Humanoid") and seaEvent.Humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - seaEvent.HumanoidRootPart.Position).Magnitude
                
                -- Equipar arma
                if not GetCurrentWeapon() then
                    for _, tool in pairs(Player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            Humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
                
                if distance > Settings.AttackDistance + 2 then
                    -- Volar hacia evento
                    local direction = (seaEvent.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    -- Atacar
                    HumanoidRootPart.CFrame = seaEvent.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                end
            end
        end)
    end)
end

local function StopAutoSeaEvent()
    if SeaEventConnection then
        SeaEventConnection:Disconnect()
        SeaEventConnection = nil
    end
end

-- Auto Boss
local BossConnection
local function StartAutoBoss()
    if BossConnection then return end
    
    BossConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoBoss or Settings.SelectedBoss == "" then return end
        
        pcall(function()
            local boss = FindBoss(Settings.SelectedBoss)
            
            if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                -- Safe Mode check
                if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                    return
                end
                
                local distance = (HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
                
                -- Equipar arma
                if not GetCurrentWeapon() then
                    for _, tool in pairs(Player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            Humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
                
                if distance > Settings.AttackDistance + 2 then
                    -- Volar hacia boss
                    local direction = (boss.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    -- Posicionar y atacar
                    HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                end
            end
        end)
    end)
end

local function StopAutoBoss()
    if BossConnection then
        BossConnection:Disconnect()
        BossConnection = nil
    end
end

-- Auto Mastery (Farm con arma específica para maestría)
local MasteryConnection
local function StartAutoMastery()
    if MasteryConnection then return end
    
    MasteryConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoMastery or Settings.SelectedWeapon == "" then return end
        
        pcall(function()
            local enemy = GetNearestEnemy()
            
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Equipar arma específica
                local currentWeapon = GetCurrentWeapon()
                if not currentWeapon or currentWeapon.Name ~= Settings.SelectedWeapon then
                    EquipWeapon(Settings.SelectedWeapon)
                end
                
                local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                
                if distance > Settings.AttackDistance + 2 then
                    local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                        
                        -- Usar skill Z, X, C si es una fruta del diablo
                        if weapon:FindFirstChild("RemoteFunctionShoot") then
                            pcall(function()
                                weapon.RemoteFunctionShoot:InvokeServer(enemy.HumanoidRootPart.Position)
                            end)
                        end
                    end
                end
            end
        end)
    end)
end

local function StopAutoMastery()
    if MasteryConnection then
        MasteryConnection:Disconnect()
        MasteryConnection = nil
    end
end

-- Detectar Mirage Island
local function CheckMirageIsland()
    for _, v in pairs(game.Workspace._WorldOrigin:GetChildren()) do
        if v.Name == "MirageIsland" then
            return v
        end
    end
    return nil
end

-- Auto Mirage Island (buscar y farmear en la isla)
local MirageConnection
local function StartAutoMirageIsland()
    if MirageConnection then return end
    
    MirageConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoMirageIsland then return end
        
        pcall(function()
            local mirageIsland = CheckMirageIsland()
            
            if mirageIsland then
                -- Si existe Mirage Island, ir hacia ella
                local mirageCenter = mirageIsland:GetModelCFrame()
                local distance = (HumanoidRootPart.Position - mirageCenter.Position).Magnitude
                
                if distance > 100 then
                    -- Volar hacia Mirage Island
                    local direction = (mirageCenter.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 2
                else
                    -- Buscar NPCs o cofres en Mirage
                    for _, npc in pairs(mirageIsland:GetDescendants()) do
                        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                            local npcDistance = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                            if npcDistance < 50 then
                                -- Farmear NPC
                                if not GetCurrentWeapon() then
                                    for _, tool in pairs(Player.Backpack:GetChildren()) do
                                        if tool:IsA("Tool") then
                                            Humanoid:EquipTool(tool)
                                            break
                                        end
                                    end
                                end
                                
                                HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                                local weapon = GetCurrentWeapon()
                                if weapon then
                                    weapon:Activate()
                                end
                                break
                            end
                        end
                    end
                end
            end
        end)
    end)
end

local function StopAutoMirageIsland()
    if MirageConnection then
        MirageConnection:Disconnect()
        MirageConnection = nil
    end
end

-- Auto Raid
local RaidConnection
local function StartAutoRaid()
    if RaidConnection then return end
    
    RaidConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoRaid then return end
        
        pcall(function()
            -- Verificar si está en una raid
            local raidUI = Player.PlayerGui:FindFirstChild("Main") and Player.PlayerGui.Main:FindFirstChild("RaidsUI")
            
            if raidUI and raidUI.Visible then
                -- Buscar enemigos de la raid
                local enemy = GetNearestEnemy()
                
                if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    
                    -- Equipar arma
                    if not GetCurrentWeapon() then
                        for _, tool in pairs(Player.Backpack:GetChildren()) do
                            if tool:IsA("Tool") then
                                Humanoid:EquipTool(tool)
                                break
                            end
                        end
                    end
                    
                    if distance > Settings.AttackDistance + 2 then
                        local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                    else
                        HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                        
                        local weapon = GetCurrentWeapon()
                        if weapon then
                            weapon:Activate()
                            
                            -- Usar habilidades si es fruta
                            if Settings.UseFruitSkills and weapon:FindFirstChild("RemoteFunctionShoot") then
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                                wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                                wait(0.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                                wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                                wait(0.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                                wait(0.1)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
                            end
                        end
                    end
                end
            else
                -- Iniciar raid si no está en una
                local Remote = GetBloxFruitsRemote()
                if Remote and Settings.CurrentSea == 2 or Settings.CurrentSea == 3 then
                    pcall(function()
                        Remote:InvokeServer("RaidsNpc", "Select", Settings.SelectedRaid)
                    end)
                end
            end
        end)
    end)
end

local function StopAutoRaid()
    if RaidConnection then
        RaidConnection:Disconnect()
        RaidConnection = nil
    end
end

-- Auto Fruit Mastery (mejorado con skills)
local FruitMasteryConnection
local function StartAutoFruitMastery()
    if FruitMasteryConnection then return end
    
    FruitMasteryConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoFruitMastery then return end
        
        pcall(function()
            local enemy = GetNearestEnemy()
            
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Buscar y equipar fruta del diablo
                local fruitTool = nil
                for _, tool in pairs(Player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("RemoteFunctionShoot") then
                        fruitTool = tool
                        break
                    end
                end
                
                if fruitTool then
                    Humanoid:EquipTool(fruitTool)
                    
                    local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    
                    if distance > Settings.AttackDistance + 5 then
                        local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                    else
                        HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance + 3)
                        
                        -- Usar habilidades Z, X, C, V si UseFruitSkills está activado
                        if Settings.UseFruitSkills then
                            local VIM = game:GetService("VirtualInputManager")
                            
                            -- Skill Z
                            VIM:SendKeyEvent(true, "Z", false, game)
                            wait(0.1)
                            VIM:SendKeyEvent(false, "Z", false, game)
                            wait(0.8)
                            
                            -- Skill X
                            VIM:SendKeyEvent(true, "X", false, game)
                            wait(0.1)
                            VIM:SendKeyEvent(false, "X", false, game)
                            wait(0.8)
                            
                            -- Skill C
                            VIM:SendKeyEvent(true, "C", false, game)
                            wait(0.1)
                            VIM:SendKeyEvent(false, "C", false, game)
                            wait(0.8)
                            
                            -- Skill V (si existe)
                            VIM:SendKeyEvent(true, "V", false, game)
                            wait(0.1)
                            VIM:SendKeyEvent(false, "V", false, game)
                            wait(1)
                        else
                            -- Solo clicks
                            fruitTool:Activate()
                        end
                    end
                end
            end
        end)
    end)
end

local function StopAutoFruitMastery()
    if FruitMasteryConnection then
        FruitMasteryConnection:Disconnect()
        FruitMasteryConnection = nil
    end
end

-- Obtener enemigo más cercano
local function GetNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = Settings.FarmDistance
    
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = v
            end
        end
    end
    
    return nearestEnemy
end

-- Obtener enemigo específico de quest
local function GetQuestEnemy(enemyName)
    local nearestEnemy = nil
    local shortestDistance = Settings.FarmDistance
    
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == enemyName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = v
            end
        end
    end
    
    return nearestEnemy
end

-- Tomar quest
local function TakeQuest()
    local Remote = GetBloxFruitsRemote()
    if not Remote then return false end
    
    local playerLevel = Player.Data.Level.Value
    local selectedQuest = nil
    
    -- Obtener lista de quests del sea actual
    local currentSeaQuests = QuestList[Settings.CurrentSea] or QuestList[1]
    
    -- Encontrar quest apropiada para el nivel
    for i = #currentSeaQuests, 1, -1 do
        if playerLevel >= currentSeaQuests[i].Level then
            selectedQuest = currentSeaQuests[i]
            break
        end
    end
    
    if not selectedQuest then return false end
    
    QuestData.CurrentQuest = selectedQuest.QuestGiver
    QuestData.QuestMob = selectedQuest.Enemy
    QuestData.QuestLevel = selectedQuest.Level
    
    -- Teleport a NPC de quest
    HumanoidRootPart.CFrame = selectedQuest.Location
    wait(0.5)
    
    -- Tomar quest via remote
    local success = pcall(function()
        Remote:InvokeServer("StartQuest", selectedQuest.QuestGiver, 1)
    end)
    
    return success
end

-- BringMob (reducido para seguridad)
local function BringMobToPlayer(enemy)
    if not Settings.BringMob or not enemy then return end
    
    pcall(function()
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Settings.AttackDistance)
            enemy.HumanoidRootPart.CanCollide = false
            enemy.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
            
            if enemy:FindFirstChild("Head") then
                enemy.Head.CanCollide = false
            end
            
            if enemy.Humanoid:FindFirstChild("Animator") then
                enemy.Humanoid.Animator:Destroy()
            end
            
            enemy.Humanoid:ChangeState(14)
            enemy.Humanoid.WalkSpeed = 0
        end
    end)
end

-- Sistema de Auto Farm
local FarmConnection
local function StartAutoFarm()
    if FarmConnection then return end
    
    FarmConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoFarm then return end
        
        pcall(function()
            local enemy
            
            if Settings.AutoQuest and QuestData.QuestMob then
                enemy = GetQuestEnemy(QuestData.QuestMob)
            else
                enemy = GetNearestEnemy()
            end
            
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                -- Safe Mode check
                if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                    return
                end
                
                local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                
                -- Equipar arma si no hay ninguna
                if not GetCurrentWeapon() then
                    for _, tool in pairs(Player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            Humanoid:EquipTool(tool)
                            break
                        end
                    end
                end
                
                -- Mover hacia el enemigo
                if distance > Settings.AttackDistance + 2 then
                    -- BodyVelocity para vuelo
                    local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    -- Posicionar para atacar
                    HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    -- BringMob si está activado
                    if Settings.BringMob then
                        BringMobToPlayer(enemy)
                    end
                    
                    -- Atacar
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                end
            end
        end)
    end)
end

local function StopAutoFarm()
    if FarmConnection then
        FarmConnection:Disconnect()
        FarmConnection = nil
    end
end

-- Sistema de Auto Quest
local QuestConnection
local function StartAutoQuest()
    if QuestConnection then return end
    
    QuestConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoQuest then return end
        
        pcall(function()
            local hasQuest = Player.PlayerGui.Main.Quest.Visible
            
            if not hasQuest then
                TakeQuest()
                wait(1)
            end
        end)
    end)
end

local function StopAutoQuest()
    if QuestConnection then
        QuestConnection:Disconnect()
        QuestConnection = nil
    end
end

-- Sistema de Auto Stats
local StatsConnection
local function StartAutoStats()
    if StatsConnection then return end
    
    StatsConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoStats then return end
        
        wait(1) -- Delay para no spammear
        
        pcall(function()
            local Remote = GetBloxFruitsRemote()
            if Remote and Player.Data.Points.Value > 0 then
                Remote:InvokeServer("AddPoint", Settings.SelectedStat, 1)
            end
        end)
    end)
end

local function StopAutoStats()
    if StatsConnection then
        StatsConnection:Disconnect()
        StatsConnection = nil
    end
end

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function(time)
    VirtualInputManager:SendKeyEvent(true, "W", false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "W", false, game)
end)

-- Crear UI
local GUI, ScrollFrame = CreateUI()

-- Secciones
CreateSection(ScrollFrame, "📦 FARMING")

CreateToggle(ScrollFrame, "Auto Farm", function(value)
    Settings.AutoFarm = value
    if value then
        StartAutoFarm()
    else
        StopAutoFarm()
    end
end)

CreateToggle(ScrollFrame, "Auto Quest", function(value)
    Settings.AutoQuest = value
    if value then
        TakeQuest()
        StartAutoQuest()
    else
        StopAutoQuest()
    end
end)

CreateToggle(ScrollFrame, "Fast Attack", function(value)
    Settings.FastAttack = value
    if value then
        StartFastAttack()
    else
        StopFastAttack()
    end
end)

CreateToggle(ScrollFrame, "Bring Mob", function(value)
    Settings.BringMob = value
end)

CreateSection(ScrollFrame, "👑 BOSS & EVENTS")

CreateToggle(ScrollFrame, "Auto Boss", function(value)
    Settings.AutoBoss = value
    if value then
        StartAutoBoss()
    else
        StopAutoBoss()
    end
end)

-- Crear lista de bosses según el Sea actual
local currentSeaBosses = {}
for _, boss in pairs(BossList[Settings.CurrentSea] or {}) do
    table.insert(currentSeaBosses, boss.Name)
end

if #currentSeaBosses > 0 then
    CreateDropdown(ScrollFrame, "Boss:", currentSeaBosses, function(selected)
        Settings.SelectedBoss = selected
    end)
end

CreateToggle(ScrollFrame, "Auto Sea Event", function(value)
    Settings.AutoSeaEvent = value
    if value then
        StartAutoSeaEvent()
    else
        StopAutoSeaEvent()
    end
end)

CreateToggle(ScrollFrame, "Auto Chest", function(value)
    Settings.AutoChest = value
    if value then
        StartAutoChest()
    else
        StopAutoChest()
    end
end)

CreateSection(ScrollFrame, "🏝️ SPECIAL ISLANDS")

CreateToggle(ScrollFrame, "Auto Mirage Island", function(value)
    Settings.AutoMirageIsland = value
    if value then
        StartAutoMirageIsland()
    else
        StopAutoMirageIsland()
    end
end)

CreateSection(ScrollFrame, "⚔️ MASTERY & RAIDS")

CreateToggle(ScrollFrame, "Auto Raid", function(value)
    Settings.AutoRaid = value
    if value then
        StartAutoRaid()
    else
        StopAutoRaid()
    end
end)

if Settings.CurrentSea == 2 or Settings.CurrentSea == 3 then
    CreateDropdown(ScrollFrame, "Raid:", RaidList, function(selected)
        Settings.SelectedRaid = selected
    end)
end

CreateToggle(ScrollFrame, "Auto Mastery", function(value)
    Settings.AutoMastery = value
    if value then
        StartAutoMastery()
    else
        StopAutoMastery()
    end
end)

-- Lista de armas del jugador
local weaponList = {"Combat"}
for _, tool in pairs(Player.Backpack:GetChildren()) do
    if tool:IsA("Tool") then
        table.insert(weaponList, tool.Name)
    end
end

CreateDropdown(ScrollFrame, "Weapon:", weaponList, function(selected)
    Settings.SelectedWeapon = selected
end)

CreateToggle(ScrollFrame, "Auto Fruit Mastery", function(value)
    Settings.AutoFruitMastery = value
    if value then
        StartAutoFruitMastery()
    else
        StopAutoFruitMastery()
    end
end)

CreateToggle(ScrollFrame, "Use Fruit Skills (Z/X/C/V)", function(value)
    Settings.UseFruitSkills = value
end)

CreateSection(ScrollFrame, "⚙️ SETTINGS")

CreateToggle(ScrollFrame, "Safe Mode (60%)", function(value)
    Settings.SafeMode = value
end)

CreateSection(ScrollFrame, "📊 AUTO STATS")

CreateToggle(ScrollFrame, "Enable Auto Stats", function(value)
    Settings.AutoStats = value
    if value then
        StartAutoStats()
    else
        StopAutoStats()
    end
end)

CreateDropdown(ScrollFrame, "Stat:", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, function(selected)
    Settings.SelectedStat = selected
end)

-- Inicialización
print("========================================")
print("🎮 BFS Hub v4.1 - EDICIÓN COMPLETA")
print("========================================")
print("🌊 Sea: " .. (Settings.CurrentSea == 1 and "Old World (1)" or Settings.CurrentSea == 2 and "New World (2)" or "Third Sea (3)"))
print("📊 Nivel: " .. Player.Data.Level.Value .. " / 2800")
print("⚔️ Quest: " .. (QuestData.QuestMob or "Ninguna"))
print("========================================")
print("✅ CARACTERÍSTICAS DISPONIBLES:")
print("")
print("📦 FARMING:")
print("  • Auto Farm + Quest (70+ quests)")
print("  • Fast Attack Optimizado")
print("  • Bring Mob Seguro")
print("  • Safe Mode")
print("")
print("👑 BOSS & EVENTS:")
print("  • Auto Boss (30+ bosses)")
print("  • Auto Sea Events")
print("  • Auto Chest")
print("")
print("🏝️ ISLAS ESPECIALES:")
print("  • Auto Mirage Island")
print("  • Detección de islas raras")
print("")
print("⚔️ MASTERY & RAIDS:")
print("  • Auto Raid (14 raids)")
print("  • Auto Mastery (armas)")
print("  • Auto Fruit Mastery")
print("  • Skills automáticas (Z/X/C/V)")
print("")
print("📊 STATS:")
print("  • Auto Stats (5 opciones)")
print("  • Anti-AFK")
print("")
print("⚠️ TODAS LAS OPCIONES APAGADAS")
print("   Activa solo las que necesites")
print("========================================")
	print("🌐 Traductor activado")
end

print("🎮 BFS Scripts cargado completamente!")

-- Nota: El módulo completo de Blox Fruits está ofuscado en Module.luau
-- Este loader simplificado carga solo la UI para compatibilidad con Delta
