function Write-Message {
    param (
        [string]$Message,
        [string]$Level = "Info"
    )

    switch ($Level.ToLower()) {
        "info"     { Write-Host "[INFO]  $Message" -ForegroundColor Cyan }
        "warn"     { Write-Host "[WARN]  $Message" -ForegroundColor Yellow }
        "error"    { Write-Host "[ERROR] $Message" -ForegroundColor Red }
        "success"  { Write-Host "[OK]    $Message" -ForegroundColor Green }
        default    { Write-Host "$Message" }
    }
}
<# Example:
Write-Message "Nightreign save location found..." "info"
Write-Message "Creating backup folder..." "warn"
Write-Message "Backup complete!" "success"
 #>