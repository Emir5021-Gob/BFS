$file = "Games/BloxFruits.luau"
$lines = [System.Collections.ArrayList](Get-Content $file)

Write-Host "Total lineas antes: $($lines.Count)"
Write-Host "Linea 3145 antes: [$($lines[3144])]"
Write-Host "Linea 3171 antes: [$($lines[3170])]"

# Remover linea 3145 (index 3144)
if ($lines[3144] -eq "end") {
    $lines.RemoveAt(3144)
    Write-Host "Linea 3145 (end extra) eliminada"
} else {
    Write-Host "ERROR: Linea 3145 no es 'end': [$($lines[3144])]"
}

# Ahora la linea 3171 es 3170 (porque eliminamos una)
if ($lines[3169] -eq "end") {
    $lines.RemoveAt(3169)
    Write-Host "Linea 3170 (antes 3171, end extra) eliminada"
} else {
    Write-Host "ERROR: Linea 3170 no es 'end': [$($lines[3169])]"
}

Write-Host "Total lineas despues: $($lines.Count)"

# Guardar
$lines | Set-Content $file -Encoding UTF8
Write-Host "Archivo guardado"
