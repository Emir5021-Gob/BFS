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
    return
end

print("✅ Descargado:", #code, "bytes")
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
    return
end

print("✅ Compilación exitosa")
print("🎮 Ejecutando script...")

-- Ejecutar el script SIN PCALL para ver errores reales
func()

print("✅ BFS Scripts cargado completamente!")

