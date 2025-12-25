Clear-Host
Write-Host "--- Asad's Toolbox [tools.suyena.com] ---" -ForegroundColor Cyan
Write-Host "1. J2P (Image to PDF & ID Resize)"
Write-Host "2. LIMG (Parallel 500% Resize)"
Write-Host "3. TTMAKER (School Document Generator)"
Write-Host "4. V2IMG (Fast Frame Extraction)"
Write-Host "5. VMIRROR (Video Horizontal Flip)"
Write-Host "6. W2P (Office to PDF - Windows Only)"
Write-Host "7. DOWN (High-Speed RAM Download)"
Write-Host "8. PNG2JPG (Convert PNG to JPEG)"

$choice = Read-Host "`nSelect a tool number"
$base = "https://tools.suyena.com/scripts"

function Run-Tool($name, $deps) {
    if ($deps) { 
        Write-Host "Installing dependencies for $name..." -ForegroundColor Yellow
        pip install $deps --quiet 
    }
    python -c "$(irm "$base/$name")"
}

switch ($choice) {
    "1" { Run-Tool "j2p.py" "Pillow" }
    "2" { Run-Tool "limg.py" "Pillow" }
    "3" { Run-Tool "ttmaker.py" "pdfplumber python-docx" }
    "4" { Run-Tool "v2img.py" "opencv-python" }
    "5" { Run-Tool "VMirror.py" "" }
    "6" { Run-Tool "w2p.py" "pywin32" }
    "7" { Run-Tool "down.py" "requests" }
    "8" { Run-Tool "png2jpg.py" "Pillow" }
}