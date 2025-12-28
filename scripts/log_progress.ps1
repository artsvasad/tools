# Get current date and time
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logFile = "progress.log"

# Ask for the status/message
$message = Read-Host -Prompt "What did you just accomplish?"

# Format the entry
$entry = "[$timestamp] - $message"

# Append to file
Add-Content -Path $logFile -Value $entry

Write-Host "Log updated successfully!" -ForegroundColor Green