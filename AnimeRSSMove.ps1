#================================================================================
# AnimeRSSMove v5.0 by Neo
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
$host.ui.RawUI.WindowTitle = "AnimeRSSMove v5.0 by Neo"

# Wait 5 seconds to bypass errors created by other software.
# Start-Sleep -Seconds 5

# Define default variables.
$OutputPath = $OutputPath.TrimStart("'").TrimEnd("'")
$InputFile = $InputFile.TrimStart("'").TrimEnd("'")
$InputPath = $InputPath.TrimStart("'").TrimEnd("'")
$TrueOutputPath = $OutputPath.TrimEnd("\")

# Define error codes and messages variables.
$ErrorInputFileDoesNotExist = "Error code 1: Input file doesn't exist."
$ErrorInputPathDoesNotExist = "Error code 2: Input path doesn't exist."
$ErrorOutputPathDoesNotExist = "Error code 3: Output path doesn't exist."
$ErrorMovingFile = "Error code 4: Error moving file."

# Define log file path variable.
$LogFilePath = "C:\temp\AnimeRSSMove.log"

# Get current date and time.
$DateTime = Get-Date

# Script if InputFile variable exists.
If ($InputFile) {
	# Check if input file exists, and write error message to log and exit script if it doesn't.
	If (-Not ([System.IO.File]::Exists($InputFile))) {
		# Write error message to log file.
		Add-Content -Path $LogFilePath -Value "$DateTime - $ErrorInputFileDoesNotExist - $InputFile"

		# Write error message to console and exit script.
		Write-Error "$DateTime - $ErrorInputFileDoesNotExist - $InputFile" -Action Stop
	}

	# Check if output path exists, and write error message to log and exit script if it doesn't.
	If (-Not (Test-Path $TrueOutputPath)) {
		# Write error message to log file.
		Add-Content -Path $LogFilePath -Value "$DateTime - $ErrorOutputPathDoesNotExist - $OutputPath"

		# Write error message to console and exit script.
		Write-Error "$DateTime - $ErrorOutputPathDoesNotExist - $OutputPath" -Action Stop
	}

	# Script variables.
	$InputFileName = Split-Path $InputFile -Leaf
	# Welcome to REGEX HELL.
	$FolderName = $InputFileName -replace "\d+(\.[a-zA-Z]{3,4})$", "" -replace '(\d+)(\s\[TV\sx264\s10bit\s1080p\sAAC\s2.0\sDual\]).*', '' -replace '( - \d{1,2}(S\d{1,2}E\d{1,2})?$).*', '' -replace '(\d+)(\s\(BD\s1080p\)\.[mkv|avi|mp4]+)', '' -replace '(_\d+v?\d*).*', '' -replace '_', ' ' -replace " - SP\d+", "" -replace '\[.*?\]', '' -replace '\.mkv|\.avi|\.mp4', '' -replace "\.", " " -replace '\(.*?\)', '' -replace '( - \d{1,2}(S\d{1,2}E\d{1,2})?$).*', '' -replace '( - S\d+E\d+| - \d+).*', '' -replace '(S\d+E\d+).*', '' -replace '(.(SP|EP)\d+)*', '' -replace '(e\d+.*)', '' -replace '(\sep\s*\d+).*', '' -replace '( -$)', '' -replace '( - $)', '' -replace '- S\d+E?\b', ''
	$FolderName = $FolderName.Trim()
	# Replace "SX -" with "Season X -" and remove any 0's in front to circumvent any problems in Plex.
	$FolderName = $FolderName -replace 'S0*(\d+)$', 'Season $1'
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

	# Move input file to output folder and check if move was sucessfully ran.
	if (-Not [System.IO.File]::Move($InputFile, $FolderPathFileName)) {
		# Write error message to log file.
		Add-Content -Path $LogFilePath -Value "$DateTime - $ErrorMovingFile - $InputFile to $FolderPathFileName"

		# Write error message to console.
		Write-Error "$DateTime - $ErrorMovingFile - $InputFile to $FolderPathFileName" -Action Stop
	}
}

# Script if InputPath variable exists.
If ($InputPath) {
	# Check if input path exists, and write error message to log and exit script if it doesn't.
	If (-Not (Test-Path $InputPath)) {
		# Write error message to log file.
		Add-Content -Path $LogFilePath -Value "$DateTime - $ErrorInputPathDoesNotExist - $InputPath"

		# Write error message to console and exit script.
		Write-Error "$DateTime - $ErrorInputPathDoesNotExist - $InputPath" -Action Stop
	}

	# Check if output path exists, and write error message to log and exit script if it doesn't.
	If (-Not (Test-Path $TrueOutputPath)) {
		# Write error message to log file.
		Add-Content -Path $LogFilePath -Value "$DateTime - $ErrorOutputPathDoesNotExist - $OutputPath"

		# Write error message to console and exit script.
		Write-Error "$DateTime - $ErrorOutputPathDoesNotExist - $OutputPath" -Action Stop
	}

	# Get files from InputPath.
	$InputPathFiles = Get-ChildItem -File -Path $InputPath -Recurse
	
	# Run ForEach loop on all files in InputPath.
	ForEach ($Item in $InputPathFiles) {
		# Check if input file exists, if it doesn't exit script.
		If (-Not ([System.IO.File]::Exists($Item.FullName))) {
			Write-Host $Item "in input path array doesn't exist."
			break
		}

		# Script variables.
		$InputFileName = Split-Path $Item -Leaf
		# Welcome to REGEX HELL.
		$FolderName = $InputFileName -replace "\d+(\.[a-zA-Z]{3,4})$", "" -replace '(\d+)(\s\[TV\sx264\s10bit\s1080p\sAAC\s2.0\sDual\]).*', '' -replace '( - \d{1,2}(S\d{1,2}E\d{1,2})?$).*', '' -replace '(\d+)(\s\(BD\s1080p\)\.[mkv|avi|mp4]+)', '' -replace '(_\d+v?\d*).*', '' -replace '_', ' ' -replace " - SP\d+", "" -replace '\[.*?\]', '' -replace '\.mkv|\.avi|\.mp4', '' -replace "\.", " " -replace '\(.*?\)', '' -replace '( - \d{1,2}(S\d{1,2}E\d{1,2})?$).*', '' -replace '( - S\d+E\d+| - \d+).*', '' -replace '(S\d+E\d+).*', '' -replace '(.(SP|EP)\d+)*', '' -replace '(e\d+.*)', '' -replace '(\sep\s*\d+).*', '' -replace '( -$)', '' -replace '( - $)', '' -replace '- S\d+E?\b', ''
		$FolderName = $FolderName.Trim()
		# Replace "SX -" with "Season X -" and remove any 0's in front to circumvent any problems in Plex.
		$FolderName = $FolderName -replace 'S0*(\d+)$', 'Season $1'
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

		# Move input file to output folder and check if move was sucessfully ran.
		if (-Not [System.IO.File]::Move($InputFile, $FolderPathFileName)) {
			# Write error message to log file.
			Add-Content -Path $LogFilePath -Value "$DateTime - $ErrorMovingFile - $InputFile to $FolderPathFileName"

			# Write error message to console.
			Write-Error "$DateTime - $ErrorMovingFile - $InputFile to $FolderPathFileName" -Action Stop
		}
	}
}
