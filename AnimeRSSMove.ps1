#================================================================================
# AnimeRSSMove v4.0 by Neo
# AnimeRSSMove.ps1 -OutputPath "<file destination>" -InputFile "<file path>"
# AnimeRSSMove.ps1 -OutputPath "<files destination>" -InputPath "<folder path>"
#================================================================================
### Parameters, Title, Checks, Variables, Script
# Set parameters
Param(
	[Parameter(Mandatory=$true, Position=0)]
	[string]$OutputPath = "",
	[Parameter(Mandatory=$false, Position=1)]
	[string]$InputFile = "",
	[Parameter(Mandatory=$false, Position=2)]
	[string]$InputPath = ""
)

# Set PowerShell title.
$host.ui.RawUI.WindowTitle = "AnimeRSSMove v4.0 by Neo"

# Wait 5 seconds to bypass errors created by other software.
# Start-Sleep -Seconds 5

# Default variables.
$OutputPath = $OutputPath.TrimStart("'").TrimEnd("'")
$InputFile = $InputFile.TrimStart("'").TrimEnd("'")
$InputPath = $InputPath.TrimStart("'").TrimEnd("'")
$TrueOutputPath = $OutputPath.TrimEnd("\")

# Script if InputFile exists.
If ($InputFile) {
	# Check if input file exists, if it doesn't exit script.
	If (-Not ([System.IO.File]::Exists($InputFile))) {
		Write-Host "Input file doesn't exist."
		Write-Host $InputFile
		break
	}

	# Check if output path exists, if it doesn't exit script.
	If (-Not (Test-Path $TrueOutputPath)) {
		Write-Host "Output path doesn't exist."
		Write-Host $OutputPath
		break
	}

	# Script variables.
	$InputFileName = Split-Path $InputFile -Leaf
	$InputFileStartSubstring = $InputFileName.IndexOf("]")
	$InputFileEndSubstring = $InputFileName.LastIndexOf(" - ")
	$FolderName = $InputFileName.Substring(0, $InputFileEndSubstring).Substring($InputFileStartSubstring+1).Trim()
	$FolderPath = $TrueOutputPath + "\" + $FolderName
	$FolderPathFileName = $FolderPath + "\" + $InputFileName

	# Replace "SX" with "Season X" to circumvent any problems in Plex.
	$FolderPath = $FolderPath -replace "S2", "Season 2"
	$FolderName = $FolderName -replace "S2", "Season 2"
	$FolderPathFileName = $FolderPathFileName -replace "S2", "Season 2"
	$FolderPath = $FolderPath -replace "S3", "Season 3"
	$FolderName = $FolderName -replace "S3", "Season 3"
	$FolderPathFileName = $FolderPathFileName -replace "S3", "Season 3"
	$FolderPath = $FolderPath -replace "S4", "Season 4"
	$FolderName = $FolderName -replace "S4", "Season 4"
	$FolderPathFileName = $FolderPathFileName -replace "S4", "Season 4"
	$FolderPath = $FolderPath -replace "S5", "Season 5"
	$FolderName = $FolderName -replace "S5", "Season 5"
	$FolderPathFileName = $FolderPathFileName -replace "S5", "Season 5"
	$FolderPath = $FolderPath -replace "S6", "Season 6"
	$FolderName = $FolderName -replace "S6", "Season 6"
	$FolderPathFileName = $FolderPathFileName -replace "S6", "Season 6"
	$FolderPath = $FolderPath -replace "S7", "Season 7"
	$FolderName = $FolderName -replace "S7", "Season 7"
	$FolderPathFileName = $FolderPathFileName -replace "S7", "Season 7"
	$FolderPath = $FolderPath -replace "S8", "Season 8"
	$FolderName = $FolderName -replace "S8", "Season 8"
	$FolderPathFileName = $FolderPathFileName -replace "S8", "Season 8"

	# Check if folder path exists, if it doesn't create folder.
	If (-Not (Test-Path $FolderPath)) {
		New-Item -Path $TrueOutputPath -Name $FolderName -ItemType "directory"
	}

	# Check if file already exists in the path, if it does delete it.
	If ([System.IO.File]::Exists($FolderPathFileName)) {
		[System.IO.File]::Delete($FolderPathFileName)
	}

	# Move file to new folder.
	[System.IO.File]::Move($Inputfile, $FolderPathFileName)
}

# Script if InputPath exists.
If ($InputPath) {
	# Get files from InputPath.
	$InputPathFiles = Get-ChildItem -File -Path $InputPath -Recurse
	
	# Run ForEach loop on all files in InputPath.
	ForEach ($Item in $InputPathFiles) {
		# Check if input file exists, if it doesn't exit script.
		If (-Not ([System.IO.File]::Exists($Item.FullName))) {
			Write-Host $Item "in input path array doesn't exist."
			break
		}

		# Check if output path exists, if it doesn't exit script.
		If (-Not (Test-Path $TrueOutputPath)) {
			Write-Host "Output path doesn't exist."
			break
		}

		# Script variables.
		$InputFileName = Split-Path $Item -Leaf
		$InputFileStartSubstring = $InputFileName.IndexOf("]")
		$InputFileEndSubstring = $InputFileName.LastIndexOf(" - ")
		$FolderName = $InputFileName.Substring(0, $InputFileEndSubstring).Substring($InputFileStartSubstring+1).Trim()
		$FolderPath = $TrueOutputPath + "\" + $FolderName
		$FolderPathFileName = $FolderPath + "\" + $InputFileName

		# Check if folder path exists, if it doesn't create folder.
		If (-Not (Test-Path $FolderPath)) {
			New-Item -Path $TrueOutputPath -Name $FolderName -ItemType "directory"
		}

		# Check if file already exists in the path, if it does delete it.
		If ([System.IO.File]::Exists($FolderPathFileName)) {
			[System.IO.File]::Delete($FolderPathFileName)
		}

		# Move file to new folder.
		[System.IO.File]::Move($Item.FullName, $FolderPathFileName)
	}
}
