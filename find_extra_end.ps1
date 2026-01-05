$lines = Get-Content "Games/BloxFruits.luau"

$depth = 0
$lineNum = 0

foreach($line in $lines) {
    $lineNum++
    
    # Contar aperturas (sin importar if tienen then en misma linea o no)
    $opens = 0
    if($line -match 'local function|^\s*function\s+\w+') { $opens++ }
    if($line -match '\bfunction\s*\(') { $opens++ } # callbacks
    
    # Contar cierres
    $closes = 0
    $closes = ([regex]::Matches($line, '\bend\b')).Count
    
    $prevDepth = $depth
    $depth = $depth + $opens - $closes
    
    # Reportar cuando depth se vuelve negativo
    if($depth -lt 0 -and $prevDepth -ge 0) {
        Write-Host "DEPTH SE VUELVE NEGATIVO EN LINEA $lineNum"
        Write-Host "Linea $($lineNum-2): $($lines[$lineNum-3])"
        Write-Host "Linea $($lineNum-1): $($lines[$lineNum-2])"
        Write-Host ">>> Linea ${lineNum}: $line"
        Write-Host "Linea $($lineNum+1): $($lines[$lineNum])"
        Write-Host "Linea $($lineNum+2): $($lines[$lineNum+1])"
        Write-Host ""
        Write-Host "Opens en esta linea: $opens"
        Write-Host "Closes en esta linea: $closes"
        Write-Host "Depth previo: $prevDepth -> Depth actual: $depth"
        break
    }
}

Write-Host "`nDepth final: $depth"
