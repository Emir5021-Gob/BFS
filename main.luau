--[[
    BFS Scripts v2.0
    Script de automatización para Blox Fruits
    Compatible con Delta Executor v2.702.622
    Autor: Emir5021-Gob
    Repositorio: github.com/Emir5021-Gob/BFS
]]

print("🚀 BFS Scripts v2.0 - Iniciando...")

-- Configuración del repositorio
local REPO_URL = "https://raw.githubusercontent.com/Emir5021-Gob/BFS/refs/heads/main/Scripts-main/"

-- Tabla de juegos soportados
local SUPPORTED_GAMES = {
    [2753915549] = {Name = "Blox Fruits [Sea 1]", Script = "BloxFruits.lua"},
    [4442272183] = {Name = "Blox Fruits [Sea 2]", Script = "BloxFruits.lua"},
    [7449423635] = {Name = "Blox Fruits [Sea 3]", Script = "BloxFruits.lua"},
}

-- Obtener configuración del usuario
local UserSettings = {...}
local Settings = {
    Team = "Pirates", -- Pirates o Marines
    AutoFarm = true,
    AutoStats = true,
    SafeMode = true,
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
        warn("❌ Error al descargar:", url)
        warn("Detalles:", result)
        return nil
    end
    
    return result
end

-- Función para cargar y ejecutar código
local function LoadScript(scriptName)
    print("📥 Descargando:", scriptName)
    local code = DownloadScript(REPO_URL .. "Games/" .. scriptName)
    
    if not code then
        error("No se pudo descargar el script")
        return
    end
    
    print("✅ Código descargado")
    print("⚙️ Ejecutando script...")
    
    local func, err = loadstring(code)
    if not func then
        warn("❌ Error de sintaxis:", err)
        error("El script tiene errores de sintaxis")
        return
    end
    
    return func
end

-- Detectar juego actual
local currentPlaceId = game.PlaceId
local gameInfo = SUPPORTED_GAMES[currentPlaceId]

if not gameInfo then
    warn("⚠️ Juego no soportado")
    warn("PlaceId actual:", currentPlaceId)
    warn("Juegos soportados:")
    for placeId, info in pairs(SUPPORTED_GAMES) do
        warn("-", info.Name, "(PlaceId:", placeId .. ")")
    end
    return
end

print("✅ Juego detectado:", gameInfo.Name)
print("📦 Cargando script...")

-- Cargar y ejecutar el script del juego
local GameScript = LoadScript(gameInfo.Script)
if GameScript then
    local success, err = pcall(GameScript, Settings)
    if not success then
        warn("❌ Error al ejecutar:", err)
    end
end
