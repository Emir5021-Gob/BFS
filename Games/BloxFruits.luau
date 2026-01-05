-- BFS Premium Hub v4.2 - ULTIMATE EDITION
-- Optimizado para móvil con funcionalidades completas
-- Incluye: Materials, Bones, Fruits, Teleports, Haki Training, ESP

-- Función para notificaciones móvil
local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3,
        })
    end)
end

Notify("BFS DEBUG", "Script iniciado", 2)

-- Protección y verificaciones
repeat wait() until game:IsLoaded()
repeat wait() until game.Players
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.Players.LocalPlayer.Character

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

Notify("BFS DEBUG", "Servicios cargados", 2)

-- Detectar Sea actual
local function GetCurrentSea()
    local placeId = game.PlaceId
    print("🌊 Detectando Sea... PlaceId:", placeId)
    if placeId == 2753915549 then
        print("✅ Sea 1 - Old World")
        return 1 -- Old World (Sea 1)
    elseif placeId == 4442272183 then
        print("✅ Sea 2 - New World")
        return 2 -- New World (Sea 2)
    elseif placeId == 7449423635 then
        print("✅ Sea 3 - Third Sea")
        return 3 -- Third Sea (Sea 3)
    end
    warn("⚠️ Sea no detectado, usando Sea 1 por defecto")
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
    AutoBones = false,
    AutoEctoplasm = false,
    AutoMaterial = false,
    AutoFruitCollect = false,
    FruitNotifier = false,
    AutoObservationHaki = false,
    AutoArmamentHaki = false,
    EnableESP = false,
    SelectedStat = "Melee",
    SelectedWeapon = "Combat",
    SelectedWeaponType = "Melee", -- Tipo: Melee, Sword, Gun, Fruit
    SelectedBoss = "",
    SelectedRaid = "Flame",
    SelectedMaterial = "Leather",
    SelectedTeleport = "SafeZone",
    AttackDistance = 3,
    FarmDistance = 350,
    TweenSpeed = 300,
    CurrentSea = CurrentSea
}

-- Notificaciones
local Notifications = {}

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

-- Lista de materiales farmables
local MaterialList = {
    "Leather", "Scrap Metal", "Angel Wings", "Magma Ore",
    "Fish Tail", "Mystic Droplet", "Vampire Fang", "Demonic Wisp",
    "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Mini Tusk"
}

-- Mobs que dropean materiales
local MaterialMobs = {
    ["Leather"] = {"Pirate", "Brute", "Desert Bandit"},
    ["Scrap Metal"] = {"Brute", "Military Soldier"},
    ["Angel Wings"] = {"Royal Soldier", "Royal Squad"},
    ["Magma Ore"] = {"Magma Ninja", "Lava Pirate"},
    ["Fish Tail"] = {"Fishman Warrior", "Fishman Commando"},
    ["Mystic Droplet"] = {"Sea Soldier", "Water Fighter"},
    ["Vampire Fang"] = {"Vampire"},
    ["Demonic Wisp"] = {"Demonic Soul"},
    ["Conjured Cocoa"] = {"Chocolate Bar Battler", "Cocoa Warrior"},
    ["Dragon Scale"] = {"Dragon Crew Warrior", "Dragon Crew Archer"},
    ["Gunpowder"] = {"Military Soldier", "Military Spy"},
    ["Mini Tusk"] = {"Mythological Pirate"}
}

-- Mobs que dropean Bones (Sea 3)
local BoneMobs = {
    "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"
}

-- Mobs que dropean Ectoplasm
local EctoplasmMobs = {
    "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer"
}

-- Lista de frutas conocidas
local FruitList = {
    "Kilo", "Spin", "Spring", "Bomb", "Smoke", "Spike", "Flame", "Falcon",
    "Ice", "Sand", "Dark", "Diamond", "Light", "Rubber", "Barrier",
    "Ghost", "Magma", "Quake", "Buddha", "Love", "Spider", "Sound",
    "Phoenix", "Portal", "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth",
    "T-Rex", "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon",
    "Leopard", "Kitsune"
}

-- Teleports por Sea
local TeleportLocations = {
    [1] = { -- Sea 1
        {Name = "SafeZone", Location = CFrame.new(-2, 15, 1537)},
        {Name = "Jungle", Location = CFrame.new(-1602, 37, 150)},
        {Name = "Pirate Village", Location = CFrame.new(-1173, 4, 3808)},
        {Name = "Desert", Location = CFrame.new(945, 7, 4484)},
        {Name = "Frozen Village", Location = CFrame.new(1096, 87, -1298)},
        {Name = "Prison", Location = CFrame.new(4854, 5, 734)},
        {Name = "Colosseum", Location = CFrame.new(-1427, 7, -2932)},
        {Name = "Magma Village", Location = CFrame.new(-5247, 12, -4970)},
        {Name = "Underwater City", Location = CFrame.new(61123, 11, 1819)},
        {Name = "Upper Skylands", Location = CFrame.new(-7895, 5547, -379)},
        {Name = "Fountain City", Location = CFrame.new(5127, 37, 4050)},
    },
    [2] = { -- Sea 2
        {Name = "Kingdom of Rose", Location = CFrame.new(-246, 38, 1581)},
        {Name = "Cafe", Location = CFrame.new(-383, 73, 298)},
        {Name = "Mansion", Location = CFrame.new(-12471, 374, -7551)},
        {Name = "Graveyard", Location = CFrame.new(-5539, 29, -831)},
        {Name = "Snow Mountain", Location = CFrame.new(749, 408, -5274)},
        {Name = "Hot & Cold", Location = CFrame.new(-6508, 15, -6001)},
        {Name = "Cursed Ship", Location = CFrame.new(923, 125, 32853)},
        {Name = "Ice Castle", Location = CFrame.new(6430, 5, -6166)},
        {Name = "Forgotten Island", Location = CFrame.new(-3053, 240, -10148)},
    },
    [3] = { -- Sea 3
        {Name = "Port Town", Location = CFrame.new(-290, 7, 5343)},
        {Name = "Great Tree", Location = CFrame.new(2681, 1682, -7190)},
        {Name = "Castle on the Sea", Location = CFrame.new(-5075, 314, -2998)},
        {Name = "Hydra Island", Location = CFrame.new(5753, 610, -282)},
        {Name = "Haunted Castle", Location = CFrame.new(-9515, 142, 5567)},
        {Name = "Sea of Treats", Location = CFrame.new(-2020, 37, -12026)},
        {Name = "Tiki Outpost", Location = CFrame.new(-16545, 55, 1051)},
        {Name = "Floating Turtle", Location = CFrame.new(-13274, 332, -7632)},
    }
}

-- FUNCIONES HELPER SEGURAS
local function GetPlayerLevel()
    local success, level = pcall(function()
        if Player.Data and Player.Data.Level then
            return Player.Data.Level.Value
        elseif Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Level") then
            return Player.Data.Level.Value
        else
            -- Intenta obtener del leaderstats si existe
            if Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Level") then
                return Player.leaderstats.Level.Value
            end
        end
        return 1
    end)
    
    return success and level or 1
end

local function GetPlayerPoints()
    local success, points = pcall(function()
        if Player.Data and Player.Data.Points then
            return Player.Data.Points.Value
        elseif Player:FindFirstChild("Data") and Player.Data:FindFirstChild("Points") then
            return Player.Data.Points.Value
        end
        return 0
    end)
    
    return success and points or 0
end

-- Sistema de remotes de Blox Fruits
local function GetBloxFruitsRemote()
    local success, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("CommF_", 5)
    end)
    
    if success and result then
        return result
    else
        warn("⚠️ No se pudo obtener CommF_ remote")
        return nil
    end
end

print("🔧 Sistema de remotes configurado")

-- Función para crear UI con sidebar (360x420)
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BFSHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 340, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -180)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 20)
    HeaderFix.Position = UDim2.new(0, 0, 1, -20)
    HeaderFix.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🎮 BFS Hub v4.2"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Size = UDim2.new(1, -80, 0, 12)
    SubTitle.Position = UDim2.new(0, 10, 0, 22)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = "Premium Edition"
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubTitle.TextSize = 9
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = Header
    
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    MinimizeBtn.Position = UDim2.new(1, -33, 0, 6)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 22
    MinimizeBtn.Parent = Header
    
    local MinimizeBtnCorner = Instance.new("UICorner")
    MinimizeBtnCorner.CornerRadius = UDim.new(0, 8)
    MinimizeBtnCorner.Parent = MinimizeBtn
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 95, 1, -48)
    Sidebar.Position = UDim2.new(0, 8, 0, 45)
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Name = "SidebarScroll"
    SidebarScroll.Size = UDim2.new(1, -8, 1, -8)
    SidebarScroll.Position = UDim2.new(0, 4, 0, 4)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 3
    SidebarScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 255)
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.Parent = Sidebar
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 6)
    SidebarLayout.Parent = SidebarScroll
    
    SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 8)
    end)
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(0, 230, 1, -48)
    ContentArea.Position = UDim2.new(0, 108, 0, 45)
    ContentArea.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentArea
    
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Size = UDim2.new(1, -12, 1, -12)
    ContentScroll.Position = UDim2.new(0, 6, 0, 6)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.ScrollBarThickness = 4
    ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 255)
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentScroll.Parent = ContentArea
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = ContentScroll
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Minimizar función
    local Minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            MainFrame:TweenSize(UDim2.new(0, 340, 0, 40), "Out", "Quad", 0.3, true)
            MinimizeBtn.Text = "+"
            Sidebar.Visible = false
            ContentArea.Visible = false
        else
            MainFrame:TweenSize(UDim2.new(0, 340, 0, 360), "Out", "Quad", 0.3, true)
            MinimizeBtn.Text = "-"
            Sidebar.Visible = true
            ContentArea.Visible = true
        end
    end)
    
    -- NO insertar aquí, se insertará después
    -- ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    return ScreenGui, SidebarScroll, ContentScroll
end

-- Función para crear botones de categoría en sidebar
local function CreateCategoryButton(parent, icon, text, callback)
    local CategoryBtn = Instance.new("TextButton")
    CategoryBtn.Name = text
    CategoryBtn.Size = UDim2.new(1, 0, 0, 34)
    CategoryBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    CategoryBtn.BorderSizePixel = 0
    CategoryBtn.Font = Enum.Font.GothamBold
    CategoryBtn.Text = icon .. " " .. text
    CategoryBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    CategoryBtn.TextSize = 10
    CategoryBtn.TextXAlignment = Enum.TextXAlignment.Left
    CategoryBtn.Parent = parent
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.Parent = CategoryBtn
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = CategoryBtn
    
    CategoryBtn.MouseButton1Click:Connect(function()
        -- Resetear todos los botones
        for _, btn in pairs(parent:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
        
        -- Activar este botón
        CategoryBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
        CategoryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        callback()
    end)
    
    return CategoryBtn
end

-- Función para limpiar el área de contenido
local function ClearContent(parent)
    for _, child in pairs(parent:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

-- Función para crear Toggle
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 28)
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
    Section.Size = UDim2.new(1, 0, 0, 20)
    Section.BackgroundTransparency = 1
    Section.Font = Enum.Font.GothamBold
    Section.Text = text
    Section.TextColor3 = Color3.fromRGB(255, 255, 255)
    Section.TextSize = 11
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = parent
    
    return Section
end

-- Función para crear Dropdown (solo selección, no acción)
local function CreateDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 28)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.35, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.6, -10, 0, 25)
    Button.Position = UDim2.new(0.4, 0, 0.5, -12.5)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.Gotham
    Button.Text = options[1] or "Select..."
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 10
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

-- Función para crear un botón de acción
local function CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 28)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = parent
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Parent = ButtonFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        -- Animación de clic
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        }):Play()
        wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(60, 120, 220)
        }):Play()
        callback()
    end)
    
    return ButtonFrame
end

-- Crear etiqueta de texto (para avisos)
local function CreateLabel(parent, text)
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Size = UDim2.new(1, -20, 0, 30)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 200, 100)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBold
    Label.TextWrapped = true
    Label.Parent = LabelFrame
    
    return LabelFrame
end

-- Sistema de Fast Attack optimizado
local FastAttackConnection
local function StartFastAttack()
    if FastAttackConnection then return end
    
    FastAttackConnection = RunService.Heartbeat:Connect(function()
        if not Settings.FastAttack then return end
        
        pcall(function()
            local CombatFrameworkLib = debug.getupvalues(require(Player.PlayerScripts:WaitForChild("CombatFramework")))[2]
            if CombatFrameworkLib and CombatFrameworkLib.activeController then
                local ActiveController = CombatFrameworkLib.activeController
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

-- Equipar arma específica por nombre
local function EquipWeapon(weaponName)
    local tool = Player.Backpack:FindFirstChild(weaponName)
    if tool and tool:IsA("Tool") then
        Humanoid:EquipTool(tool)
        return true
    end
    return false
end

-- Usar habilidades de la fruta del diablo (Z, X, C, V, F)
local FruitSkillCooldown = 0
local function UseFruitSkills()
    if not Settings.UseFruitSkills then return end
    
    local currentTime = tick()
    if currentTime - FruitSkillCooldown < 0.5 then return end
    
    FruitSkillCooldown = currentTime
    
    pcall(function()
        local weapon = GetCurrentWeapon()
        if weapon and weapon:FindFirstChild("RemoteFunctionShoot") then
            -- Usar habilidades Z, X, C
            local skills = {"Z", "X", "C"}
            
            for _, key in pairs(skills) do
                VirtualInputManager:SendKeyEvent(true, key, false, game)
                wait(0.05)
                VirtualInputManager:SendKeyEvent(false, key, false, game)
                wait(0.1)
            end
        end
    end)
end

-- Obtener tipo de arma (Melee, Sword, Gun, Fruit)
local function GetWeaponType(tool)
    if not tool then return "Melee" end
    
    local toolName = tool.Name:lower()
    
    -- Detectar Fruit
    if toolName:find("fruit") or tool:FindFirstChild("RemoteFunctionShoot") then
        return "Fruit"
    end
    
    -- Detectar Gun/Pistola
    if toolName:find("gun") or toolName:find("rifle") or toolName:find("bazooka") or 
       toolName:find("cannon") or toolName:find("flintlock") or toolName:find("musket") then
        return "Gun"
    end
    
    -- Detectar Sword
    if toolName:find("sword") or toolName:find("katana") or toolName:find("blade") or 
       toolName:find("cutlass") or toolName:find("saber") or toolName:find("bisento") or
       toolName:find("pole") or toolName:find("trident") then
        return "Sword"
    end
    
    -- Por defecto es Melee
    return "Melee"
end

-- Equipar arma según tipo seleccionado (Melee, Sword, Gun, Fruit)
local function EquipWeaponByType(weaponType)
    -- Si ya tiene un arma del tipo correcto, no hacer nada
    local currentWeapon = GetCurrentWeapon()
    if currentWeapon and GetWeaponType(currentWeapon) == weaponType then
        return true
    end
    
    -- Buscar y equipar arma del tipo solicitado
    for _, tool in pairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local toolType = GetWeaponType(tool)
            if toolType == weaponType then
                Humanoid:EquipTool(tool)
                return true
            end
        end
    end
    
    -- Si es Melee y no hay arma, usar Combat (puños)
    if weaponType == "Melee" then
        -- Desequipar cualquier arma para usar Combat
        local equipped = GetCurrentWeapon()
        if equipped then
            pcall(function()
                Humanoid:UnequipTools()
            end)
        end
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
    if not bossName or bossName == "" then return nil end
    
    local foundBoss = nil
    
    -- Buscar en Workspace.Enemies
    pcall(function()
        if game.Workspace:FindFirstChild("Enemies") then
            for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v.Name == bossName and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    if v.Humanoid.Health > 0 then
                        foundBoss = v
                    end
                end
            end
        end
    end)
    
    return foundBoss
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
            -- Actualizar referencias de personaje si murió
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            local boss = FindBoss(Settings.SelectedBoss)
            
            if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                -- Safe Mode check
                if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                    return
                end
                
                local distance = (HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
                
                -- Equipar arma del tipo seleccionado
                EquipWeaponByType(Settings.SelectedWeaponType)
                
                if distance > 150 then
                    -- Distancia larga: usar teleport
                    TeleportToLocation(boss.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                elseif distance > Settings.AttackDistance + 2 then
                    -- Distancia media: volar
                    local direction = (boss.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    -- Posicionar y atacar
                    HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    -- Activar Fast Attack si está habilitado
                    if Settings.FastAttack then
                        pcall(function()
                            local CombatFrameworkLib = debug.getupvalues(require(Player.PlayerScripts:WaitForChild("CombatFramework")))[2]
                            if CombatFrameworkLib and CombatFrameworkLib.activeController then
                                local ActiveController = CombatFrameworkLib.activeController
                                ActiveController.hitboxMagnitude = 60
                                ActiveController.active = false
                                ActiveController.timeToNextAttack = 0
                                ActiveController.attacking = false
                                ActiveController.increment = 3
                                ActiveController.blocking = false
                                
                                if ActiveController.blade then
                                    ActiveController.blade:Hit()
                                end
                            end
                        end)
                    end
                    
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                    
                    -- Si es Melee (sin arma), click para atacar
                    if not weapon and Settings.SelectedWeaponType == "Melee" then
                        pcall(function()
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                        end)
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
                
                if distance > 150 then
                    TeleportToLocation(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                elseif distance > Settings.AttackDistance + 2 then
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
local RaidStartTime = 0
local function StartAutoRaid()
    if RaidConnection then return end
    
    RaidConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoRaid then return end
        
        pcall(function()
            -- Actualizar referencias de personaje si murió
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            -- Verificar si está en una raid activa
            local raidUI = Player.PlayerGui:FindFirstChild("Main") and Player.PlayerGui.Main:FindFirstChild("RaidsUI")
            local inRaid = raidUI and raidUI.Visible
            
            -- Verificar si existe isla de raid spawneada
            local raidIsland = false
            pcall(function()
                if game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("Boat Castle") then
                    raidIsland = true
                end
            end)
            
            if inRaid and raidIsland then
                -- Buscar enemigos de la raid
                local enemy = GetNearestEnemy()
                
                if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    -- Safe Mode check
                    if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                        return
                    end
                    
                    local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    
                    -- Equipar arma del tipo seleccionado
                    EquipWeaponByType(Settings.SelectedWeaponType)
                    
                    if distance > Settings.AttackDistance + 2 then
                        local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                    else
                        -- Posicionar para atacar
                        HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                        
                        -- BringMob si está activado
                        if Settings.BringMob then
                            BringMobToPlayer(enemy)
                        end
                        
                        -- Activar Fast Attack si está habilitado
                        if Settings.FastAttack then
                            pcall(function()
                                local CombatFrameworkLib = debug.getupvalues(require(Player.PlayerScripts:WaitForChild("CombatFramework")))[2]
                                if CombatFrameworkLib and CombatFrameworkLib.activeController then
                                    local ActiveController = CombatFrameworkLib.activeController
                                    ActiveController.hitboxMagnitude = 60
                                    ActiveController.active = false
                                    ActiveController.timeToNextAttack = 0
                                    ActiveController.attacking = false
                                    ActiveController.increment = 3
                                    ActiveController.blocking = false
                                    
                                    if ActiveController.blade then
                                        ActiveController.blade:Hit()
                                    end
                                end
                            end)
                        end
                        
                        -- Atacar con el arma equipada
                        local weapon = GetCurrentWeapon()
                        if weapon then
                            weapon:Activate()
                            
                            -- Usar habilidades de fruta si está activado
                            if Settings.SelectedWeaponType == "Fruit" or (weapon and weapon:FindFirstChild("RemoteFunctionShoot")) then
                                UseFruitSkills()
                            end
                        end
                        
                        -- Si es Melee (sin arma), click para atacar
                        if not weapon and Settings.SelectedWeaponType == "Melee" then
                            pcall(function()
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                            end)
                        end
                    end
                end
            else
                -- Intentar iniciar raid si no está en una
                if Settings.CurrentSea == 2 or Settings.CurrentSea == 3 then
                    local currentTime = tick()
                    
                    -- Evitar spam de inicio de raid (intentar cada 10 segundos)
                    if currentTime - RaidStartTime > 10 then
                        RaidStartTime = currentTime
                        
                        -- Paso 1: Teleport al Mysterious Scientist para comprar chip
                        pcall(function()
                            if Settings.CurrentSea == 2 then
                                -- Second Sea: Hot and Cold
                                HumanoidRootPart.CFrame = CFrame.new(-6438, 250, -4498)
                            elseif Settings.CurrentSea == 3 then
                                -- Third Sea: Castle on the Sea
                                HumanoidRootPart.CFrame = CFrame.new(-5017, 314, -2823)
                            end
                        end)
                        
                        wait(1.5)
                        
                        -- Paso 2: Comprar chip con fruta física (preferentemente común/uncommon)
                        local Remote = GetBloxFruitsRemote()
                        if Remote then
                            -- Lista de frutas comunes/uncommon baratas para tradear por chip
                            local cheapFruits = {
                                "Rocket-Rocket", "Spin-Spin", "Chop-Chop", "Spring-Spring",
                                "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike", "Falcon-Falcon",
                                "Kilo-Kilo"
                            }
                            
                            -- Intentar comprar chip con fruta barata
                            local chipBought = false
                            for _, fruitName in ipairs(cheapFruits) do
                                pcall(function()
                                    local success = Remote:InvokeServer("RaidsNpc", "Select", fruitName)
                                    if success then
                                        chipBought = true
                                        Notify("RAID", "Chip comprado con " .. fruitName, 3)
                                    end
                                end)
                                if chipBought then break end
                            end
                            
                            -- Si no se pudo con fruta, intentar con dinero
                            if not chipBought then
                                pcall(function()
                                    Remote:InvokeServer("RaidsNpc", "Select", "Check")
                                end)
                            end
                            
                            wait(2)
                            
                            -- Paso 3: Ir a la zona de inicio de raids
                            pcall(function()
                                if Settings.CurrentSea == 2 then
                                    -- Second Sea: Tubos azules en Hot and Cold
                                    HumanoidRootPart.CFrame = CFrame.new(-6555, 299, -4896)
                                elseif Settings.CurrentSea == 3 then
                                    -- Third Sea: Plataformas amarillas en Castle on the Sea
                                    HumanoidRootPart.CFrame = CFrame.new(-5411, 314, -2823)
                                end
                            end)
                            
                            wait(1.5)
                            
                            -- Paso 4: Iniciar la raid
                            pcall(function()
                                Remote:InvokeServer("Raids", "Start")
                                Notify("RAID", "Iniciando raid...", 3)
                            end)
                        end
                    end
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

-- Sistema de Notificaciones
local function ShowNotification(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5,
        })
    end)
    
    table.insert(Notifications, {Title = title, Text = text, Time = tick()})
end

-- 1. AUTO FARM MATERIALS/BONES

-- Buscar mob que dropea el material seleccionado
local function FindMaterialMob()
    local targetMobs = MaterialMobs[Settings.SelectedMaterial]
    if not targetMobs then 
        warn("⚠️ No se encontraron mobs para el material:", Settings.SelectedMaterial)
        return nil 
    end
    
    local nearestMob = nil
    local shortestDistance = Settings.FarmDistance
    
    pcall(function()
        if game.Workspace:FindFirstChild("Enemies") then
            for _, mobName in pairs(targetMobs) do
                for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                    if mob.Name == mobName and mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                        if mob.Humanoid.Health > 0 and mob.Parent then
                            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestMob = mob
                            end
                        end
                    end
                end
            end
        end
    end)
    
    return nearestMob
end

-- Auto Farm Materials
local MaterialConnection
local function StartAutoMaterial()
    if MaterialConnection then return end
    
    MaterialConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoMaterial then return end
        
        pcall(function()
            -- Actualizar referencias de personaje si murió
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            local mob = FindMaterialMob()
            
            if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                -- Safe Mode check
                if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                    return
                end
                
                local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                
                -- Equipar arma del tipo seleccionado
                EquipWeaponByType(Settings.SelectedWeaponType)
                
                if distance > 150 then
                    -- Distancia larga: usar teleport
                    TeleportToLocation(mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                elseif distance > Settings.AttackDistance + 2 then
                    local direction = (mob.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    if Settings.BringMob then
                        BringMobToPlayer(mob)
                    end
                    
                    -- Activar Fast Attack si está habilitado
                    if Settings.FastAttack then
                        pcall(function()
                            local CombatFrameworkLib = debug.getupvalues(require(Player.PlayerScripts:WaitForChild("CombatFramework")))[2]
                            if CombatFrameworkLib and CombatFrameworkLib.activeController then
                                local ActiveController = CombatFrameworkLib.activeController
                                ActiveController.hitboxMagnitude = 60
                                ActiveController.active = false
                                ActiveController.timeToNextAttack = 0
                                ActiveController.attacking = false
                                ActiveController.increment = 3
                                ActiveController.blocking = false
                                
                                if ActiveController.blade then
                                    ActiveController.blade:Hit()
                                end
                            end
                        end)
                    end
                    
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                    
                    -- Si es Melee (sin arma), click para atacar
                    if not weapon and Settings.SelectedWeaponType == "Melee" then
                        pcall(function()
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                        end)
                    end
                end
            end
        end)
    end)
end

local function StopAutoMaterial()
    if MaterialConnection then
        MaterialConnection:Disconnect()
        MaterialConnection = nil
    end
end

-- Auto Farm Bones
local BonesConnection
local function StartAutoBones()
    if BonesConnection then return end
    
    BonesConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoBones then return end
        
        pcall(function()
            -- Actualizar referencias de personaje si murió
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            local boneMob = nil
            local shortestDist = Settings.FarmDistance
            
            if game.Workspace:FindFirstChild("Enemies") then
                for _, mobName in pairs(BoneMobs) do
                    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                        if mob.Name == mobName and mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                            if mob.Humanoid.Health > 0 and mob.Parent then
                                local dist = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    boneMob = mob
                                end
                            end
                        end
                    end
                end
            end
            
            if boneMob and boneMob:FindFirstChild("HumanoidRootPart") and boneMob:FindFirstChild("Humanoid") and boneMob.Humanoid.Health > 0 then
                -- Safe Mode check
                if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                    return
                end
                
                -- Equipar arma del tipo seleccionado
                EquipWeaponByType(Settings.SelectedWeaponType)
                
                local distance = (HumanoidRootPart.Position - boneMob.HumanoidRootPart.Position).Magnitude
                
                if distance > 150 then
                    -- Distancia larga: usar teleport
                    TeleportToLocation(boneMob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                elseif distance > Settings.AttackDistance + 2 then
                    local direction = (boneMob.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    HumanoidRootPart.CFrame = boneMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    if Settings.BringMob then
                        BringMobToPlayer(boneMob)
                    end
                    
                    -- Activar Fast Attack si está habilitado
                    if Settings.FastAttack then
                        pcall(function()
                            local CombatFrameworkLib = debug.getupvalues(require(Player.PlayerScripts:WaitForChild("CombatFramework")))[2]
                            if CombatFrameworkLib and CombatFrameworkLib.activeController then
                                local ActiveController = CombatFrameworkLib.activeController
                                ActiveController.hitboxMagnitude = 60
                                ActiveController.active = false
                                ActiveController.timeToNextAttack = 0
                                ActiveController.attacking = false
                                ActiveController.increment = 3
                                ActiveController.blocking = false
                                
                                if ActiveController.blade then
                                    ActiveController.blade:Hit()
                                end
                            end
                        end)
                    end
                    
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                    
                    -- Si es Melee (sin arma), click para atacar
                    if not weapon and Settings.SelectedWeaponType == "Melee" then
                        pcall(function()
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                        end)
                    end
                end
            end
        end)
    end)
end

local function StopAutoBones()
    if BonesConnection then
        BonesConnection:Disconnect()
        BonesConnection = nil
    end
end

-- Auto Farm Ectoplasm
local EctoplasmConnection
local function StartAutoEctoplasm()
    if EctoplasmConnection then return end
    
    EctoplasmConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoEctoplasm then return end
        
        pcall(function()
            -- Actualizar referencias de personaje si murió
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            local ectoMob = nil
            local shortestDist = Settings.FarmDistance
            
            if game.Workspace:FindFirstChild("Enemies") then
                for _, mobName in pairs(EctoplasmMobs) do
                    for _, mob in pairs(game.Workspace.Enemies:GetChildren()) do
                        if mob.Name == mobName and mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                            if mob.Humanoid.Health > 0 and mob.Parent then
                                local dist = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    ectoMob = mob
                                end
                            end
                        end
                    end
                end
            end
            
            if ectoMob and ectoMob:FindFirstChild("HumanoidRootPart") and ectoMob:FindFirstChild("Humanoid") and ectoMob.Humanoid.Health > 0 then
                -- Safe Mode check
                if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                    return
                end
                
                -- Equipar arma del tipo seleccionado
                EquipWeaponByType(Settings.SelectedWeaponType)
                
                local distance = (HumanoidRootPart.Position - ectoMob.HumanoidRootPart.Position).Magnitude
                
                if distance > Settings.AttackDistance + 2 then
                    local direction = (ectoMob.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    HumanoidRootPart.CFrame = ectoMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    if Settings.BringMob then
                        BringMobToPlayer(ectoMob)
                    end
                    
                    -- Activar Fast Attack si está habilitado
                    if Settings.FastAttack then
                        pcall(function()
                            local CombatFrameworkLib = debug.getupvalues(require(Player.PlayerScripts:WaitForChild("CombatFramework")))[2]
                            if CombatFrameworkLib and CombatFrameworkLib.activeController then
                                local ActiveController = CombatFrameworkLib.activeController
                                ActiveController.hitboxMagnitude = 60
                                ActiveController.active = false
                                ActiveController.timeToNextAttack = 0
                                ActiveController.attacking = false
                                ActiveController.increment = 3
                                ActiveController.blocking = false
                                
                                if ActiveController.blade then
                                    ActiveController.blade:Hit()
                                end
                            end
                        end)
                    end
                    
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                    
                    -- Si es Melee (sin arma), click para atacar
                    if not weapon and Settings.SelectedWeaponType == "Melee" then
                        pcall(function()
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                        end)
                    end
                end
            end
        end)
    end)
end

local function StopAutoEctoplasm()
    if EctoplasmConnection then
        EctoplasmConnection:Disconnect()
        EctoplasmConnection = nil
    end
end

-- 2. AUTO FARM FRUITS

-- Buscar frutas en el mapa
local function FindFruit()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") and v:IsA("Tool") then
            return v
        end
    end
    
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
            return v
        end
    end
    
    return nil
end

-- Auto Farm Fruits
local FruitCollectConnection
local function StartAutoFruitCollect()
    if FruitCollectConnection then return end
    
    FruitCollectConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoFruitCollect then return end
        
        pcall(function()
            local fruit = FindFruit()
            
            if fruit and fruit:FindFirstChild("Handle") then
                local distance = (HumanoidRootPart.Position - fruit.Handle.Position).Magnitude
                
                -- Crear posición segura (siempre por encima, mínimo Y=50)
                local targetY = math.max(fruit.Handle.Position.Y + 20, 50)
                local safePosition = CFrame.new(fruit.Handle.Position.X, targetY, fruit.Handle.Position.Z)
                
                if distance > 10 then
                    -- Usar TweenService para atravesar paredes manteniendo altura
                    TeleportToLocation(safePosition)
                    wait(0.3)
                end
                
                -- Descender suavemente hacia la fruta
                HumanoidRootPart.CFrame = fruit.Handle.CFrame + Vector3.new(0, 5, 0)
                wait(0.5)
                
                -- Store en inventario
                local Remote = GetBloxFruitsRemote()
                if Remote then
                    pcall(function()
                        Remote:InvokeServer("StoreFruit", fruit.Name)
                    end)
                end
            end
        end)
    end)
end

local function StopAutoFruitCollect()
    if FruitCollectConnection then
        FruitCollectConnection:Disconnect()
        FruitCollectConnection = nil
    end
end

-- Fruit Notifier
local FruitNotifierConnection
local LastNotifiedFruits = {}

local function StartFruitNotifier()
    if FruitNotifierConnection then return end
    
    FruitNotifierConnection = RunService.Heartbeat:Connect(function()
        if not Settings.FruitNotifier then return end
        
        pcall(function()
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                    if not LastNotifiedFruits[v] then
                        ShowNotification("🍎 FRUTA ENCONTRADA!", v.Name, 10)
                        LastNotifiedFruits[v] = true
                    end
                end
            end
        end)
    end)
end

local function StopFruitNotifier()
    if FruitNotifierConnection then
        FruitNotifierConnection:Disconnect()
        FruitNotifierConnection = nil
    end
end

-- 3. TELEPORTS

local function TeleportToLocation(cframe)
    pcall(function()
        -- Teleport con tween para ser más seguro
        local distance = (HumanoidRootPart.Position - cframe.Position).Magnitude
        
        if distance < 100 then
            HumanoidRootPart.CFrame = cframe
        else
            local tweenInfo = TweenInfo.new(distance / Settings.TweenSpeed, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = cframe})
            tween:Play()
            tween.Completed:Wait()
        end
    end)
end

-- 4. AUTO HAKI TRAINING

-- Auto Observation Haki
local ObservationConnection
local function StartAutoObservationHaki()
    if ObservationConnection then return end
    
    ObservationConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoObservationHaki then return end
        
        pcall(function()
            local Remote = GetBloxFruitsRemote()
            if Remote then
                -- Activar Observation Haki
                Remote:InvokeServer("KenTalk", "Buy")
                Remote:InvokeServer("KenTalk", "Start")
                
                -- Esquivar ataques automáticamente
                if Player.Character:FindFirstChild("Humanoid") then
                    local enemy = GetNearestEnemy()
                    if enemy and (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude < 50 then
                        -- Activar dodge
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                        wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                    end
                end
            end
        end)
    end)
end

local function StopAutoObservationHaki()
    if ObservationConnection then
        ObservationConnection:Disconnect()
        ObservationConnection = nil
    end
end

-- Auto Armament Haki
local ArmamentConnection
local function StartAutoArmamentHaki()
    if ArmamentConnection then return end
    
    ArmamentConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoArmamentHaki then return end
        
        pcall(function()
            local Remote = GetBloxFruitsRemote()
            if Remote then
                -- Comprar y activar Armament Haki
                Remote:InvokeServer("BuyHaki", "Buso")
                
                -- Mantener Buso activo
                if not Player.Character:FindFirstChild("HasBuso") then
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "J", false, game)
                    wait(0.1)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, "J", false, game)
                end
            end
        end)
    end)
end

local function StopAutoArmamentHaki()
    if ArmamentConnection then
        ArmamentConnection:Disconnect()
        ArmamentConnection = nil
    end
end

-- 5. ESP/NOTIFICACIONES

-- ESP para enemigos
local ESPConnections = {}

local function CreateESP(object, color, text)
    if object:FindFirstChild("BFS_ESP") then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "BFS_ESP"
    billboardGui.Adornee = object
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or object.Name
    textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = billboardGui
    
    billboardGui.Parent = object
end

local function EnableESP()
    -- ESP para enemigos
    local enemyESP = RunService.Heartbeat:Connect(function()
        if not Settings.EnableESP then return end
        
        wait(0.5) -- Reducir frecuencia
        
        pcall(function()
            if game.Workspace:FindFirstChild("Enemies") then
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                        if enemy.Humanoid.Health > 0 and not enemy.HumanoidRootPart:FindFirstChild("BFS_ESP") then
                            CreateESP(enemy.HumanoidRootPart, Color3.fromRGB(255, 0, 0), enemy.Name)
                        end
                    end
                end
            end
        end)
    end)
    table.insert(ESPConnections, enemyESP)
    
    -- ESP para frutas
    local fruitESP = RunService.Heartbeat:Connect(function()
        if not Settings.EnableESP then return end
        
        wait(1) -- Chequear cada segundo
        
        pcall(function()
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("Tool") and string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                    if not v.Handle:FindFirstChild("BFS_ESP") then
                        CreateESP(v.Handle, Color3.fromRGB(255, 215, 0), "🍎 " .. v.Name)
                    end
                end
            end
        end)
    end)
    table.insert(ESPConnections, fruitESP)
    
    -- ESP para cofres
    local chestESP = RunService.Heartbeat:Connect(function()
        if not Settings.EnableESP then return end
        
        wait(1) -- Chequear cada segundo
        
        pcall(function()
            for _, chest in pairs(game.Workspace:GetChildren()) do
                if chest.Name:find("Chest") and chest:FindFirstChild("Root") then
                    if not chest.Root:FindFirstChild("BFS_ESP") then
                        CreateESP(chest.Root, Color3.fromRGB(0, 255, 0), "📦 Chest")
                    end
                end
            end
        end)
    end)
    table.insert(ESPConnections, chestESP)
end

local function DisableESP()
    for _, connection in pairs(ESPConnections) do
        connection:Disconnect()
    end
    ESPConnections = {}
    
    -- Remover todos los ESP
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("BillboardGui") and v.Name == "BFS_ESP" then
            v:Destroy()
        end
    end
end

-- Obtener enemigo más cercano
local function GetNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = Settings.FarmDistance
    
    pcall(function()
        if game.Workspace:FindFirstChild("Enemies") then
            for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    if v.Humanoid.Health > 0 and v.Parent then -- Verificar que existe y está vivo
                        local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestEnemy = v
                        end
                    end
                end
            end
        end
    end)
    
    return nearestEnemy
end

-- Obtener enemigo específico de quest
local function GetQuestEnemy(enemyName)
    if not enemyName then return GetNearestEnemy() end
    
    local nearestEnemy = nil
    local shortestDistance = Settings.FarmDistance
    
    pcall(function()
        -- Buscar primero en Workspace.Enemies (mobs spawneados)
        if game.Workspace:FindFirstChild("Enemies") then
            for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v.Name == enemyName and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    if v.Humanoid.Health > 0 then
                        local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestEnemy = v
                        end
                    end
                end
            end
        end
        
        -- Si no se encontró en Enemies, buscar en ReplicatedStorage (spawns)
        if not nearestEnemy and game.ReplicatedStorage:FindFirstChild("Remotes") then
            if game.Workspace:FindFirstChild("_WorldOrigin") then
                for _, v in pairs(game.Workspace._WorldOrigin.EnemySpawns:GetChildren()) do
                    if v.Name == enemyName then
                        -- El mob existe pero no está spawneado, intentar spawnearlo aproximándose
                        local spawnCFrame = v.CFrame
                        if spawnCFrame and (HumanoidRootPart.Position - spawnCFrame.Position).Magnitude < 200 then
                            -- Aproximarse al spawn point
                            TeleportToLocation(spawnCFrame)
                            wait(2) -- Esperar a que spawnee
                            -- Reintentar búsqueda
                            if game.Workspace:FindFirstChild("Enemies") then
                                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                                    if enemy.Name == enemyName and enemy:FindFirstChild("HumanoidRootPart") then
                                        return enemy
                                    end
                                end
                            end
                        end
                        break
                    end
                end
            end
        end
    end)
    
    return nearestEnemy
end
                        end
                    end
                end
            end
        end
    end)
    
    -- Si no encuentra el enemigo de la quest, devolver cualquier enemigo cercano
    if not nearestEnemy then
        return GetNearestEnemy()
    end
    
    return nearestEnemy
end

-- Tomar quest
local function TakeQuest()
    local Remote = GetBloxFruitsRemote()
    if not Remote then 
        warn("⚠️ No se pudo obtener remote para quest")
        return false 
    end
    
    local playerLevel = GetPlayerLevel()
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
    
    if not selectedQuest then 
        warn("⚠️ No se encontró quest apropiada para nivel", playerLevel)
        return false 
    end
    
    QuestData.CurrentQuest = selectedQuest.QuestGiver
    QuestData.QuestMob = selectedQuest.Enemy
    QuestData.QuestLevel = selectedQuest.Level
    
    -- Teleport a NPC de quest
    pcall(function()
        HumanoidRootPart.CFrame = selectedQuest.Location
    end)
    wait(0.5)
    
    -- Tomar quest via remote
    local success = pcall(function()
        Remote:InvokeServer("StartQuest", selectedQuest.QuestGiver, 1)
    end)
    
    if success then
        print("✅ Quest tomada:", selectedQuest.Enemy, "- Nivel", selectedQuest.Level)
    else
        warn("⚠️ Error al tomar quest")
    end
    
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
            -- Actualizar referencias de personaje si murió
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            local enemy
            
            if Settings.AutoQuest and QuestData.QuestMob then
                enemy = GetQuestEnemy(QuestData.QuestMob)
            else
                enemy = GetNearestEnemy()
            end
            
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                -- Safe Mode check
                if Settings.SafeMode and Humanoid.Health < (Humanoid.MaxHealth * 0.6) then
                    return
                end
                
                local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                
                -- Equipar arma del tipo seleccionado
                EquipWeaponByType(Settings.SelectedWeaponType)
                
                -- Mover hacia el enemigo
                if distance > 150 then
                    -- Distancia larga: usar teleport
                    TeleportToLocation(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                elseif distance > Settings.AttackDistance + 2 then
                    -- Distancia media: volar
                    local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * 1.5
                else
                    -- Posicionar para atacar
                    HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, Settings.AttackDistance)
                    
                    -- BringMob si está activado
                    if Settings.BringMob then
                        BringMobToPlayer(enemy)
                    end
                    
                    -- Activar Fast Attack si está habilitado
                    if Settings.FastAttack then
                        pcall(function()
                            local CombatFrameworkLib = debug.getupvalues(require(Player.PlayerScripts:WaitForChild("CombatFramework")))[2]
                            if CombatFrameworkLib and CombatFrameworkLib.activeController then
                                local ActiveController = CombatFrameworkLib.activeController
                                ActiveController.hitboxMagnitude = 60
                                ActiveController.active = false
                                ActiveController.timeToNextAttack = 0
                                ActiveController.attacking = false
                                ActiveController.increment = 3
                                ActiveController.blocking = false
                                
                                if ActiveController.blade then
                                    ActiveController.blade:Hit()
                                end
                            end
                        end)
                    end
                    
                    -- Atacar con el arma equipada
                    local weapon = GetCurrentWeapon()
                    if weapon then
                        weapon:Activate()
                    end
                    
                    -- Si es Melee (sin arma), click para atacar
                    if not weapon and Settings.SelectedWeaponType == "Melee" then
                        pcall(function()
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
                        end)
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
        
        wait(1) -- Evitar spam de quests
        
        pcall(function()
            local hasQuest = false
            
            -- Verificar si hay quest activa
            if Player.PlayerGui:FindFirstChild("Main") and Player.PlayerGui.Main:FindFirstChild("Quest") then
                hasQuest = Player.PlayerGui.Main.Quest.Visible
            end
            
            if not hasQuest then
                TakeQuest()
                wait(2) -- Esperar a que la quest se active
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
            local points = GetPlayerPoints()
            if Remote and points > 0 then
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

Notify("BFS DEBUG", "Creando UI...", 2)

-- Variables globales para UI (necesarias para las funciones Show*Category)
local GUI, Sidebar, ContentArea

-- Crear UI con protección de errores
local success, result1, result2, result3 = pcall(CreateUI)

if not success then
    Notify("ERROR", "CreateUI falló: " .. tostring(result1), 10)
    error("CreateUI falló")
    return
end

Notify("BFS DEBUG", "CreateUI exitoso", 2)

GUI = result1
Sidebar = result2
ContentArea = result3

if not GUI or not Sidebar or not ContentArea then
    Notify("ERROR", "UI es nil", 10)
    error("No se pudo crear la interfaz correctamente")
    return
end

Notify("BFS DEBUG", "Insertando en PlayerGui", 2)

-- Insertar UI en PlayerGui
GUI.Parent = Player:WaitForChild("PlayerGui")

Notify("BFS DEBUG", "Creando botones...", 2)

-- FUNCIONES PARA CREAR CADA CATEGORÍA

-- 1. CATEGORÍA: FARMING
local function ShowFarmingCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "📦 AUTO FARMING")
    
    CreateToggle(ContentArea, "Auto Farm", function(value)
        Settings.AutoFarm = value
        if value then
            StartAutoFarm()
        else
            StopAutoFarm()
        end
    end)
    
    CreateDropdown(ContentArea, "Weapon Type:", {"Melee", "Sword", "Gun", "Fruit"}, function(selected)
        Settings.SelectedWeaponType = selected
    end)
    
    CreateToggle(ContentArea, "Auto Quest", function(value)
        Settings.AutoQuest = value
        if value then
            TakeQuest()
            StartAutoQuest()
        else
            StopAutoQuest()
        end
    end)
    
    CreateToggle(ContentArea, "Fast Attack", function(value)
        Settings.FastAttack = value
        if value then
            StartFastAttack()
        else
            StopFastAttack()
        end
    end)
    
    CreateToggle(ContentArea, "Bring Mob", function(value)
        Settings.BringMob = value
    end)
    
    CreateSection(ContentArea, "⚔️ MASTERY")
    
    CreateToggle(ContentArea, "Auto Mastery", function(value)
        Settings.AutoMastery = value
        if value then
            StartAutoMastery()
        else
            StopAutoMastery()
        end
    end)
    
    -- Lista de armas
    local weapons = {}
    for _, tool in pairs(Player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            table.insert(weapons, tool.Name)
        end
    end
    
    if #weapons > 0 then
        CreateDropdown(ContentArea, "Weapon:", weapons, function(selected)
            Settings.SelectedWeapon = selected
        end)
    end
    
    CreateSection(ContentArea, "🍎 FRUIT MASTERY")
    
    CreateToggle(ContentArea, "Auto Fruit Mastery", function(value)
        Settings.AutoFruitMastery = value
        if value then
            StartAutoFruitMastery()
        else
            StopAutoFruitMastery()
        end
    end)
    
    CreateToggle(ContentArea, "Use Fruit Skills", function(value)
        Settings.UseFruitSkills = value
    end)
end

-- 2. CATEGORÍA: MATERIALS
local function ShowMaterialsCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "💎 FARM MATERIALS")
    
    CreateToggle(ContentArea, "Auto Farm Material", function(value)
        Settings.AutoMaterial = value
        if value then
            StartAutoMaterial()
        else
            StopAutoMaterial()
        end
    end)
    
    CreateDropdown(ContentArea, "Material:", MaterialList, function(selected)
        Settings.SelectedMaterial = selected
    end)
    
    CreateSection(ContentArea, "🦴 BONES & ECTOPLASM")
    
    CreateToggle(ContentArea, "Auto Farm Bones", function(value)
        Settings.AutoBones = value
        if value then
            StartAutoBones()
        else
            StopAutoBones()
        end
    end)
    
    CreateToggle(ContentArea, "Auto Farm Ectoplasm", function(value)
        Settings.AutoEctoplasm = value
        if value then
            StartAutoEctoplasm()
        else
            StopAutoEctoplasm()
        end
    end)
end

-- 3. CATEGORÍA: TELEPORTS
local function ShowTeleportsCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "🗺️ ISLAND TELEPORTS")
    
    local currentSeaTeleports = {}
    for _, loc in pairs(TeleportLocations[Settings.CurrentSea] or {}) do
        table.insert(currentSeaTeleports, loc.Name)
    end
    
    if #currentSeaTeleports > 0 then
        CreateDropdown(ContentArea, "Select Island:", currentSeaTeleports, function(selected)
            Settings.SelectedTeleport = selected
        end)
        
        CreateButton(ContentArea, "🚀 Teleport to Island", function()
            if Settings.SelectedTeleport then
                for _, loc in pairs(TeleportLocations[Settings.CurrentSea] or {}) do
                    if loc.Name == Settings.SelectedTeleport then
                        TeleportToLocation(loc.Location)
                        ShowNotification("📍 Teleport", "Viajando a " .. Settings.SelectedTeleport, 3)
                        break
                    end
                end
            else
                ShowNotification("⚠️ Error", "Selecciona una isla primero", 2)
            end
        end)
    end
end

-- 4. CATEGORÍA: BOSSES
local function ShowBossesCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "👑 AUTO BOSS")
    
    CreateToggle(ContentArea, "Auto Boss", function(value)
        Settings.AutoBoss = value
        if value then
            StartAutoBoss()
        else
            StopAutoBoss()
        end
    end)
    
    local currentSeaBosses = {}
    for _, boss in pairs(BossList[Settings.CurrentSea] or {}) do
        table.insert(currentSeaBosses, boss.Name)
    end
    
    if #currentSeaBosses > 0 then
        CreateDropdown(ContentArea, "Boss:", currentSeaBosses, function(selected)
            Settings.SelectedBoss = selected
        end)
    end
    
    CreateSection(ContentArea, "🌊 EVENTS & CHESTS")
    
    CreateToggle(ContentArea, "Auto Sea Event", function(value)
        Settings.AutoSeaEvent = value
        if value then
            StartAutoSeaEvent()
        else
            StopAutoSeaEvent()
        end
    end)
    
    CreateToggle(ContentArea, "Auto Chest", function(value)
        Settings.AutoChest = value
        if value then
            StartAutoChest()
        else
            StopAutoChest()
        end
    end)
    
    CreateToggle(ContentArea, "Auto Mirage Island", function(value)
        Settings.AutoMirageIsland = value
        if value then
            StartAutoMirageIsland()
        else
            StopAutoMirageIsland()
        end
    end)
end

-- 5. CATEGORÍA: FRUITS
local function ShowFruitsCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "🍎 DEVIL FRUITS")
    
    CreateToggle(ContentArea, "Auto Collect Fruits", function(value)
        Settings.AutoFruitCollect = value
        if value then
            StartAutoFruitCollect()
        else
            StopAutoFruitCollect()
        end
    end)
    
    CreateToggle(ContentArea, "Fruit Notifier", function(value)
        Settings.FruitNotifier = value
        if value then
            StartFruitNotifier()
        else
            StopFruitNotifier()
        end
    end)
end

-- 6. CATEGORÍA: RAIDS
local function ShowRaidsCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "⚔️ AUTO RAID")
    
    CreateToggle(ContentArea, "Auto Raid", function(value)
        Settings.AutoRaid = value
        if value then
            StartAutoRaid()
        else
            StopAutoRaid()
        end
    end)
    
    if Settings.CurrentSea == 2 or Settings.CurrentSea == 3 then
        CreateDropdown(ContentArea, "Raid:", RaidList, function(selected)
            Settings.SelectedRaid = selected
        end)
        
        CreateDropdown(ContentArea, "Weapon Type:", {"Melee", "Sword", "Gun", "Fruit"}, function(selected)
            Settings.SelectedWeaponType = selected
        end)
        
        CreateToggle(ContentArea, "Use Fruit Skills", function(value)
            Settings.UseFruitSkills = value
        end)
    else
        CreateLabel(ContentArea, "⚠️ Raids disponibles en Sea 2 y 3")
    end
end

-- 7. CATEGORÍA: HAKI
local function ShowHakiCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "🥋 HAKI TRAINING")
    
    CreateToggle(ContentArea, "Auto Observation Haki", function(value)
        Settings.AutoObservationHaki = value
        if value then
            StartAutoObservationHaki()
        else
            StopAutoObservationHaki()
        end
    end)
    
    CreateToggle(ContentArea, "Auto Armament Haki", function(value)
        Settings.AutoArmamentHaki = value
        if value then
            StartAutoArmamentHaki()
        else
            StopAutoArmamentHaki()
        end
    end)
end

-- 8. CATEGORÍA: ESP
local function ShowESPCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "👁️ ESP & VISUALS")
    
    CreateToggle(ContentArea, "Enable ESP", function(value)
        Settings.EnableESP = value
        if value then
            EnableESP()
        else
            DisableESP()
        end
    end)
end

-- 9. CATEGORÍA: SETTINGS
local function ShowSettingsCategory()
    ClearContent(ContentArea)
    
    CreateSection(ContentArea, "⚙️ GENERAL SETTINGS")
    
    CreateToggle(ContentArea, "Safe Mode (60%)", function(value)
        Settings.SafeMode = value
    end)
    
    CreateSection(ContentArea, "📊 AUTO STATS")
    
    CreateToggle(ContentArea, "Enable Auto Stats", function(value)
        Settings.AutoStats = value
        if value then
            StartAutoStats()
        else
            StopAutoStats()
        end
    end)
    
    CreateDropdown(ContentArea, "Stat:", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, function(selected)
        Settings.SelectedStat = selected
    end)
end

-- CREAR BOTONES DE CATEGORÍAS EN SIDEBAR
CreateCategoryButton(Sidebar, "📦", "Farming", ShowFarmingCategory)
CreateCategoryButton(Sidebar, "💎", "Materials", ShowMaterialsCategory)
CreateCategoryButton(Sidebar, "🗺️", "Teleports", ShowTeleportsCategory)
CreateCategoryButton(Sidebar, "👑", "Bosses", ShowBossesCategory)
CreateCategoryButton(Sidebar, "🍎", "Fruits", ShowFruitsCategory)
CreateCategoryButton(Sidebar, "⚔️", "Raids", ShowRaidsCategory)
CreateCategoryButton(Sidebar, "🥋", "Haki", ShowHakiCategory)
CreateCategoryButton(Sidebar, "👁️", "ESP", ShowESPCategory)
CreateCategoryButton(Sidebar, "⚙️", "Settings", ShowSettingsCategory)

-- Mostrar categoría inicial (Farming)
ShowFarmingCategory()

Notify("BFS HUB", "✅ Cargado exitosamente!", 5)

-- Secciones ANTIGUAS ELIMINADAS - Ahora se manejan por categorías
--[[
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
-- Secciones ANTIGUAS ELIMINADAS - Ahora se manejan por categorías
--]]

-- Inicialización
print("========================================")
print("🎮 BFS Hub v4.2 - ULTIMATE EDITION")
print("========================================")
print("🌊 Sea: " .. (Settings.CurrentSea == 1 and "Old World (1)" or Settings.CurrentSea == 2 and "New World (2)" or "Third Sea (3)"))
print("📊 Nivel: " .. GetPlayerLevel() .. " / 2800")
print("⚔️ Quest: " .. (QuestData.QuestMob or "Ninguna"))
print("========================================")
print("✅ CARACTERÍSTICAS COMPLETAS:")
print("")
print("📦 FARMING:")
print("  • Auto Farm + Quest (75+ quests)")
print("  • Fast Attack Optimizado")
print("  • Bring Mob Seguro")
print("  • Safe Mode")
print("")
print("👑 BOSS & EVENTS:")
print("  • Auto Boss (30+ bosses)")
print("  • Auto Sea Events")
print("  • Auto Chest")
print("")
print("💎 MATERIALS & BONES:")
print("  • Auto Farm Materials (12 tipos)")
print("  • Auto Farm Bones (Sea 3)")
print("  • Auto Farm Ectoplasm")
print("")
print("🍎 FRUITS:")
print("  • Auto Collect Fruits")
print("  • Fruit Notifier (alerta)")
print("  • Auto Store Fruits")
print("")
print("🗺️ NAVIGATION:")
print("  • Teleports (30+ ubicaciones)")
print("  • Por Sea específico")
print("")
print("🥋 HAKI TRAINING:")
print("  • Auto Observation Haki")
print("  • Auto Armament Haki")
print("  • Auto dodge/active")
print("")
print("👁️ ESP & VISUALS:")
print("  • ESP Enemies (rojo)")
print("  • ESP Fruits (dorado)")
print("  • ESP Chests (verde)")
print("")
print("🏝️ ISLANDS & RAIDS:")
print("  • Auto Mirage Island")
print("  • Auto Raid (14 raids)")
print("  • Auto Mastery (armas + frutas)")
print("  • Skills automáticas (Z/X/C/V)")
print("")
print("📊 STATS:")
print("  • Auto Stats (5 opciones)")
print("  • Anti-AFK integrado")
print("")
print("⚠️ TODAS LAS OPCIONES DESACTIVADAS")
print("   Activa solo las que necesites usar")
print("========================================")

print("🎮 BFS Scripts v4.2 ULTIMATE cargado completamente!")
print("🎯 UI activa - Presiona el botón minimize para ocultar")
