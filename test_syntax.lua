-- Test syntax of BloxFruits.luau
local f = io.open("Games/BloxFruits.luau", "r")
if not f then
    print("ERROR: No se pudo abrir el archivo")
    os.exit(1)
end

local content = f:read("*all")
f:close()

local func, err = load(content, "BloxFruits.luau")
if not func then
    print("ERROR DE SINTAXIS:")
    print(err)
    
    -- Extraer número de línea
    local lineNum = err:match(":(%d+):")
    if lineNum then
        print("\nLinea con error:", lineNum)
        lineNum = tonumber(lineNum)
        
        -- Mostrar contexto
        local lines = {}
        for line in content:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        
        local from = math.max(1, lineNum - 2)
        local to = math.min(#lines, lineNum + 2)
        
        for i = from, to do
            local marker = i == lineNum and ">>> " or "    "
            print(marker .. i .. ": " .. lines[i])
        end
    end
    os.exit(1)
else
    print("SINTAXIS CORRECTA!")
    os.exit(0)
end
