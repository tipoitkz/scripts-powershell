# Uncomment 2 lines below if you want to zip old files
# $year =  2022
# $month = 01

# Get current year
$year =  Get-Date -Format yyyy
# Get current month
$month = (Get-Date).ToString("MM")
# Get current day. Will bea added to archive name
$day = (Get-Date -Format dd)
# Path to log files which will be archived
$path_log_files = 'F:\inetpub\logs\LogFiles'
# Files which will be archived
$extention = '*.log'
# Path to 7z.exe, must be installed
$7zip = "C:\Program Files\7-Zip\7z.exe";
# Path where archive will be stored
$archive_path = "F:\logs-archive"
# Path to log file
$log_file = 'F:\logs-archive\log.txt'

function Archive-File($filePath)
    {
        $fileInfo = New-Object System.IO.FileInfo $filePath

        #Check that file is't using by other process
        try 
        {
            $fileStream = $fileInfo.Open( [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read )
            #Archive file
            #If you don't want to delete source file (log) delete option -sdel
            #-y : assume Yes on all queries
            #a : Add files to archive
            #-mx7 РІС‹СЃРѕРєР°СЏ СЃС‚РµРїРµРЅСЊ СЃР¶Р°С‚РёСЏ (7), РјРѕР¶РЅРѕ РїРѕСЃС‚Р°РІРёС‚СЊ Рё 5 (РЅРѕСЂРјР°Р»СЊРЅРѕРµ СЃР¶Р°С‚РёРµ)
            #-sdel delete source after compress
            & $7zip a -tzip -mx7 -sdel $archive_path\$dirsFor\$year\$month\$month-$day.zip $filePath -y >> $log_file
        }
        catch
        {
            #Write to log that file is locked by another process
            echo "$(Get-Date) $filePath is locked" >> $log_file
        }
    }

# Check that 7zip is installed
if (-not (test-path $7zip)) {throw "$7zip needed"}

# Create archive path if not exist
If(!(test-path $archive_path))
{
      New-Item -ItemType Directory -Force -Path $archive_path
}

#Get all subdirs
$dirs = Get-ChildItem -Path $path_log_files | Where-Object {  $_.Attributes -eq "Directory" }

foreach ($dirsFor in $dirs) {
    #$dirsFor.Name

    #Get all files from subdir
    $files=Get-ChildItem -Path $path_log_files/$dirsFor -Filter $extention | Where-Object {  $_.LastWriteTime.Month -eq $month -and $_.LastWriteTime.Year -eq $year }
    #$files.Name

    #Add files to archive
    foreach ($filess in $files) {
        $filess | ForEach-Object{$_.FullName}
        #Run function which archive files
        Archive-File $filess.FullName
    }
}
