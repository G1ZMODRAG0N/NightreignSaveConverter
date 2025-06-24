#by G1ZMO_DRAG0N 05-31-25
######
###
##
#
Import-Module ".\modules\Write-Message.psm1"
$nightreignBasePath = Join-Path $env:APPDATA "Nightreign"
$nightreignPath =  Get-ChildItem -Path $nightreignBasePath -Directory | Where-Object {$_.Name -match '^\d{17}$'} | Select-Object -ExpandProperty "FullName" -First 1
$nightreignBackupPath = Join-Path $nightreignPath "backup"
$sourceSaveFiles = Get-ChildItem -LiteralPath $nightreignPath -Include ("*.co2", "*.sl2") -File -Exclude "*.vdf" -Force
#path check

if (Test-Path -Path $nightreignPath) {

    Write-Message "Nightreign save location found...looking for backups..." "info"
    Start-Sleep -Seconds 1
    #backup folder check
    if (Test-Path -Path $nightreignBackupPath) {
        Write-Message "Backup folder found..." "success"
        Start-Sleep -Seconds 1
        Write-Message "Checking for existing backup files..." "info"
        Start-Sleep -Seconds 1
    }
    else {
        Write-Message "Creating backup folder..." "info"
        Write-Progress -Activity "Creating backup folder..." -Status "Starting..." -PercentComplete 0
        New-Item -Path $nightreignPath -ItemType Directory -Name "backup"
        Write-Progress -Activity "Creating backup folder..." -Status "Completed" -PercentComplete 100
        Start-Sleep -Seconds 1
    }

    #overwrite existing backup check
    if ((Get-ChildItem -Path $nightreignBackupPath -Force | Measure-Object).Count -ne 0) {
        do {
            $selectOption = Read-Host "`nOverwrite existing backup save files?:`n1 : Yes`n2 : No`n0 : Exit`n"
            #convert vanilla
            if ($selectOption -eq 1) {
                #backup files
                Write-Message "Overwriting backup save files..." "info"
                Write-Progress -Activity "Overwriting backup save files..." -Status "Starting..." -PercentComplete 0
                Start-Sleep -Seconds 2
                Write-Message = "Save Files:`n"$sourceSaveFiles "info"
                Write-Message "Backing up save files... (.\backup)" "info" 
                $sourceSaveFiles | ForEach-Object {Copy-Item -Path $_.FullName -Destination $nightreignBackupPath}
                Write-Progress -Activity "Overwriting backup save files..." -Status "Completed" -PercentComplete 100
                break
            }
            #convert seemless
            if ($selectOption -eq 2) {
                Write-Message "Skipping backup step..." "info"
                Start-Sleep -seconds 2
                break
            }
            if ($selectOption -eq 0) {
                Write-Message "Exiting..." "info"
                Start-Sleep -seconds 2
                exit
            }
        } until (($selectOption -eq 1) -or ($selectOption -eq 2) -or ($selectOption -eq 0))
    }
    else {
        #no backup files found. automatically make backup
        Start-Sleep -Seconds 2
        Write-Message = "Save Files:`n"$sourceSaveFiles
        Write-Message "Backing up save files... (.\backup)" "info"
        Write-Progress -Activity "Backing up save files... (.\backup)" -Status "Starting..." -PercentComplete 0
        $sourceSaveFiles | ForEach-Object {Copy-Item -Path $_.FullName -Destination $nightreignBackupPath}
        Write-Progress -Activity "Backing up save files... (.\backup)" -Status "Completed" -PercentComplete 100
    }
}
else {
    Write-Message "Nightreign save location not found. Closing script..." "warn"
    Start-Sleep -Seconds 2
    exit
}

#seemless save check
Write-Message "Checking for Seemless save files..." "info"
Start-Sleep -Seconds 1
if(!($sourceSaveFiles | Where-Object -Property "Name" -eq "NR0000.sl2")){
    Write-Message "No Seemless save file has been detected. Please start Seemless and create at least one (1) save file. Exiting..." "warn"
    Start-Sleep -Seconds 2
    exit
}
Write-Message "Save files detected:`n" "success"
$sourceSaveFiles  | ForEach-Object {Write-Host $_.LastWriteTime $_.Name }
Start-Sleep -seconds 1

do {
    $vanillaSave = Join-Path -Path $nightreignPath -ChildPath "\NR0000.sl2"
    $seemlessSave = Join-Path -Path $nightreignPath -ChildPath "\NR0000.co2"
    $vanillaBackupSave = Join-Path -Path $nightreignBackupPath -ChildPath "\NR0000.sl2"
    $seemlessBackupSave = Join-Path -Path $nightreignBackupPath -ChildPath "\NR0000.co2"
    $selectOption = Read-Host "`nSelect an option:`n1 : Convert Vanilla save into a Seemless save.`n2 : Convert Seemless save into a Vanilla save.[AT YOUR OWN RISK]`n3 : Restore Vanilla save file.`n4 : Restore Seemless save file.`n0 : Exit`n"
    #convert vanilla to seemless
    if ($selectOption -eq 1) {
        Write-Progress -Activity "Converting Vanilla save file into Seemless save file..." -Status "Starting..." -PercentComplete 0
        Copy-Item -Path $vanillaSave -Destination $seemlessSave -Force
        Write-Progress -Activity "Converting Vanilla save file into Seemless save file..." -Status "Completed" -PercentComplete 100
        Start-Sleep -seconds 2
        Write-Message "Process complete! Exiting..." "success"
        Start-Sleep -seconds 3
        exit
    }
    #convert seemless to vanilla
    if ($selectOption -eq 2) {
        Write-Progress -Activity "Converting Seemless save file into Vanilla save file..." -Status "Starting..." -PercentComplete 0
        Copy-Item -Path $seemlessSave -Destination $vanillaSave -Force
        Write-Progress -Activity "Converting Seemless save file into Vanilla save file..." -Status "Completed" -PercentComplete 100
        Start-Sleep -seconds 2
        Write-Message "Process complete! Exiting..." "success"
        Start-Sleep -seconds 3
        exit
    }
    #restore vanilla backup
    if ($selectOption -eq 3) {
        Write-Progress -Activity "Restoring Vanilla save from backup folder..." -Status "Starting..." -PercentComplete 0
        Copy-Item -Path $vanillaBackupSave -Destination $vanillaSave -Force
        Write-Progress -Activity "Restoring Vanilla save from backup folder..." -Status "Completed" -PercentComplete 100
        Start-Sleep -seconds 2
        Write-Message "Process complete! Exiting..." "success"
        Start-Sleep -seconds 3
        exit
    }
    #restore seemless backup
    if ($selectOption -eq 4) {
        Write-Progress -Activity "Restoring Seemless save from backup folder..." -Status "Starting..." -PercentComplete 0
        Copy-Item -Path $seemlessBackupSave -Destination $seemlessSave -Force
        Write-Progress -Activity "Restoring Seemless save from backup folder..."-Status "Completed" -PercentComplete 100
        Start-Sleep -seconds 2
        Write-Message "Process complete! Exiting..." "success"
        Start-Sleep -seconds 3
        exit
    }
    if ($selectOption -eq 0) {
        Write-Message "Exiting..." "info"
        Start-Sleep -seconds 2
        exit
    }
} until (($selectOption -eq 1) -or ($selectOption -eq 2) -or ($selectOption -eq 3) -or ($selectOption -eq 4) -or ($selectOption -eq 0))