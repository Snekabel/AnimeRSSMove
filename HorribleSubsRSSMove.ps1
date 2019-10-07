#=================================================
# HorribleSubsRSSMove v1.0 by Neo
# HorribleSubsRSSMove.ps1 -InputFile '<file path>'
#=================================================
### Parameters, Title, Checks, Variables
# Set parameters
Param(
  [Parameter(Mandatory=$true, Position=0)]
  [string]$InputFile = ""
)

# Set PowerShell title.
$host.ui.RawUI.WindowTitle = "HorribleSubsRSSMove v1.0 by Neo"

# Wait 5 seconds to bypass errors created by other software.
Start-Sleep -Seconds 5

# Check if input file exists, if it doesn't exit script.
If (-Not ([System.IO.File]::Exists($InputFile))) {
	exit
}

# Default variables.
$InputFileName = Split-Path $InputFile -Leaf
$OutputPath = "Q:\Shared\Anime\Series\Airing\"
$InputFileStartTrim = "[HorribleSubs]"
$InputFileEndCharacter = "-"
$FolderName = $InputFileName.Substring(0, $InputFileName.LastIndexOf($InputFileEndCharacter)).TrimStart($InputFileStartTrim).Trim()
$FolderPath = $OutputPath + $FolderName
$FolderPathFileName = $FolderPath + "\" + $InputFileName

# Check if folder path exists, if it doesn't create folder.
If (-Not (Test-Path $FolderPath)) {
	New-Item -Path $OutputPath -Name $FolderName -ItemType "directory"
}

# Check if file already exists in the path, if it does delete it.
If ([System.IO.File]::Exists($FolderPathFileName)) {
	[System.IO.File]::Delete($FolderPathFileName)
}

# Move file to new folder.
[System.IO.File]::Move($Inputfile, $FolderPathFileName)
