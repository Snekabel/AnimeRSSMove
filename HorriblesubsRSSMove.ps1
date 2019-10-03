#===============================================
# HorriblesubsRSSMove v1.0 by Neo
# HorriblesubsRSSMove.ps1 -InputFile <file path>
#===============================================
### Parameters, Title, Checks, Variables
# Set parameters
Param(
  [Parameter(Mandatory=$true, Position=0)]
  [string]$InputFile = ""
)

# Set PowerShell title.
$host.ui.RawUI.WindowTitle = "HorriblesubsRSSMove v1.0 by Neo"

# Check if input file exists, if it doesn't exit script.
If (-Not ([System.IO.File]::Exists($InputFile))) {
	exit
}

# Default variables.
$InputFileName = Split-Path $InputFile -Leaf
$OutputPath = "Q:\Shared\Anime\Series\Airing\"
$InputFileStartTrim = "[HorribleSubs] "
$InputFileEndCharacter = "-"
$FolderName = $InputFileName.Substring(0, $InputFileName.LastIndexOf($InputFileEndCharacter)).TrimStart($InputFileStartTrim)
$FolderPath = $OutputPath + $FolderName
$FolderPathFileName = $FolderPath + "\" + $InputFileName

# Check if folder path exists, if it doesn't create folder.
If (-Not (Test-Path $FolderPath)) {
	New-Item -Path $OutputPath -Name $FolderName -ItemType "directory"
}

# Move file to new folder.
[System.IO.File]::Move($Inputfile, $FolderPathFileName)