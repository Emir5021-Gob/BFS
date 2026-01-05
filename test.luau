-- Test mínimo para verificar que funciona
print("🔥 TEST - Script iniciado")
print("✅ PlaceId:", game.PlaceId)

-- Crear UI de prueba
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestUI"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "🔥 TEST EXITOSO!"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextSize = 20
Label.Font = Enum.Font.GothamBold
Label.Parent = Frame

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

print("✅ UI de prueba creada exitosamente!")
print("✅ Deberías ver un cuadro rojo en el centro de la pantalla")
