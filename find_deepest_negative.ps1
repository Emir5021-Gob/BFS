$lines = Get-Content "Games/BloxFruits.luau"
$depth = 0
$maxNegative = 0
$maxNegativeLine = 0

for($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    
    # Contar aperturas
    if($line -match '^\s*local\s+function\b') { $depth++ }
    elseif($line -match '^\s*function\b\s+\w+') { $depth++ }
    elseif($line -match '\bfunction\s*\(') { $depth++ }
    elseif($line -match '^\s*if\b.*\bthen\s*$') { $depth++ }
    elseif($line -match '^\s*for\b.*\bdo\s*$') { $depth++ }
    elseif($line -match '^\s*while\b.*\bdo\s*$') { $depth++ }
    elseif($line -match '^\s*repeat\s*$') { $depth++ }
    
    # Contar cierres
    if($line -match '\bend\s*$') { $depth-- }
    elseif($line -match '\bend\)') { $depth-- }
    
    if($depth -lt $maxNegative) {
        $maxNegative = $depth
        $maxNegativeLine = $i + 1
    }
}

Write-Host "Depth final: $depth"
Write-Host "Depth mas negativo: $maxNegative en linea $maxNegativeLine"

if($maxNegativeLine > 0) {
    Write-Host "`nContexto de linea mas negativa:"
    $start = [Math]::Max(0, $maxNegativeLine - 5)
    $end = [Math]::Min($lines.Count - 1, $maxNegativeLine + 3)
    for($i = $start; $i -le $end; $i++) {
        $marker = if($i -eq $maxNegativeLine - 1) { ">>>" } else { "   " }
        Write-Host "$marker $($i+1): $($lines[$i])"
    }
}
