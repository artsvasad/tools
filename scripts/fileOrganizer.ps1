# Set source to the current terminal directory and create target inside it
$sourcePath = $PWD.Path
$targetRoot = Join-Path $sourcePath "Updated Folder"

# Define file extensions for categorization
$videoExtensions = @('.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.webm', '.m4v')
$pictureExtensions = @('.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.tiff', '.heic')

# 1. Create the base directory structure
$videosPath = Join-Path $targetRoot "videos"
$picturesPath = Join-Path $targetRoot "pictures"

if (-not (Test-Path $videosPath)) { New-Item -ItemType Directory -Force -Path $videosPath | Out-Null }
if (-not (Test-Path $picturesPath)) { New-Item -ItemType Directory -Force -Path $picturesPath | Out-Null }

# 2. Define the high-speed batch moving function with Progress UI
function Move-MediaOptimized {
    param (
        [string]$categoryPath,
        [array]$extensions,
        [int]$batchSize = 500
    )

    Write-Host "Scanning for files for $(Split-Path $categoryPath -Leaf)..." -ForegroundColor Cyan
    
    # Gather files, skipping the destination folder
    $files = Get-ChildItem -Path $sourcePath -File -Recurse | 
             Where-Object { 
                 ($_.Extension.ToLower() -in $extensions) -and 
                 ($_.FullName -notlike "$targetRoot\*") 
             }
    
    if (-not $files) {
        Write-Host "No files found for this category." -ForegroundColor Yellow
        return
    }

    $totalFiles = $files.Count
    $overallProgress = 0
    $batchCounter = 0
    $folderNum = 1
    $currentDest = Join-Path $categoryPath $folderNum

    foreach ($file in $files) {
        $overallProgress++
        
        # UI UPDATE: Refresh the visual progress bar every 10 files to prevent CPU drag
        if ($overallProgress % 10 -eq 0 -or $overallProgress -eq $totalFiles) {
            $percent = [math]::Round(($overallProgress / $totalFiles) * 100, 1)
            Write-Progress -Activity "Organizing $(Split-Path $categoryPath -Leaf)" `
                           -Status "Moving file $overallProgress of $totalFiles ($percent%)" `
                           -PercentComplete $percent
        }

        # LIVE CHECK: If the file was deleted or moved by another app after the scan, skip it safely
        if (-not (Test-Path -LiteralPath $file.FullName)) {
            continue
        }

        # Lazy Folder Creation
        if ($batchCounter -eq 0 -and -not (Test-Path $currentDest)) {
            New-Item -ItemType Directory -Force -Path $currentDest | Out-Null
        }

        $destinationFile = Join-Path $currentDest $file.Name
        
        # Handle duplicate file names safely
        if (Test-Path $destinationFile) {
            $randomString = [guid]::NewGuid().ToString().Substring(0,6)
            $newName = "$($file.BaseName)_$randomString$($file.Extension)"
            $destinationFile = Join-Path $currentDest $newName
        }
        
        try {
            # Raw .NET move for speed
            [System.IO.File]::Move($file.FullName, $destinationFile)
            
            # STRICT COUNTING: Only increment the 200-limit counter if the move was a success
            $batchCounter++ 
        }
        catch {
            # Silently handle locked/system files without breaking the progress loop
        }

        # Step to the next folder ONLY after exactly 200 files have successfully arrived
        if ($batchCounter -ge $batchSize) {
            $folderNum++
            $batchCounter = 0
            $currentDest = Join-Path $categoryPath $folderNum
        }
    }
    
    # Close out the progress bar UI
    Write-Progress -Activity "Organizing $(Split-Path $categoryPath -Leaf)" -Completed
    Write-Host "Finished processing $(Split-Path $categoryPath -Leaf). Utilized $folderNum folders." -ForegroundColor Green
}

# 3. Execute the batch processes
Move-MediaOptimized -categoryPath $picturesPath -extensions $pictureExtensions
Move-MediaOptimized -categoryPath $videosPath -extensions $videoExtensions

Write-Host "All media sorted and verified!" -ForegroundColor Green