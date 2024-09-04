<# Created by Colby Agerter :3

9/04/2024

Description: This program is a simple tool that will extract all files from each folder in the same directory and group the said files
by file type into folders. The reason I made this program was to easily group my large list of folders containing roms of many
different file types into folders by their given file type. This allows me to easily place all my roms into their correct
folders on my emulation system, I hope others can find use of this too!

A note file setup: To ensure this program will work as intended please make sure you only have all the folders you wish to be
organized and this progam in a folder. It is also important to note that this program will extract all files from each folder
and then delete the said folder, if any folder has sub folders it will simply extract those as well and not organize them
into file type folders but rather leave them in the root folder.

How to Use:

1. Create a new folder
2. Place groupByFileType.ps1 in the new folder
3. Place all your desired folders to be organized into the new folder
4. Run groupByFileType.ps1

#>

Write-Host "------ EXTRACTING FILES ------" -ForegroundColor Cyan

# for each folder: extract all files, then delete folder.
foreach ($folder in Get-ChildItem -Directory){

    $folderName = $folder.Name
    Write-Host "Extracting the following from ${folderName}:" -ForegroundColor Green

    foreach ($file in Get-ChildItem $folder){
       
        $fileName = $file.Name

        Write-Host "`t- ${fileName}" -ForegroundColor Yellow
        Move-Item -Path $file -Destination $PSScriptRoot
    }

    Remove-Item $folder

    Write-Host "------------------------------" -ForegroundColor Cyan
}

Write-Host "------- GROUPING FILES -------" -ForegroundColor Cyan

# After extracting all files into the root folder, group files into folders by their file type but ignore .ps1 files
# and extracted folders if any.
foreach ($file in Get-ChildItem -Exclude *.ps1 -File *){
    
    # Build file path for current file type folder
    $fileName = $file.Name
    $fileType = $file.Extension
    $rootFolder = $PSScriptRoot
    $currentFileFolder = "${rootFolder}\${fileType}"

    Write-Host "Current file type: ${fileType}" -ForegroundColor Yellow

   # If folder exist for current file type, add file to said folder, else create folder for current file type.
    if (Test-Path -Path $currentFileFolder){

        #Write-Host "Folder for ${file.Extension} exists!"
        Write-Host "Moving ${fileName} to ${fileType} folder..." -ForegroundColor Green

        Move-Item -Path $file -Destination $currentFileFolder

    } else {
        
        Write-Host "Folder ${fileType} does not exist!" -ForegroundColor Red
        Write-Host "Creating folder for ${fileType} files..." -ForegroundColor Green
        New-Item -Path $currentFileFolder -ItemType Directory
        
        Write-Host "Moving ${fileName} to ${fileType} folder..." -ForegroundColor Green
        Move-Item -Path $file -Destination $currentFileFolder
    }

    Write-Host "------------------------------" -ForegroundColor Cyan
}