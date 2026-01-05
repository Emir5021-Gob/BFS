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
    [2753915549] = "BloxFruits_minimal.lua", -- Sea 1 (Old World)
    [4442272183] = "BloxFruits_minimal.lua", -- Sea 2 (New World)  
    [7449423635] = "BloxFruits_minimal.lua", -- Sea 3 (Third Sea)
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
        scriptName = "BloxFruits_minimal.lua"
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
    local errStr = tostring(compileError)
    warn(" ERROR DE COMPILACIN:")
    warn(errStr)
    -- Extraer numero de linea del error si existe
    local lineNum
    pcall(function()
        lineNum = tonumber((errStr:match(":(%%d+):")) or (errStr:match("line (%%d+)")))
    end)
    if lineNum then
        -- Mostrar snippet de 3 lineas alrededor del error
        local lines = {}
        for l in code:gmatch("[^\r\n]+") do
            table.insert(lines, l)
        end
        local from = math.max(1, lineNum - 1)
        local to = math.min(#lines, lineNum + 1)
        warn(" Linea:", lineNum, "de", #lines)
        for i = from, to do
            warn(i .. ": " .. lines[i])
        end
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = " Error Compilacion",
                Text = "Linea " .. tostring(lineNum),
                Duration = 10,
            })
        end)
    else
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = " Error Compilacion",
                Text = errStr:sub(1, 100),
                Duration = 10,
            })
        end)
    end
    -- Intentar fallback a script minimal
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = " Fallback",
            Text = "Usando version minimal",
            Duration = 6,
        })
    end)
    local minimalUrl = REPO .. "BloxFruits_minimal.lua"
    local mcode
    local okDownload, errDownload = pcall(function()
        mcode = game:HttpGet(minimalUrl, true)
    end)
    if not okDownload or not mcode or mcode == "" then
        warn(" Fallback descarga fallo:", tostring(errDownload))
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = " Error Fallback",
                Text = "No se pudo descargar minimal",
                Duration = 8,
            })
        end)
        return
    end
    local mfunc, mErr = loadstring(mcode)
    if not mfunc then
        warn(" Fallback compilacion fallo:", tostring(mErr))
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = " Error Compilacion",
                Text = tostring(mErr):sub(1, 50),
                Duration = 10,
            })
        end)
        return
    end
    local okRun, runErr = pcall(mfunc)
    if not okRun then
        warn(" Fallback ejecucion fallo:", tostring(runErr))
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = " Error Ejecucion",
                Text = tostring(runErr):sub(1, 50),
                Duration = 10,
            })
        end)
        return
    end
    -- Fallback ejecutado correctamente
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

