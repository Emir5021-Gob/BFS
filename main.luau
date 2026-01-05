--[[
    BFS Scripts v4.2 ULTIMATE
    Script de automatización para Blox Fruits
    Compatible con Delta Executor v2.702.622
    Autor: Emir5021-Gob
    Repositorio: github.com/Emir5021-Gob/BFS
]]

-- Configuración del repositorio
local REPO_URL = "https://raw.githubusercontent.com/Emir5021-Gob/BFS/main/"

-- Tabla de juegos soportados
local SUPPORTED_GAMES = {
    [2753915549] = {Name = "Blox Fruits [Sea 1]", Script = "BloxFruits.luau"},
    [4442272183] = {Name = "Blox Fruits [Sea 2]", Script = "BloxFruits.luau"},
    [7449423635] = {Name = "Blox Fruits [Sea 3]", Script = "BloxFruits.luau"},
}

-- Obtener configuración del usuario
local UserSettings = {...}
local Settings = {
    Team = "Pirates", -- Pirates o Marines
}

-- Aplicar configuración del usuario
if UserSettings[1] and type(UserSettings[1]) == "table" then
    for key, value in pairs(UserSettings[1]) do
        Settings[key] = value
    end
end

-- Función para descargar código
local function DownloadScript(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        return nil
    end
    
    return result
end

-- Función para cargar y ejecutar código
local function LoadScript(scriptName)
    local code = DownloadScript(REPO_URL .. "Games/" .. scriptName)
    
    if not code then
        error("No se pudo descargar el script")
        return
    end
    
    local func, err = loadstring(code)
    if not func then
        error("El script tiene errores de sintaxis")
        return
    end
    
    return func
end

-- Detectar juego actual
local currentPlaceId = tonumber(game.PlaceId) or game.PlaceId

-- Verificar si es Blox Fruits (cualquier sea)
local isBloxFruits = false
local bloxFruitsIds = {2753915549, 4442272183, 7449423635}

for _, id in pairs(bloxFruitsIds) do
    if currentPlaceId == id then
        isBloxFruits = true
        break
    end
end

local gameInfo = SUPPORTED_GAMES[currentPlaceId]

if not gameInfo then
    -- Intentar convertir si es string
    if type(currentPlaceId) == "string" then
        local convertedId = tonumber(currentPlaceId)
        if convertedId then
            gameInfo = SUPPORTED_GAMES[convertedId]
        end
    end
    
    if not gameInfo then
        -- Notificación visual para el usuario
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "❌ Juego No Soportado";
                Text = "PlaceId: " .. tostring(currentPlaceId) .. "\nSolo funciona en Blox Fruits";
                Duration = 10;
            })
        end)
        return
    end
end

-- Notificación de carga
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🚀 BFS Scripts";
        Text = "Cargando " .. gameInfo.Name;
        Duration = 3;
    })
end)

-- Cargar y ejecutar el script del juego
local GameScript = LoadScript(gameInfo.Script)
if GameScript then
    local success, err = pcall(GameScript)
    if not success then
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "❌ Error de Ejecución";
                Text = "Error al cargar el script";
                Duration = 5;
            })
        end)
    else
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "✅ Script Cargado";
                Text = "BFS Hub v4.2 iniciado correctamente";
                Duration = 3;
            })
        end)
    end
else
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "❌ Error de Descarga";
            Text = "No se pudo descargar el script";
            Duration = 5;
        })
    end)
end
