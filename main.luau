--[[
    BFS Scripts v4.2 ULTIMATE
    Loader Principal
]]

-- Configuración
local REPO = "https://raw.githubusercontent.com/Emir5021-Gob/BFS/main/Games/"

-- IDs de juego soportados
local GAMES = {
    [2753915549] = "BloxFruits.luau", -- Sea 1
    [4442272183] = "BloxFruits.luau", -- Sea 2
    [7449423635] = "BloxFruits.luau", -- Sea 3
}

-- Detectar juego
local placeId = game.PlaceId
local scriptName = GAMES[placeId]

-- Verificar si el juego es soportado
if not scriptName then
    return warn("⚠️ Juego no soportado. PlaceId: " .. tostring(placeId))
end

-- Descargar y ejecutar
print("🚀 BFS Scripts - Cargando...")
print("🎮 PlaceId: " .. tostring(placeId))

local success, result = pcall(function()
    local url = REPO .. scriptName
    print("📥 Descargando desde: " .. url)
    
    local code = game:HttpGet(url, true)
    
    if not code or code == "" then
        error("Script vacío o no encontrado")
    end
    
    print("✅ Descarga completa (" .. #code .. " bytes)")
    print("⚙️ Ejecutando...")
    
    local func, err = loadstring(code)
    if not func then
        error("Error de compilación: " .. tostring(err))
    end
    
    return func()
end)

if not success then
    warn("❌ Error: " .. tostring(result))
else
    print("✅ BFS Scripts cargado exitosamente!")
end
