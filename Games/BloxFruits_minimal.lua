-- BFS Premium Hub v4.2 - MINIMAL TEST
-- Test de carga minimo

local function Notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3,
        })
    end)
end

Notify("BFS", "Cargando script minimal...", 3)

-- Esperar carga
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

Notify("BFS", "Servicios cargados", 2)

-- Crear UI simple
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BFSMinimal"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "BFS Hub v4.2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 40)
Status.BackgroundTransparency = 1
Status.Text = "Script cargado correctamente!"
Status.TextColor3 = Color3.fromRGB(100, 255, 100)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Parent = Frame

ScreenGui.Parent = Player:WaitForChild("PlayerGui")

Notify("BFS", "UI creada exitosamente!", 5)
print("[BFS] Script minimal cargado!")
