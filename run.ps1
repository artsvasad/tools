# run.ps1 (Asad's Master Launcher)
Clear-Host
Write-Host "=== Asad's Cloud Toolbox (suyena.com) ===" -ForegroundColor Cyan
Write-Host "1. J2P (Images to PDF & Resize ID)"
Write-Host "2. LIMG (Parallel Image Resize 500%)"
Write-Host "3. TTMAKER (MERN School App Docs)"
Write-Host "4. V2IMG (Fast Frame Extraction)"
Write-Host "5. VMIRROR (Fast Video Mirroring)"
Write-Host "6. W2P (Word/Excel to PDF)"
Write-Host "7. DOWN (High-Speed RAM Test)"
Write-Host "8. PNG2JPG (Convert PNG to JPEG)"

$choice = Read-Host "Select a tool number"

$base = "https://tools.suyena.com/scripts" 

function Run-Tool($name, $deps) {
    if ($deps) { 
        Write-Host "Installing dependencies for $name..." -ForegroundColor Yellow
        # Install necessary libraries quietly before execution
        pip install $deps --quiet 
    }
    # irm fetches the script content from your domain and executes it in memory
    python -c "$(irm "$base/$name")"
}

switch ($choice) {
    "1" { Run-Tool "j2p.py" "Pillow" }
    "2" { Run-Tool "limg.py" "Pillow" }
    "3" { Run-Tool "ttmaker.py" "pdfplumber python-docx" }
    "4" { Run-Tool "v2img.py" "opencv-python" }
    "5" { Run-Tool "VMirror.py" "" } # Ensure FFmpeg is installed on the system PATH
    "6" { Run-Tool "w2p.py" "pywin32" }
    "7" { Run-Tool "down.py" "requests" }
    "8" { Run-Tool "png2jpg.py" "Pillow" }
}