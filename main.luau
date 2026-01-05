--[[
    BFS Scripts v4.2 ULTIMATE
    Loader Principal
]]

-- Notificación inmediata
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "BFS Loader",
        Text = "Iniciando carga...",
        Duration = 3,
    })
end)

-- Configuración
local REPO = "https://raw.githubusercontent.com/Emir5021-Gob/BFS/main/Games/"

-- IDs de juego soportados (incluye BETA y variantes)
local GAMES = {
    -- Blox Fruits Main
    [2753915549] = "BloxFruits.luau", -- Sea 1
    [4442272183] = "BloxFruits.luau", -- Sea 2
    [7449423635] = "BloxFruits.luau", -- Sea 3
    -- Blox Fruits BETA/Test
    [13498489180] = "BloxFruits.luau", -- BETA
    [15541073133] = "BloxFruits.luau", -- BETA 2
}

-- Detectar juego
local placeId = game.PlaceId
local scriptName = GAMES[placeId]

-- Si no está en la lista, detectar automáticamente si es Blox Fruits
if not scriptName then
    -- Método 1: Verificar por elementos del juego
    local isBloxFruits = false
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        if rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("CommF_") then
            isBloxFruits = true
        end
    end)
    
    -- Método 2: Verificar por nombre del juego
    if not isBloxFruits then
        pcall(function()
            local gameName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name or ""
            if gameName:lower():find("blox") and gameName:lower():find("fruit") then
                isBloxFruits = true
            end
        end)
    end
    
    if isBloxFruits then
        scriptName = "BloxFruits.luau"
        print("✅ Detectado como Blox Fruits automáticamente")
    end
end

print("=" .. string.rep("=", 50))
print("🚀 BFS SCRIPTS v4.2 ULTIMATE")
print("=" .. string.rep("=", 50))
print("🎮 PlaceId:", placeId)

-- Verificar si el juego es soportado
if not scriptName then
    warn("⚠️ JUEGO NO SOPORTADO")
    warn("PlaceId actual:", placeId)
    warn("Juegos soportados:")
    warn("  • 2753915549 - Blox Fruits Sea 1")
    warn("  • 4442272183 - Blox Fruits Sea 2")
    warn("  • 7449423635 - Blox Fruits Sea 3")
    warn("  • 13498489180 - Blox Fruits BETA")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Juego no soportado",
            Text = "PlaceId: " .. tostring(placeId),
            Duration = 10,
        })
    end)
    return
end

print("✅ Juego detectado:", scriptName)

-- Descargar el script
local url = REPO .. scriptName
print("📥 Descargando:", url)

local code
local downloadSuccess, downloadError = pcall(function()
    code = game:HttpGet(url, true)
end)

if not downloadSuccess then
    warn("❌ ERROR EN DESCARGA:")
    warn(tostring(downloadError))
    return
end

if not code or code == "" then
    warn("❌ ERROR: Script vacío o no encontrado")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Error Descarga",
            Text = "Script vacío",
            Duration = 10,
        })
    end)
    return
end

print("✅ Descargado:", #code, "bytes")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ Descargado",
        Text = #code .. " bytes",
        Duration = 2,
    })
end)

print("⚙️ Compilando...")

-- Compilar el script
local func, compileError = loadstring(code)

if not func then
    warn("❌ ERROR DE COMPILACIÓN:")
    warn(tostring(compileError))
    -- Mostrar primeras líneas con error
    local lines = {}
    for line in code:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    warn("Total de líneas:", #lines)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ Error Compilación",
            Text = tostring(compileError):sub(1, 50),
            Duration = 15,
        })
    end)
    return
end

print("✅ Compilación exitosa")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "✅ Compilado",
        Text = "Ejecutando...",
        Duration = 2,
    })
end)

print("🎮 Ejecutando script...")

-- Ejecutar el script CON MANEJO DE ERRORES
local executeSuccess, executeError = pcall(func)

if not executeSuccess then
    warn("❌ ERROR EN EJECUCIÓN:")
    warn(tostring(executeError))
    
    -- Notificación visual del error
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "❌ ERROR BFS",
            Text = "Ver consola (F9) para detalles",
            Duration = 10,
        })
    end)
    return
end

print("✅ BFS Scripts cargado completamente!")

