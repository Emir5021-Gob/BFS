--[[
    BFS Scripts v4.2 ULTIMATE
    Loader Principal
]]

-- Notificacin inmediata
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "BFS Loader",
        Text = "Iniciando carga...",
        Duration = 3,
    })
end)

-- Configuracin
local REPO = "https://raw.githubusercontent.com/Emir5021-Gob/BFS/main/Games/"

-- IDs de juego soportados
local GAMES = {
    -- Blox Fruits Official
    [2753915549] = "BloxFruits.luau", -- Sea 1 (Old World)
    [4442272183] = "BloxFruits.luau", -- Sea 2 (New World)  
    [7449423635] = "BloxFruits.luau", -- Sea 3 (Third Sea)
}

-- Detectar juego
local placeId = game.PlaceId
local scriptName = GAMES[placeId]

-- Si no esta en la lista, detectar automaticamente si es Blox Fruits
if not scriptName then
    -- Verificar por elementos del juego (Remotes folder)
    local isBloxFruits = false
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        if rs:FindFirstChild("Remotes") then
            isBloxFruits = true
        end
    end)
    
    -- Verificar por nombre del juego
    if not isBloxFruits then
        pcall(function()
            local info = game:GetService("MarketplaceService"):GetProductInfo(placeId)
            if info and info.Name then
                local name = info.Name:lower()
                if name:find("blox") or name:find("fruit") then
                    isBloxFruits = true
                end
            end
        end)
    end
    
    if isBloxFruits then
        scriptName = "BloxFruits.luau"
        print("[BFS] Detectado como Blox Fruits automaticamente")
    end
end

print("=" .. string.rep("=", 50))
print(" BFS SCRIPTS v4.2 ULTIMATE")
print("=" .. string.rep("=", 50))
print(" PlaceId:", placeId)

-- Verificar si el juego es soportado
if not scriptName then
    warn(" JUEGO NO SOPORTADO")
    warn("PlaceId actual:", placeId)
    warn("Juegos soportados:")
    warn("   2753915549 - Blox Fruits Sea 1")
    warn("   4442272183 - Blox Fruits Sea 2")
    warn("   7449423635 - Blox Fruits Sea 3")
    warn("   13498489180 - Blox Fruits BETA")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = " Juego no soportado",
            Text = "PlaceId: " .. tostring(placeId),
            Duration = 10,
        })
    end)
    return
end

print(" Juego detectado:", scriptName)

-- Descargar el script
local url = REPO .. scriptName
print(" Descargando:", url)

local code
local downloadSuccess, downloadError = pcall(function()
    code = game:HttpGet(url, true)
end)

if not downloadSuccess then
    warn(" ERROR EN DESCARGA:")
    warn(tostring(downloadError))
    return
end

if not code or code == "" then
    warn(" ERROR: Script vaco o no encontrado")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = " Error Descarga",
            Text = "Script vaco",
            Duration = 10,
        })
    end)
    return
end

print(" Descargado:", #code, "bytes")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = " Descargado",
        Text = #code .. " bytes",
        Duration = 2,
    })
end)

print(" Compilando...")

-- Compilar el script
local func, compileError = loadstring(code)

if not func then
    warn(" ERROR DE COMPILACIN:")
    warn(tostring(compileError))
    -- Mostrar primeras lneas con error
    local lines = {}
    for line in code:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    warn("Total de lneas:", #lines)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = " Error Compilacin",
            Text = tostring(compileError):sub(1, 50),
            Duration = 15,
        })
    end)
    return
end

print(" Compilacin exitosa")

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = " Compilado",
        Text = "Ejecutando...",
        Duration = 2,
    })
end)

print(" Ejecutando script...")

-- Ejecutar el script CON MANEJO DE ERRORES
local executeSuccess, executeError = pcall(func)

if not executeSuccess then
    warn(" ERROR EN EJECUCIN:")
    warn(tostring(executeError))
    
    -- Notificacin visual del error
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = " ERROR BFS",
            Text = "Ver consola (F9) para detalles",
            Duration = 10,
        })
    end)
    return
end

print(" BFS Scripts cargado completamente!")

