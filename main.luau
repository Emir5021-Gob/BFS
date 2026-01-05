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
        return game:HttpGet(url, true)
    end)
    
    if not success or not result or result == "" then
        return nil, "Error de conexión"
    end
    
    return result, nil
end

-- Función para cargar y ejecutar código
local function LoadScript(scriptName)
    local code, err = DownloadScript(REPO_URL .. "Games/" .. scriptName)
    
    if not code then
        return nil, err
    end
    
    local func, loadErr = loadstring(code)
    if not func then
        return nil, "Error de sintaxis"
    end
    
    return func, nil
end

-- Detectar juego actual
local currentPlaceId = game.PlaceId
local placeIdStr = tostring(currentPlaceId)

local gameInfo = SUPPORTED_GAMES[currentPlaceId]

-- Si no encuentra, asumir que es Blox Fruits (el executor puede dar PlaceIds incorrectos)
if not gameInfo then
    -- Cargar Blox Fruits por defecto si el PlaceId no es reconocido
    gameInfo = {Name = "Blox Fruits [Auto-detectado]", Script = "BloxFruits.luau"}
    
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "⚠️ PlaceId No Reconocido";
            Text = "Intentando cargar Blox Fruits...";
            Duration = 3;
        })
    end)
end

-- Notificación de carga
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "🚀 BFS Scripts";
        Text = "Descargando script...";
        Duration = 2;
    })
end)

wait(0.5)

-- Cargar y ejecutar el script del juego
local GameScript, loadError = LoadScript(gameInfo.Script)

if not GameScript then
    wait(0.5)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "❌ Error de Descarga";
            Text = loadError or "No se pudo descargar";
            Duration = 8;
        })
    end)
    return
end

wait(0.5)
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "⚙️ Iniciando Hub";
        Text = "Ejecutando BFS...";
        Duration = 2;
    })
end)

wait(0.3)

local success, execError = pcall(function()
    GameScript()
end)

wait(0.5)

if not success then
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "❌ Error al Ejecutar";
            Text = "Error en el script";
            Duration = 8;
        })
    end)
else
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "✅ Hub Cargado";
            Text = "BFS v4.2 iniciado";
            Duration = 3;
        })
    end)
end
