#================================================================================
# AnimeRSSMove v2.0 by Neo
# AnimeRSSMove.ps1 -OutputPath = '<file destination>' -InputFile '<file path>'
# AnimeRSSMove.ps1 -OutputPath = '<files destination>' -InputPath '<folder path>'
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
$host.ui.RawUI.WindowTitle = "AnimeRSSMove v2.0 by Neo"

# Wait 5 seconds to bypass errors created by other software.
Start-Sleep -Seconds 5

# Default variables.
$TrueOutputPath = $OutputPath.TrimEnd('\')

# Script if InputFile exists.
If ($InputFile) {
	# Check if input file exists, if it doesn't exit script.
	If (-Not ([System.IO.File]::Exists($InputFile))) {
		Write-Host "Input file doesn't exist."
		break
	}

	# Check if output path exists, if it doesn't exit script.
	If (-Not (Test-Path $TrueOutputPath)) {
		Write-Host "Output path doesn't exist."
		break
	}

	# Script variables.
	$InputFileName = Split-Path $InputFile -Leaf
	$InputFileStartSubstring = $InputFileName.IndexOf("]")
	$InputFileEndSubstring = $InputFileName.LastIndexOf("-")
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
		$InputFileEndSubstring = $InputFileName.LastIndexOf("-")
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
