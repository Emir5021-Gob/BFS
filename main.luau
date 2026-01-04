--[[
    BFS Scripts v4.2 ULTIMATE
    Script de automatización para Blox Fruits
    Compatible con Delta Executor v2.702.622
    Autor: Emir5021-Gob
    Repositorio: github.com/Emir5021-Gob/BFS
]]

print("🚀 BFS Scripts v4.2 ULTIMATE - Iniciando...")
print("📱 Executor:", identifyexecutor and identifyexecutor() or "Unknown")
print("🎮 PlaceId:", game.PlaceId)

-- Configuración del repositorio
local REPO_URL = "https://raw.githubusercontent.com/Emir5021-Gob/BFS/main/"

-- Tabla de juegos soportados
local SUPPORTED_GAMES = {
    [2753915549] = {Name = "Blox Fruits [Sea 1]", Script = "BloxFruits.luau"},
    [4442272183] = {Name = "Blox Fruits [Sea 2]", Script = "BloxFruits.luau"},
    [7449423635] = {Name = "Blox Fruits [Sea 3]", Script = "BloxFruits.luau"},
}

-- Detectar juego actual
local currentPlaceId = game.PlaceId
local gameInfo = SUPPORTED_GAMES[currentPlaceId]

if not gameInfo then
    warn("⚠️ JUEGO NO SOPORTADO")
    warn("PlaceId actual:", currentPlaceId)
    warn("Juegos soportados:")
    for placeId, info in pairs(SUPPORTED_GAMES) do
        warn("-", info.Name, "(PlaceId:", placeId .. ")")
    end
    return
end

print("✅ Juego detectado:", gameInfo.Name)
print("📦 Descargando script...")

-- Función para descargar código
local function DownloadScript(url)
    print("🔗 URL:", url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if not success then
        warn("❌ Error al descargar")
        warn("Detalles:", tostring(result))
        return nil
    end
    
    if not result or result == "" then
        warn("❌ Script vacío o no encontrado")
        return nil
    end
    
    print("✅ Descarga exitosa (" .. #result .. " bytes)")
    return result
end

-- Descargar el script del juego
local scriptUrl = REPO_URL .. "Games/" .. gameInfo.Script
local code = DownloadScript(scriptUrl)

if not code then
    warn("❌ No se pudo descargar el script")
    warn("Verifica tu conexión a internet")
    return
end

print("⚙️ Compilando script...")

-- Compilar el script
local func, compileErr = loadstring(code)
if not func then
    warn("❌ Error de compilación:")
    warn(tostring(compileErr))
    return
end

print("✅ Compilación exitosa")
print("🎮 Ejecutando script...")

-- Ejecutar el script
local executeSuccess, executeErr = pcall(func)
if not executeSuccess then
    warn("❌ Error al ejecutar:")
    warn(tostring(executeErr))
    return
end

print("✅ Script cargado exitosamente!")
print("🎯 BFS Scripts activo")
