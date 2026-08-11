<#PSScriptInfo

.VERSION 2026.8.11.0

.GUID 3a7b9c4d-2e8f-4a1b-9d6c-5e3f7a8b9c2d

.AUTHOR Michael Escamilla

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI https://github.com/MichaelEscamilla/GetMSIInformation

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
1.0.0.0       - Initial release
2.0.0.0       - 10-4-2024 - Added file hash information, and context menu items for the installation and uninstallation of a Right-Click Option in Windows Explorer. And some other UI improvements.
2024.10.4.1   - Updated the version numbering, and a sepearator in the context menu.
2024-10.13.0  - Added an error message when the file is locked
2024-12.8.0   - Formatted Script for Publishing to PowerShell Gallery
2026-1.5.0    - Added Icon extraction and export functionality. Added context menu items to open the icon temp folder and right-click menu folder.
2026.1.5.1    - Fixed a bug when launching the script from the internet
2026.1.6.0    - Fixed a bug where the 'No Icon' label would not hide
2026.1.6.1    - Added the michaeltheadmin.com icon to the Form and Right-Click Menu
2026.1.7.0    - Simplified console output messages during script download from GitHub
2026.8.11.0   - Updated UI for less 'default' look.
                Added the Compressed Product Code (Compressed GUID) to the GUI.
                Right-Click Install will directly call pwsh.exe if available.

.PRIVATEDATA

#> 

<#
.SYNOPSIS
This script provides a graphical user interface (GUI) for viewing and copying properties of MSI files.

.DESCRIPTION
The script creates a WPF-based GUI that allows users to drag and drop MSI files to view their properties such as Product Name, Manufacturer, Product Version, Product Code, and Upgrade Code.
It also provides functionality to copy these properties to the clipboard and to clear the displayed information.
Additionally, the script includes options to install and uninstall a context menu item for MSI files to retrieve their properties.

.PARAMETER FilePath
Optional parameter to specify the path of the MSI file to automatically load the information for.

.NOTES

#>

param (
  [Parameter(Mandatory = $false)]
  [string]$FilePath
)

#############################################
################# Variables #################
#############################################
# Script Name
$Script:ScriptName = "GetMSIInformation.ps1"
# Script Version
[System.Version]$Script:ScriptVersion = "2026.8.11.0"
# Right-Click Menu
$Script:RightClickMenuName = "Get MSI Information"
$Script:RightClickMenuFolderPath = "$env:LOCALAPPDATA\GetMSIInformation"
# Icon Temp Folder Path
$Script:IconTempFolderPath = "$env:TEMP\GetMSIInformation\Icons"
# Get the Security Principal
$Script:currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# Get PowerShell Version
$Script:ScriptPSVersion = $PSVersionTable.PSVersion
# Get Pwsh Path
$Script:PowerShellPath = (Get-Command pwsh.exe -ErrorAction SilentlyContinue)
# michaeltheadmin.com Icon
$Script:WindowIconBase64 = "AAABAAEAIBwAAAEAIACYDgAAFgAAACgAAAAgAAAAOAAAAAEAIAAAAAAAcA4AAMQOAADEDgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABaSFoNRkZGEUtLSxBLS0sQS0tLEEtLSxBLS0sQS0tLEEtLSxBLS0sQS0tLEEtLSxBLS0sQS0tLEEtLSxBLS0sQS0tLEEtLSxBLS0sQS0tLEEtLSxBLS0sQS0tLEEtLSxBLS0sQS0tLEFRGRhFaSEgNAAAAAAAAAABUVFQLUkxPrFNOUOlRTE7tUUxO7FFMTuxRTE7sUUxO7FFMTuxRTE7sUUxO7FFMTuxRTE7sUUxO7FFMTuxRTE7sUUxO7FFMTuxRTE7sUUxO7FFMTuxRTE7sUUxO7FFMTuxRTE7sUUxO7FFMTuxRTE7sUUxO7VROUOhSTU+qTExMCU5KTH5lYWP/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bm1t/25tbf9ubW3/bmxt/2RfYf9OSkx6TkhLtWtoaf94eHj/dnZ2/3V1df91dXX/dXV1/3V1df91dXX/dXV1/3V1df91dXX/dXV1/3V1df91dXX/dXV1/3V1df91dXX/dXV1/3V1df91dXX/dXV1/3V1df91dXX/dXV1/3V1df91dXX/dXV1/3Z2dv94eHj/aWZn/05IS69OSUuxamdo/3h4eP9mZGX/Uk1P/05JS/9OSUv/VVFT/1VRUv9OSUv/T0pM/09KTP9PSkz/T0pM/09KTP9PSkz/T0pM/09KTP9PSkz/T0pM/09KTP9PSkz/TklL/1VRU/9VUVP/TklL/05JS/9STlD/ZmRl/3h4eP9oZWb/T0lMqk9JTLBqZ2j/eHl4/1dUVf90cHH/rqys/62rrP9rZ2j/b2tt/66srP+npaX/p6Wl/6elpf+npaX/p6Wl/6elpf+npaX/p6Wl/6elpf+npaX/p6Wl/6elpf+tq6z/a2do/29rbP+urKz/rays/3Bsbv9YVVb/eHl5/2hlZv9PSUyqT0lMsGpnaP94eXj/U1BR/5GPkP/09PT/8/Pz/399ff+Hg4X/9PT0/+jo6P/o6Oj/6Ojo/+jo6P/o6Oj/6Ojo/+jo6P/o6Oj/6Ojo/+jo6P/o6Oj/6Ojo//Pz8/9/fX3/hoOE//T09P/z9PP/i4iJ/1VRUv94eXn/aGVm/09JTKpPSUywamdo/3h5eP9VUlP/hIGC/9PS0v/S0dH/dXJz/3t3ef/T0tL/ycjI/8rJyv/Kycr/ycjI/8nIyP/Kycr/ysnK/8nIyP/JyMj/ysnK/8vKyf/Lycj/1NLR/3dzc/98eHj/1dPS/9TT0f9/fHz/V1NU/3h5ef9oZWb/T0lMqk9JTLBqZ2j/eHl4/19cXv9TTU//V1JU/1dSVP9TTlD/VE9R/1dSVP9XUlT/V1NV/1dTVf9XUlT/V1JU/1dTVf9XU1X/V1JU/1dSVP9XU1X/WFNU/1hSVP9ZU1T/VU9Q/1VPUP9ZU1T/WVNU/1JNTv9gXV7/eHl5/2hlZv9PSUyqT0lMsGpnaP94eXj/V1NV/3x4ef/Hx8j/v76//8HAwf/BwMD/v76//8jHx/9ybnD/dnN0/8jIyP/Ix8f/cm9w/3Vxc//Ix8j/yMfI/4B2cP85VYL/LXrf/y933P8xed7/MXne/y933P8tet7/Q1p//2NaU/94eXn/aGVm/09JTKpPSUywamdo/3h5eP9UUFL/jImK//L09P/n6Oj/5+jo/+fo6P/n6Oj/8/Pz/4B9f/+Gg4T/9PT0//L08/+Afn//hICC//L09P/y9PT/k4h//zRblv8jjf//J4n//yeJ//8nif//J4n//yON//9AYJL/Y1lQ/3h5ef9oZWb/T0lMqk9JTLBqZ2j/eHl4/1hUVv95dHP/v7u3/7izr/+3tLP/tLO0/7GwsP+5t7j/cGxu/3Rwcf+5uLj/ubi4/3Bsbv9ybnD/ubi4/7m4uP98c27/PVV9/y5zzf8xcMr/NHTO/zR0zv8xcMr/LnPN/0RXef9jWlX/eHl5/2hlZv9PSUyqT0lMsGpnaP94eXj/YFxd/01LUv9ITVz/SE5d/0pJUP9TTU7/XFdZ/1tXWf9VUVL/VlFT/1tXWf9bV1n/VVFT/1ZRU/9cV1n/XFdZ/1VQU/9ZU1L/ZFtY/2RbV/9ZUEz/WlFN/2RbWP9kW1j/VlBQ/19cXv94eXn/aGVm/09JTKpPSUywamdo/3h5eP9jWFH/QF+Q/ymE+f8phPn/OFiJ/4yCe//e3t7/3d3d/3p2eP9/fH3/3t7e/93e3f96d3j/fXl7/93e3v/d3t7/fXp7/4B9fv/f3t7/3t3d/3p2d/9/fH3/397e/97e3f+DgIH/VlJT/3h5ef9oZWb/T0lMqk9JTLBqZ2j/eHl4/2NYT/8+Ypr/JI3//ySN//81WpL/lYuC//Pz8//y8vL/gHx+/4aDhP/z8/P/8vPy/4B9fv+DgIL/8vPz//Lz8/+DgYL/h4SF//Pz8//y8vL/f3x9/4aDhP/z8/P/8vPy/4qIiP9VUVL/eHl5/2hlZv9PSUyqT0lMsGpnaP94eXj/YFhV/0ZTbv87aaj/O2mo/0NRbP9waGX/m5iZ/5uYmf9mYWP/aGRm/5uYmf+bmJn/ZmJj/2djZf+bmJn/m5iZ/2djZf9pZWb/m5iZ/5uYmf9lYWL/amZo/6Cdnv+fnZ7/a2Zo/1lVV/94eXn/aGVm/09JTKpOSUuxamdo/3d4eP9nZmj/XFVT/2BUTP9gVEz/X1hV/1dUVv9QTE7/UExO/1lVV/9ZVVb/UExO/1BMTv9ZVVf/WVVW/1BMTv9QTE7/WVVW/1hVVv9QTE7/UExO/1lVV/9ZVVb/UE1O/1FNTv9WUlT/aWdo/3d4eP9oZWb/TkhLq09JTLNraGn/eHl5/3d3d/93eHj/d3h3/3d4d/93eHf/d3h3/3d4d/93eHf/d3h3/3d4d/93eHf/d3h3/3d4d/93eHf/d3h3/3d4d/93eHf/d3h3/3d4d/93eHf/d3h3/3d4d/93eHf/d3h3/3d4eP93d3f/eHl4/2hmZ/9OSEuuUUpMbWRfYf9ta2z/bWts/21rbP9ta2z/bWts/21rbP9ta2z/bWts/21rbP9ta2z/bWts/21rbP9ta2z/amhp/2poaf9ta2z/bWts/21rbP9ta2z/bWts/21rbP9ta2z/bWts/21rbP9ta2z/bWts/21rbP9samv/Yl1f/1BLS2hRUVECUUtNjFNNT89QS0zTUEpM01BKTNNQSkzTUEpM01BKTNNQSkzTUEpM01BKTNNQSkzTUEpM01BLTdFQS03yUEtN8FBLTdFQSkzTUEpM01BKTNNQSkzTUEpM01BKTNNQSkzTUEpM01BKTNNQSkzTUEtM01NNT89RTE6IfHx8AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFNMT7lTTVCmAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU01Qs1JNT7gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABTTU1RWFNV/1NOUIhUTE9pVFBSaExMTBYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABRTE9mVlFS11NOUOJWUVLdUEtQNQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//////////wAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//n////5////+B////wf///////////8="

#############################################
################# Functions #################
#############################################
#region Functions
function Test-FileLock {
  param (
    [Parameter(Mandatory = $true)]
    [string]$Path
  )

  try {
    $FileStream = [System.IO.File]::Open("$($Path)", 'Open', 'Write')
    $FileStream.Close()
    $FileStream.Dispose()
    return $false
  }
  catch {
    return $true
  }
}

function Get-MsiProperties {
  param (
    [Parameter(Mandatory = $true)]
    [IO.FileInfo[]]$Path
  )

  Write-Host "Getting MSI Properties for: [$Path]"
	
  # Check if the MSI file path exists
  if (-not (Test-Path $Path)) {
    throw "The file $Path does not exist."
  }
	
  # Create a new Windows Installer COM object
  $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
	
  # Open the MSI database in read-only mode
  $MSIDatabase = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $WindowsInstaller, @($Path.FullName, 0))
	
  # Open a view on the Property table
  $MSIPropertyView = $MSIDatabase.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $MSIDatabase, @("SELECT * FROM Property"))
	
  # Execute the view query
  $MSIPropertyView.GetType().InvokeMember("Execute", "InvokeMethod", $null, $MSIPropertyView, $null) | Out-Null
	
  # Fetch the first record from the result set
  $MSIRecord = $MSIPropertyView.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $MSIPropertyView, $null)

  # Initialize an empty System Object to store properties
  [System.Object]$Properties = @{}
	
  # Loop through all records in the result set
  while ($null -ne $MSIRecord) {
    # Get the property name from the first column
    $property = $MSIRecord.GetType().InvokeMember("StringData", "GetProperty", $null, $MSIRecord, @(1))
			
    # Get the property value from the second column
    $Value = $MSIRecord.GetType().InvokeMember("StringData", "GetProperty", $null, $MSIRecord, @(2))
			
    # Add the property name and value to the hashtable
    $Properties[$Property] = $Value
			
    # Fetch the next record from the result set
    $MSIRecord = $MSIPropertyView.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $MSIPropertyView, $null)
  }

  # Close the Property view
  $MSIPropertyView.GetType().InvokeMember("Close", "InvokeMethod", $null, $MSIPropertyView, $null) | Out-Null
	
  # Return the System Object of properties
  $Properties
}

# Stolen from: https://github.com/codaamok
# https://gist.github.com/codaamok/7ed30d01280ce28bb451621966707c1b
function Convert-ProductCodeToCompressedGuid {
  param(
    [Parameter(Mandatory = $true)]
    [string]$ProductCode
  )

  function Get-ReversedString ([array]$a) {
    [String]::Join('', $a[-1.. - ($a.Count)])
  }

  function Get-ReversedBytes ([String]$a) {
    [String]::Join('', ($a -split '(..)' -ne '' -replace '(\w)(\w)', '$2$1'))
  }

  # Strip braces and dashes from the GUID
  $ProductCode = $ProductCode -replace '\{|\}|\-'

  $data1 = Get-ReversedString $ProductCode[0..7]
  $data2 = Get-ReversedString $ProductCode[8..11]
  $data3 = Get-ReversedString $ProductCode[12..15]
  $data4 = Get-ReversedBytes ($ProductCode[16..19] -join '')
  $data5 = Get-ReversedBytes ($ProductCode[20..31] -join '')

  return '{0}{1}{2}{3}{4}' -f $data1, $data2, $data3, $data4, $data5
}

function Enable-AllButtons {
  param (
    [Parameter(Mandatory = $false)]
    [string]$Exclude
  )

  # Get all button variables
  $Buttons = Get-Variable -Name "btn_*" -ValueOnly -ErrorAction SilentlyContinue
  foreach ($Button in $Buttons) {
    # Check that the button name does not contain the exclude variable
    if ($Button.Name -notlike "*$Exclude*") {
      # Enable Button
      $Button.IsEnabled = $true
    }
  }
}

function Disable-AllButtons {
  # Get all button variables
  $Buttons = Get-Variable -Name "btn_*" -ValueOnly -ErrorAction SilentlyContinue
  foreach ($Button in $Buttons) {
    # Disable Button
    $Button.IsEnabled = $false
  }
}

function Clear-Textboxes {
  # Get all textbox variables
  $Textboxes = Get-Variable -Name "txt_*" -ValueOnly -ErrorAction SilentlyContinue
  foreach ($Textbox in $Textboxes) {
    # Clear textbox
    $Textbox.Clear()
  }
}

# Stolen from: https://github.com/PatchMyPCTeam/CustomerTroubleshooting/blob/Release/PowerShell/Get-LocalContentHashes.ps1
function Get-EncodedHash {
  [CmdletBinding()]
  Param(
    [Parameter(Position = 0)]
    [System.Object]$HashValue
  )

  $hashBytes = $hashValue.Hash -split '(?<=\G..)(?=.)' | ForEach-Object { [byte]::Parse($_, 'HexNumber') }
  Return [Convert]::ToBase64String($hashBytes)
}

function Get-FileHashInformation {
  param (
    [Parameter(Mandatory = $true)]
    [IO.FileInfo[]]$Path

  )

  Write-Host "Getting File Hash Information for: [$Path]"

  # Initialize the hash object
  $Hashes = @{}

  # Get File Hash - MD5
  $FileHashMD5 = Get-FileHash -Path $Path -Algorithm MD5
  $Hashes["MD5"] = $FileHashMD5

  # Get File Hash - SHA1
  $FileHashSHA1 = Get-FileHash -Path $Path -Algorithm SHA1
  $Hashes["SHA1"] = $FileHashSHA1

  # Get File Hash - SHA256
  $FileHashSHA256 = Get-FileHash -Path $Path -Algorithm SHA256
  $Hashes["SHA256"] = $FileHashSHA256

  # Get File Hash - SHA1 - Encoded
  $FileHashEncoded = Get-EncodedHash -HashValue $FileHashSHA1
  $Hashes["Digest"] = $FileHashEncoded

  # Get File Hash - SHA256 - Encoded
  $FileHashSHA256Encoded = Get-EncodedHash -HashValue $FileHashSHA256
  $Hashes["D256"] = $FileHashSHA256Encoded

  # Return the hash object
  $Hashes
}

function Get-MsiIcon {
  param (
    [Parameter(Mandatory = $true)]
    [IO.FileInfo[]]$Path,
    [Parameter(Mandatory = $false)]
    [string]$ExportFolder = "$($Script:IconTempFolderPath)"
  )

  Write-Host "Getting MSI Icon for: [$Path]"
  
  # Ensure the export folder exists
  if (-not (Test-Path -Path $ExportFolder)) {
    New-Item -ItemType Directory -Path $ExportFolder -Force | Out-Null
  }

  # Create a new Windows Installer COM object
  $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
    
  # Open the MSI database in read-only mode
  $MSIDatabase = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $null, $WindowsInstaller, @($Path.FullName, 0))

  # Get all Icons in the Icon table
  try {
    # Open a view on the Icon table to get the icon binary data
    $IconView = $MSIDatabase.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $MSIDatabase, @("SELECT Name FROM _Tables WHERE Name='Icon'"))

    # Execute the view query
    $IconView.GetType().InvokeMember("Execute", "InvokeMethod", $null, $IconView, $null) | Out-Null

    # Fetch Record
    $IconTable = $IconView.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $IconView, $null)

    # Close the Icon view
    $IconView.GetType().InvokeMember("Close", "InvokeMethod", $null, $IconView, $null) | Out-Null
  
    if ($IconTable) {
      # Open a view on the Icon table
      $IconData = $MSIDatabase.GetType().InvokeMember("OpenView", "InvokeMethod", $null, $MSIDatabase, @("SELECT Name,Data FROM Icon"))

      # Execute the view query
      $IconData.GetType().InvokeMember("Execute", "InvokeMethod", $null, $IconData, $null) | Out-Null

      # Start Building PSCustomObject
      [Collections.Generic.List[PSCustomObject]]$IconInformation = @()

      Do {
        # Fetch the next record
        $IconRecord = $IconData.GetType().InvokeMember("Fetch", "InvokeMethod", $null, $IconData, $null)

        if ($IconRecord) {
          # Get the 'Name' Field
          $IconDataName = $IconData.GetType().InvokeMember("StringData", 'Public, Instance, GetProperty', $null, $IconRecord, 1)

          # Get the DataSize of the Binary Data
          $IconDataSize = $IconData.GetType().InvokeMember("DataSize", "GetProperty", $null, $IconRecord, 2)

          Write-Verbose "Found Icon: [$IconDataName] with Size: [$IconDataSize] bytes"

          # Read the Binary Data
          $IconBinaryData = $IconData.GetType().InvokeMember("ReadStream", "InvokeMethod", $null, $IconRecord, @(2, $IconDataSize, 2))

          # Get Binary data as ANSI string - use Windows-1252 encoding
          $ByteArray = [System.Text.Encoding]::GetEncoding(1252).GetBytes($IconBinaryData)

          # Construct the path to save the ICO file
          $IconPathTemp = Join-Path -Path $ExportFolder -ChildPath "$($IconDataName)"

          # Check if the file already exists and delete it if necessary
          if (Test-Path -Path $IconPathTemp) {
            Remove-Item -Path $IconPathTemp -Force
          }

          # Write the byte array to an ICO file
          [System.IO.File]::WriteAllBytes($IconPathTemp, $ByteArray)

          # Create PSCustomObject for Icon Information
          $IconInfoObject = [PSCustomObject]@{
            Name = $IconDataName
            Size = $IconDataSize
            Path = $IconPathTemp
          }

          # Add to Icon Information List
          $IconInformation.Add($IconInfoObject)
        }
      } While ($IconRecord)

      # Close the IconData view
      $IconData.GetType().InvokeMember("Close", "InvokeMethod", $null, $IconData, $null) | Out-Null
    }
  }
  catch {
    Write-Verbose "Error retrieving Icons: $_"
  }
  
  Return $IconInformation
}

function Set-TextboxInformation {
  param (
    [Parameter(Mandatory = $false)]
    [System.Object]$MSIPropertiesInfo,
    [Parameter(Mandatory = $true)]
    [hashtable]$FileHashInfo
  )

  # Set the MSI file properties textboxes (only when MSI properties are provided)
  if ($MSIPropertiesInfo) {
    $txt_ProductName.Text = $MSIPropertiesInfo.ProductName
    $txt_Manufacture.Text = $MSIPropertiesInfo.Manufacturer
    $txt_ProductVersion.Text = $MSIPropertiesInfo.ProductVersion
    $txt_ProductCode.Text = $MSIPropertiesInfo.ProductCode
    $txt_UpgradeCode.Text = $MSIPropertiesInfo.UpgradeCode

    # Set the Compressed GUID from the Product Code
    if ($MSIPropertiesInfo.ProductCode) {
      $txt_CompressedGUID.Text = Convert-ProductCodeToCompressedGuid -ProductCode $MSIPropertiesInfo.ProductCode
    }
  }

  # Set the File Hash Information textboxes
  $txt_MD5.Text = $FileHashInfo.MD5.Hash
  $txt_SHA1.Text = $FileHashInfo.SHA1.Hash
  $txt_SHA256.Text = $FileHashInfo.SHA256.Hash
  $txt_Digest.Text = $FileHashInfo.Digest
  $txt_D256.Text = $FileHashInfo.D256
}

function Build-IconImageControls {
  param (
    [Parameter(Mandatory = $true)]
    [PSCustomObject[]]$IconObjects
  )

  # Start Building PSCustomObject
  [Collections.Generic.List[PSCustomObject]]$Script:IconImageControlsList = @()

  # Loop through each Icon
  $IconIndex = 0
  foreach ($IconObject in $IconObjects) {
    if ((Test-Path ($IconObject.Path))) {
      # IconBitmap Export File Path
      $IconBitmapPath = Join-Path -Path "$($IconObject.Path | Split-Path -Parent)" -ChildPath "$([System.IO.Path]::GetFileNameWithoutExtension($IconObject.Name))_Export.ico"

      # Extract the Binary file to a Bitmap File at 256px
      if ($Script:ScriptPSVersion -lt [Version]"7.4") {
        # This is the only method available in .NET 4.x.x
        $IconExtract = [System.Drawing.Icon]::ExtractAssociatedIcon($IconObject.Path)
      }
      else {
        # This uses newer .NET methods from 8+ and results in higher quality images
        $IconExtract = [System.Drawing.Icon]::ExtractIcon($IconObject.Path, 0, 256)
      }

      # Delete any existing ICO file
      #Remove-Item -Path "$($IconBitmapPath)" -Force -ErrorAction SilentlyContinue | Out-Null

      # Save the Extracted icon to a bitmap file
      $IconExtract.ToBitmap().Save("$($IconBitmapPath)")

      # Create BitmapImage from the Bitmap file
      $Bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
      $Bitmap.BeginInit()
      $Bitmap.StreamSource = [System.IO.MemoryStream]::new([System.IO.File]::ReadAllBytes("$($IconBitmapPath)"))
      $Bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
      $Bitmap.EndInit()
      $Bitmap.Freeze()
      
      # Create a New Image Control in the Grid 'grid_Icon'
      $ImageControlIcon = New-Object System.Windows.Controls.Image
      $ImageControlIcon.SetValue([System.Windows.Controls.Control]::NameProperty, "img_Icon_$(([System.IO.Path]::GetFileNameWithoutExtension($IconObject.Name)) -replace '[^a-zA-Z0-9]', '_')")
      $ImageControlIcon.Source = $Bitmap
      $ImageControlIcon.SetValue([System.Windows.Controls.Grid]::RowProperty, 0)
      $ToolTip = New-Object System.Windows.Controls.ToolTip
      if ($Script:ScriptPSVersion -lt [Version]"7.4") {
        $ToolTip.Content = "Click to Export.`nUse PowerShell 7.4 or higher for better quality."
        $ToolTip.Background = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Colors]::LightGoldenrodYellow)
        $ToolTip.Foreground = [System.Windows.Media.SolidColorBrush]::new([System.Windows.Media.Colors]::Red)
      }
      else { $ToolTip.Content = "Click to Export" }
      $ImageControlIcon.ToolTip = $ToolTip
      $ImageControlIcon.SetValue([System.Windows.Controls.ToolTipService]::InitialShowDelayProperty, 100)
      $ImageControlIcon.HorizontalAlignment = "Center"
      $ImageControlIcon.VerticalAlignment = "Center"
      $ImageControlIcon.Visibility = "Collapsed"
      $ImageControlIcon.add_mouseleftbuttonup($Button_ExportToPNG_Handler)

      # Add the Image Control to the Grid 'grid_Icon'
      $grid_Icon.Children.Add($ImageControlIcon)

      # Create PSCustomObject for the Image Control Information
      $ImageControlIconInfo = [PSCustomObject]@{
        Index          = $IconIndex
        Name           = $ImageControlIcon.Name
        IconName       = "$([System.IO.Path]::GetFileNameWithoutExtension($IconObject.Name))"
        IconBinaryPath = "$($IconObject.Path)"
        IconBitmapPath = "$($IconBitmapPath)"
        Control        = $ImageControlIcon
      }

      # Add to IconImageControlsList
      $Script:IconImageControlsList.Add($ImageControlIconInfo)
    }

    # Increment the Icon Index
    $IconIndex++
  }
}

function Set-IconImageNavigation {
  [CmdletBinding(DefaultParameterSetName = 'New')]
  param (
    [Parameter(Mandatory = $true, ParameterSetName = 'New')]
    [Parameter(Mandatory = $true, ParameterSetName = 'Next')]
    [Parameter(Mandatory = $true, ParameterSetName = 'Previous')]
    [PSCustomObject[]]$IconObjects,
    [Parameter(Mandatory = $false, ParameterSetName = 'Next')]
    [switch]$Next,
    [Parameter(Mandatory = $false, ParameterSetName = 'Previous')]
    [switch]$Previous
  )

  # IconImageControlsList Count
  $IconCount = $Script:IconImageControlsList.Count

  # Get the Current Icon Index
  if ($null -eq $Script:CurrentIconIndex) {
    $Script:CurrentIconIndex = 0
  }
  $CurrentIndex = $Script:CurrentIconIndex
  if ($Next) {
    # Increment the Index
    $NewIndex = $CurrentIndex + 1
  }
  elseif ($Previous) {
    # Decrement the Index
    $NewIndex = $CurrentIndex - 1
  }
  else {
    # If neither Next nor Previous is specified, keep the current index
    $NewIndex = $CurrentIndex
  }

  # Set GlobalIndex
  $Script:CurrentIconIndex = $NewIndex

  # Hide the 'No Icon' Label
  $lbl_NoIcon.Visibility = "Collapsed"
    
  # Hide the current Icon
  ($Script:IconImageControlsList | Where-Object { $_.Index -eq $CurrentIndex }).Control.Visibility = "Hidden"

  # Show the new Icon
  ($Script:IconImageControlsList | Where-Object { $_.Index -eq $NewIndex }).Control.Visibility = "Visible"

  # Set the Navigation button states
  if ($IconCount -gt 1) {
    if ($NewIndex -eq 0) {
      $btn_IconPrevious.IsEnabled = $false
      $btn_IconNext.IsEnabled = $true
    }
    elseif ($NewIndex -eq ($IconCount - 1)) {
      $btn_IconPrevious.IsEnabled = $true
      $btn_IconNext.IsEnabled = $false
    }
    else {
      $btn_IconPrevious.IsEnabled = $true
      $btn_IconNext.IsEnabled = $true
    }
  }
}

function Set-IconImage {
  param (
    [Parameter(Mandatory = $true)]
    [PSCustomObject[]]$IconObjects
  )

  # Build the Icon Image Controls
  Build-IconImageControls -IconObjects $IconObjects

  # Set the Icon Image Navigation
  Set-IconImageNavigation -IconObjects $Script:IconImageControlsList
}

function Clear-IconImageControls {
  # Clear the Script Scoped Variables
  Remove-Variable -Name IconImageControlsList -Scope Script -ErrorAction SilentlyContinue
  Remove-Variable -Name CurrentIconIndex -Scope Script -ErrorAction SilentlyContinue

  # Reload all Icon Image Controls on the form into variables
  $formMSIProperties.FindName("grid_Icon").Children | Where-Object { $_.Name -like "img_Icon*" } | ForEach-Object { Set-Variable -Name $_.Name -Value $_ -Scope Script }

  # Get all Icon Image Controls that start with the name 'img_Icon' and Hide them
  $IconImageControls = Get-Variable -Name "img_Icon*" -Scope Script -ErrorAction SilentlyContinue
  if ($null -ne $IconImageControls) {
    foreach ($IconImageControl in $IconImageControls) {
      $IconImageControl.Value.Visibility = "Collapsed"
    }
  }

  # Show the No Icon Label Visibility
  $lbl_NoIcon.Visibility = "Visible"

  # Disable the Icon Navigation buttons
  $btn_IconPrevious.IsEnabled = $false
  $btn_IconNext.IsEnabled = $false
}

function Invoke-FormReset {
  # Clear the Icon Image Controls
  Clear-IconImageControls

  # Clear the Textboxes
  Clear-Textboxes
  
  # Clear and Reset the listbox font style
  $lsbox_FilePath.Items.Clear()
  $lsbox_FilePath.ClearValue([System.Windows.Controls.Control]::BackgroundProperty)
  $lsbox_FilePath.ClearValue([System.Windows.Controls.Control]::ForegroundProperty)
  $lsbox_FilePath.ClearValue([System.Windows.Controls.Control]::FontWeightProperty)
  $lsbox_FilePath.ClearValue([System.Windows.Controls.Control]::FontSizeProperty)

  # Disable all buttons
  Disable-AllButtons
}

function Invoke-GetMSIInformation {
  param (
    [Parameter(Mandatory = $true)]
    [IO.FileInfo[]]$MSIPath
  )

  # Reset the form
  Invoke-FormReset

  # Get the File Hash Information for any file type
  $HashInfo = Get-FileHashInformation -Path $MSIPath

  # Check if the file is an MSI file
  $IsMSI = ([System.IO.Path]::GetExtension($MSIPath[0])) -eq ".msi"

  if ($IsMSI) {
    # Get the MSI file properties
    $FileMSIInfo = Get-MsiProperties -Path $MSIPath

    # Populate the textboxes with the MSI properties and hash information
    Set-TextboxInformation -MSIPropertiesInfo $FileMSIInfo -FileHashInfo $HashInfo

    # Extract and display the Icons
    $IconObjects = Get-MsiIcon -Path $MSIPath
    if ($null -ne $IconObjects) {
      Set-IconImage -IconObjects $IconObjects
    }

    # Enable the Copy buttons
    Enable-AllButtons -Exclude "Icon"
  }
  else {
    # Populate only the hash textboxes for non-MSI files
    Set-TextboxInformation -FileHashInfo $HashInfo

    # Enable only the Hash and FilePath Copy buttons
    foreach ($ButtonName in @("btn_MD5_Copy", "btn_SHA1_Copy", "btn_SHA256_Copy", "btn_Digest_Copy", "btn_D256_Copy", "btn_FilePath_Copy")) {
      (Get-Variable -Name $ButtonName -ValueOnly -ErrorAction SilentlyContinue).IsEnabled = $true
    }
  }

  # Clear the listbox and add the filename
  $lsbox_FilePath.Items.Clear()
  $lsbox_FilePath.Items.Add($MSIPath[0])

  # Remove lock on current file
  [System.GC]::Collect()
  [System.GC]::WaitForPendingFinalizers()
}

function Invoke-LaunchAsPwsh {
  # Are we running as PowerShell 7.4 or higher
  if ($Script:ScriptPSVersion -ge [Version]"7.4") {
    Write-Host "Running PowerShell 7.4 or higher"
  }
  else {
    # Check that PowerShell is installed
    if ($Script:PowerShellPath) {
      # Check that it is version 7.4 or higher
      if ($Script:PowerShellPath.Version -lt [Version]"7.4") {
        Write-Host "Installed PowerShell (pwsh.exe) version [$($Script:PowerShellPath.Version)] is lower than 7.4. Continuing with existing PowerShell version [$($Script:ScriptPSVersion)]..."
      }
      else {
        # Start PowerShell and run the script
        Write-Host "Relaunching script in PowerShell (pwsh.exe)..."
        if ($PSCommandPath -ne "") {
          Start-Process -FilePath $Script:PowerShellPath -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Minimized -File `"$PSCommandPath`" -FilePath `"$FilePath`""
        }
        else {
          Start-Process -FilePath $Script:PowerShellPath -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Minimized -Command `"Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/GetMSIInformation.ps1')`""
        }
        Exit
      }
    }
    else {
      Write-Host "PowerShell (pwsh.exe) is not installed on this system."
    }
  }
}
#endregion Functions

#############################################
################# Main Script ################
#############################################

# Relaunch the script in PowerShell 7.4 or higher if available.
Invoke-LaunchAsPwsh

# Load Assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Build the GUI
[xml]$XAMLformMSIProperties = @"
<Window
  xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
  xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
  Name="form1"
  Width="920"
  Height="620"
  ResizeMode="NoResize"
  WindowStyle="None"
  AllowsTransparency="True"
  Background="Transparent"
  Title="MSI Properties"
  FontFamily="Segoe UI"
  FontSize="14">

  <Window.Resources>
    <!-- Color tokens (michaeltheadmin.com palette) -->
    <SolidColorBrush x:Key="Bg"
        Color="#292524"/>
    <SolidColorBrush x:Key="Surface"
        Color="#1C1917"/>
    <SolidColorBrush x:Key="Surface2"
        Color="#44403C"/>
    <SolidColorBrush x:Key="Border"
        Color="#3A3633"/>
    <SolidColorBrush x:Key="BorderMuted"
        Color="#57534E"/>
    <SolidColorBrush x:Key="Text"
        Color="#F5F5F4"/>
    <SolidColorBrush x:Key="TextMuted"
        Color="#A8A29E"/>
    <SolidColorBrush x:Key="Accent"
        Color="#FB923C"/>
    <SolidColorBrush x:Key="AccentHover"
        Color="#F97316"/>
    <SolidColorBrush x:Key="AccentText"
        Color="#1C1917"/>
    <SolidColorBrush x:Key="Danger"
        Color="#EF4444"/>

    <!-- Menu item templates -->
    <ControlTemplate x:Key="MenuTopLevelHeader"
        TargetType="MenuItem">
      <Grid>
        <Border x:Name="Bd"
            Background="{TemplateBinding Background}"
            BorderBrush="{StaticResource Accent}"
            BorderThickness="1"
            CornerRadius="6"
            Margin="2,0"
            Padding="10,4">
          <ContentPresenter ContentSource="Header"
              VerticalAlignment="Center"/>
        </Border>
        <Popup x:Name="PART_Popup"
            Placement="Bottom"
            IsOpen="{TemplateBinding IsSubmenuOpen}"
            AllowsTransparency="True"
            Focusable="False"
            PopupAnimation="Fade">
          <Border Background="{StaticResource Surface}"
              BorderBrush="{StaticResource Border}"
              BorderThickness="1"
              CornerRadius="8"
              Padding="4"
              Margin="0,4,10,10">
            <Border.Effect>
              <DropShadowEffect BlurRadius="14"
                  ShadowDepth="2"
                  Opacity="0.5"
                  Color="#000000"/>
            </Border.Effect>
            <StackPanel IsItemsHost="True"
                KeyboardNavigation.DirectionalNavigation="Cycle"/>
          </Border>
        </Popup>
      </Grid>
      <ControlTemplate.Triggers>
        <Trigger Property="IsHighlighted"
            Value="True">
          <Setter TargetName="Bd"
              Property="Background"
              Value="{StaticResource Accent}"/>
          <Setter Property="Foreground"
              Value="{StaticResource AccentText}"/>
        </Trigger>
        <Trigger Property="IsSubmenuOpen"
            Value="True">
          <Setter TargetName="Bd"
              Property="Background"
              Value="{StaticResource Accent}"/>
          <Setter Property="Foreground"
              Value="{StaticResource AccentText}"/>
        </Trigger>
      </ControlTemplate.Triggers>
    </ControlTemplate>

    <ControlTemplate x:Key="MenuTopLevelItem"
        TargetType="MenuItem">
      <Border x:Name="Bd"
          Background="{TemplateBinding Background}"
          BorderBrush="{StaticResource Accent}"
          BorderThickness="1"
          CornerRadius="6"
          Margin="2,0"
          Padding="10,4">
        <ContentPresenter ContentSource="Header"
            VerticalAlignment="Center"/>
      </Border>
      <ControlTemplate.Triggers>
        <Trigger Property="IsHighlighted"
            Value="True">
          <Setter TargetName="Bd"
              Property="Background"
              Value="{StaticResource Accent}"/>
          <Setter Property="Foreground"
              Value="{StaticResource AccentText}"/>
        </Trigger>
      </ControlTemplate.Triggers>
    </ControlTemplate>

    <ControlTemplate x:Key="MenuSubmenuItem"
        TargetType="MenuItem">
      <Border x:Name="Bd"
          Background="{TemplateBinding Background}"
          CornerRadius="6"
          Padding="12,6"
          Margin="1">
        <ContentPresenter ContentSource="Header"
            VerticalAlignment="Center"/>
      </Border>
      <ControlTemplate.Triggers>
        <Trigger Property="IsHighlighted"
            Value="True">
          <Setter TargetName="Bd"
              Property="Background"
              Value="{StaticResource Accent}"/>
          <Setter Property="Foreground"
              Value="{StaticResource AccentText}"/>
        </Trigger>
        <Trigger Property="IsEnabled"
            Value="False">
          <Setter Property="Foreground"
              Value="{StaticResource TextMuted}"/>
        </Trigger>
      </ControlTemplate.Triggers>
    </ControlTemplate>

    <ControlTemplate x:Key="MenuSubmenuHeader"
        TargetType="MenuItem">
      <Grid>
        <Border x:Name="Bd"
            Background="{TemplateBinding Background}"
            CornerRadius="6"
            Padding="12,6"
            Margin="1">
          <Grid>
            <Grid.ColumnDefinitions>
              <ColumnDefinition Width="*"/>
              <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>
            <ContentPresenter Grid.Column="0"
                ContentSource="Header"
                VerticalAlignment="Center"/>
            <TextBlock Grid.Column="1"
                Text="&#xE76C;"
                FontFamily="Segoe MDL2 Assets"
                FontSize="10"
                VerticalAlignment="Center"
                Margin="16,0,0,0"/>
          </Grid>
        </Border>
        <Popup Placement="Right"
            IsOpen="{TemplateBinding IsSubmenuOpen}"
            AllowsTransparency="True"
            Focusable="False"
            PopupAnimation="Fade">
          <Border Background="{StaticResource Surface}"
              BorderBrush="{StaticResource Border}"
              BorderThickness="1"
              CornerRadius="8"
              Padding="4"
              Margin="0,0,10,10">
            <Border.Effect>
              <DropShadowEffect BlurRadius="14"
                  ShadowDepth="2"
                  Opacity="0.5"
                  Color="#000000"/>
            </Border.Effect>
            <StackPanel IsItemsHost="True"
                KeyboardNavigation.DirectionalNavigation="Cycle"/>
          </Border>
        </Popup>
      </Grid>
      <ControlTemplate.Triggers>
        <Trigger Property="IsHighlighted"
            Value="True">
          <Setter TargetName="Bd"
              Property="Background"
              Value="{StaticResource Accent}"/>
          <Setter Property="Foreground"
              Value="{StaticResource AccentText}"/>
        </Trigger>
      </ControlTemplate.Triggers>
    </ControlTemplate>

    <!-- Menu -->
    <Style TargetType="Menu">
      <Setter Property="Background"
          Value="Transparent"/>
      <Setter Property="Foreground"
          Value="{StaticResource Text}"/>
      <Setter Property="Padding"
          Value="6,2"/>
      <Setter Property="BorderThickness"
          Value="0"/>
    </Style>
    <Style TargetType="MenuItem">
      <Setter Property="Foreground"
          Value="{StaticResource Text}"/>
      <Setter Property="Background"
          Value="Transparent"/>
      <Style.Triggers>
        <Trigger Property="Role"
            Value="TopLevelHeader">
          <Setter Property="Template"
              Value="{StaticResource MenuTopLevelHeader}"/>
        </Trigger>
        <Trigger Property="Role"
            Value="TopLevelItem">
          <Setter Property="Template"
              Value="{StaticResource MenuTopLevelItem}"/>
        </Trigger>
        <Trigger Property="Role"
            Value="SubmenuHeader">
          <Setter Property="Template"
              Value="{StaticResource MenuSubmenuHeader}"/>
        </Trigger>
        <Trigger Property="Role"
            Value="SubmenuItem">
          <Setter Property="Template"
              Value="{StaticResource MenuSubmenuItem}"/>
        </Trigger>
      </Style.Triggers>
    </Style>
    <Style TargetType="Separator">
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Separator">
            <Border Height="1"
                Background="{StaticResource Border}"
                Margin="8,4"/>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Labels -->
    <Style x:Key="ThemedLabel"
        TargetType="Label">
      <Setter Property="Foreground"
          Value="{StaticResource TextMuted}"/>
      <Setter Property="FontWeight"
          Value="SemiBold"/>
      <Setter Property="Margin"
          Value="2.5"/>
      <Setter Property="Padding"
          Value="4,0,8,0"/>
      <Setter Property="VerticalAlignment"
          Value="Stretch"/>
      <Setter Property="VerticalContentAlignment"
          Value="Center"/>
      <Setter Property="HorizontalContentAlignment"
          Value="Right"/>
    </Style>
    <Style TargetType="Label"
        BasedOn="{StaticResource ThemedLabel}"/>

    <!-- Read-only info textboxes -->
    <Style x:Key="ThemedTextBox"
        TargetType="TextBox">
      <Setter Property="Foreground"
          Value="{StaticResource Text}"/>
      <Setter Property="Background"
          Value="{StaticResource Surface}"/>
      <Setter Property="BorderBrush"
          Value="{StaticResource Border}"/>
      <Setter Property="BorderThickness"
          Value="1"/>
      <Setter Property="Margin"
          Value="2.5"/>
      <Setter Property="Padding"
          Value="8,0"/>
      <Setter Property="VerticalContentAlignment"
          Value="Center"/>
      <Setter Property="IsReadOnly"
          Value="True"/>
      <Setter Property="CaretBrush"
          Value="{StaticResource Accent}"/>
      <Setter Property="SelectionBrush"
          Value="{StaticResource Accent}"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="TextBox">
            <Border x:Name="Bd"
                Background="{TemplateBinding Background}"
                BorderBrush="{TemplateBinding BorderBrush}"
                BorderThickness="{TemplateBinding BorderThickness}"
                CornerRadius="6">
              <ScrollViewer x:Name="PART_ContentHost"
                  Margin="{TemplateBinding Padding}"
                  VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="BorderBrush"
                    Value="{StaticResource BorderMuted}"/>
              </Trigger>
              <Trigger Property="IsKeyboardFocused"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="BorderBrush"
                    Value="{StaticResource Accent}"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="TextBox"
        BasedOn="{StaticResource ThemedTextBox}"/>

    <!-- Buttons -->
    <Style x:Key="ThemedButton"
        TargetType="Button">
      <Setter Property="Foreground"
          Value="{StaticResource Text}"/>
      <Setter Property="Background"
          Value="{StaticResource Surface2}"/>
      <Setter Property="BorderBrush"
          Value="{StaticResource BorderMuted}"/>
      <Setter Property="BorderThickness"
          Value="1"/>
      <Setter Property="Margin"
          Value="2.5"/>
      <Setter Property="Padding"
          Value="10,4"/>
      <Setter Property="FontWeight"
          Value="SemiBold"/>
      <Setter Property="Cursor"
          Value="Hand"/>
      <Setter Property="HorizontalContentAlignment"
          Value="Center"/>
      <Setter Property="VerticalContentAlignment"
          Value="Center"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd"
                Background="{TemplateBinding Background}"
                BorderBrush="{TemplateBinding BorderBrush}"
                BorderThickness="{TemplateBinding BorderThickness}"
                CornerRadius="6">
              <ContentPresenter HorizontalAlignment="Center"
                  VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="Background"
                    Value="{StaticResource Accent}"/>
                <Setter TargetName="Bd"
                    Property="BorderBrush"
                    Value="{StaticResource Accent}"/>
                <Setter Property="Foreground"
                    Value="{StaticResource AccentText}"/>
              </Trigger>
              <Trigger Property="IsPressed"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="Background"
                    Value="{StaticResource AccentHover}"/>
                <Setter TargetName="Bd"
                    Property="BorderBrush"
                    Value="{StaticResource AccentHover}"/>
                <Setter Property="Foreground"
                    Value="{StaticResource AccentText}"/>
              </Trigger>
              <Trigger Property="IsEnabled"
                  Value="False">
                <Setter TargetName="Bd"
                    Property="Background"
                    Value="{StaticResource Surface}"/>
                <Setter TargetName="Bd"
                    Property="BorderBrush"
                    Value="{StaticResource Border}"/>
                <Setter TargetName="Bd"
                    Property="Opacity"
                    Value="0.6"/>
                <Setter Property="Foreground"
                    Value="{StaticResource TextMuted}"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="Button"
        BasedOn="{StaticResource ThemedButton}"/>

    <!-- Icon-only copy button -->
    <Style x:Key="CopyButton"
        TargetType="Button"
        BasedOn="{StaticResource ThemedButton}">
      <Setter Property="FontFamily"
          Value="Segoe MDL2 Assets"/>
      <Setter Property="FontSize"
          Value="14"/>
      <Setter Property="HorizontalAlignment"
          Value="Stretch"/>
      <Setter Property="Padding"
          Value="0"/>
    </Style>

    <!-- Muted section label -->
    <Style x:Key="SectionHeader"
        TargetType="TextBlock">
      <Setter Property="Foreground"
          Value="{StaticResource Accent}"/>
      <Setter Property="FontSize"
          Value="10"/>
      <Setter Property="FontWeight"
          Value="SemiBold"/>
      <Setter Property="VerticalAlignment"
          Value="Center"/>
      <Setter Property="Margin"
          Value="5,0,0,0"/>
    </Style>

    <!-- Drag and drop list -->
    <Style x:Key="ThemedListBox"
        TargetType="ListBox">
      <Setter Property="Background"
          Value="{StaticResource Surface}"/>
      <Setter Property="Foreground"
          Value="{StaticResource Text}"/>
      <Setter Property="BorderBrush"
          Value="{StaticResource Border}"/>
      <Setter Property="BorderThickness"
          Value="1"/>
      <Setter Property="Margin"
          Value="2.5"/>
      <Setter Property="HorizontalContentAlignment"
          Value="Center"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ListBox">
            <Border Background="{TemplateBinding Background}"
                BorderBrush="{TemplateBinding BorderBrush}"
                BorderThickness="{TemplateBinding BorderThickness}"
                CornerRadius="6">
              <ScrollViewer Focusable="False"
                  Padding="2"
                  VerticalScrollBarVisibility="Hidden"
                  HorizontalScrollBarVisibility="Disabled">
                <ItemsPresenter/>
              </ScrollViewer>
            </Border>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="ListBox"
        BasedOn="{StaticResource ThemedListBox}"/>
    <Style x:Key="ThemedListBoxItem"
        TargetType="ListBoxItem">
      <Setter Property="Background"
          Value="Transparent"/>
      <Setter Property="Padding"
          Value="8,6"/>
      <Setter Property="HorizontalContentAlignment"
          Value="Center"/>
      <Setter Property="VerticalContentAlignment"
          Value="Center"/>
      <Setter Property="Height"
          Value="{Binding ElementName=lsbox_FilePath, Path=ActualHeight}"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ListBoxItem">
            <Border x:Name="Bd"
                Background="{TemplateBinding Background}"
                CornerRadius="4"
                Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}"
                  VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="Background"
                    Value="{StaticResource Surface2}"/>
              </Trigger>
              <Trigger Property="IsSelected"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="Background"
                    Value="{StaticResource Surface2}"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style TargetType="ListBoxItem"
        BasedOn="{StaticResource ThemedListBoxItem}"/>

    <!-- Tooltip -->
    <Style TargetType="ToolTip">
      <Setter Property="Background"
          Value="{StaticResource Surface}"/>
      <Setter Property="Foreground"
          Value="{StaticResource Text}"/>
      <Setter Property="BorderBrush"
          Value="{StaticResource Border}"/>
      <Setter Property="BorderThickness"
          Value="1"/>
      <Setter Property="Padding"
          Value="8,4"/>
    </Style>

    <!-- Title bar buttons -->
    <Style x:Key="TitleBarButton"
        TargetType="Button">
      <Setter Property="Foreground"
          Value="{StaticResource TextMuted}"/>
      <Setter Property="Background"
          Value="Transparent"/>
      <Setter Property="BorderThickness"
          Value="0"/>
      <Setter Property="Width"
          Value="46"/>
      <Setter Property="FontFamily"
          Value="Segoe MDL2 Assets"/>
      <Setter Property="FontSize"
          Value="10"/>
      <Setter Property="Cursor"
          Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd"
                Background="{TemplateBinding Background}">
              <ContentPresenter HorizontalAlignment="Center"
                  VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="Background"
                    Value="{StaticResource Surface2}"/>
                <Setter Property="Foreground"
                    Value="{StaticResource Text}"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="TitleBarCloseButton"
        TargetType="Button">
      <Setter Property="Foreground"
          Value="{StaticResource TextMuted}"/>
      <Setter Property="Background"
          Value="Transparent"/>
      <Setter Property="BorderThickness"
          Value="0"/>
      <Setter Property="Width"
          Value="46"/>
      <Setter Property="FontFamily"
          Value="Segoe MDL2 Assets"/>
      <Setter Property="FontSize"
          Value="10"/>
      <Setter Property="Cursor"
          Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd"
                Background="{TemplateBinding Background}"
                CornerRadius="0,11,0,0">
              <ContentPresenter HorizontalAlignment="Center"
                  VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver"
                  Value="True">
                <Setter TargetName="Bd"
                    Property="Background"
                    Value="{StaticResource Danger}"/>
                <Setter Property="Foreground"
                    Value="#FFFFFF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Border Background="{StaticResource Bg}"
      CornerRadius="12"
      BorderBrush="{StaticResource BorderMuted}"
      BorderThickness="1"
      Margin="0">
    <DockPanel>
      <Border Name="titlebar"
          DockPanel.Dock="Top"
          Background="{StaticResource Surface}"
          CornerRadius="11,11,0,0"
          Height="42">
        <DockPanel LastChildFill="False">
          <Button Name="titlebar_Close"
              DockPanel.Dock="Right"
              Style="{StaticResource TitleBarCloseButton}"
              Content="&#xE8BB;"/>
          <Button Name="titlebar_Minimize"
              DockPanel.Dock="Right"
              Style="{StaticResource TitleBarButton}"
              Content="&#xE921;"/>
          <Image DockPanel.Dock="Left"
              Margin="14,0,0,0"
              Width="20"
              Height="20"
              VerticalAlignment="Center"
              RenderOptions.BitmapScalingMode="HighQuality"
              Source="{Binding Icon, RelativeSource={RelativeSource AncestorType=Window}}"/>
          <StackPanel DockPanel.Dock="Left"
              Orientation="Horizontal"
              VerticalAlignment="Center"
              Margin="10,0,8,0">
            <TextBlock FontSize="15"
                FontWeight="SemiBold"
                Foreground="{StaticResource Text}"
                Text="MSI Properties"
                VerticalAlignment="Center"/>
            <TextBlock Name="txtblk_TitleVersion"
                FontWeight="Normal"
                Foreground="{StaticResource TextMuted}"
                VerticalAlignment="Center"
                Margin="6,0,0,1"/>
          </StackPanel>
          <Menu DockPanel.Dock="Left"
              VerticalAlignment="Center">
            <MenuItem Header="File">
              <MenuItem Name="MenuItem_Open"
                  Header="Open Icon Temp Folder"/>
            </MenuItem>
            <MenuItem Header="Right Click Menu">
              <MenuItem Name="MenuItem_Install"
                  Header="Install"/>
              <MenuItem Name="MenuItem_Uninstall"
                  Header="Uninstall"/>
              <MenuItem Name="MenuItem_Open_RCM"
                  Header="Open Right Click Menu Folder"/>
            </MenuItem>
            <MenuItem Header="About">
              <MenuItem Name="MenuItem_GitHub"
                  Header="GitHub - GetMSIInformation"/>
              <MenuItem Name="MenuItem_About"
                  Header="michaeltheadmin.com"/>
              <MenuItem Name="MenuItem_Version"
                  Header="Version 1.0.0"
                  IsEnabled="False"
                  FontWeight="Normal"/>
            </MenuItem>
          </Menu>
        </DockPanel>
      </Border>
      <Border DockPanel.Dock="Bottom"
          Background="{StaticResource Surface}"
          Height="24"
          CornerRadius="0,0,11,11">
        <TextBlock Name="txtblk_StatusBar"
            VerticalAlignment="Center"
            Foreground="{StaticResource TextMuted}"
            FontSize="12"
            Margin="12,0"
            Text="Created By Michael Escamilla"/>
      </Border>

      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="5"/>
          <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="175"/>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <Grid
          Grid.Row="0"
          Grid.Column="0">
          <Grid.RowDefinitions>
            <RowDefinition Height="175"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="0.5*"/>
            <ColumnDefinition Width="0.5*"/>
          </Grid.ColumnDefinitions>

          <Border
            Grid.Row="0"
            Grid.Column="0"
            Grid.ColumnSpan="2"
            Margin="5,2.5,2.5,2.5"
            CornerRadius="8"
            BorderBrush="{StaticResource Border}"
            BorderThickness="1"
            Background="{StaticResource Surface}">
            <Grid
              Name="grid_Icon">
              <Image
                Grid.Row="0"
                Name="img_Icon"
                Width="64"
                Height="64"
                HorizontalAlignment="Center"
                VerticalAlignment="Center"
                Visibility="Collapsed"/>
              <Label
                Grid.Row="0"
                Name="lbl_NoIcon"
                Content="No Icon"
                HorizontalAlignment="Center"
                VerticalAlignment="Center"
                FontStyle="Italic"
                Foreground="{StaticResource TextMuted}"
                Visibility="Visible"/>
            </Grid>
          </Border>
          <Button
            Grid.Row="1"
            Grid.Column="0"
            Name="btn_IconPrevious"
            Content="&lt;--"
            IsEnabled="False"/>
          <Button
            Grid.Row="1"
            Grid.Column="1"
            Name="btn_IconNext"
            Content="-->"
            IsEnabled="False"/>
        </Grid>

        <Line
          Grid.Row="0"
          Grid.Column="1"
          Margin="2.5,0,0,0"
          X1="0"
          Y1="1"
          X2="0"
          Y2="0"
          Stroke="{StaticResource Border}"
          StrokeThickness="2.5"
          Stretch="Uniform"/>

        <Grid
          Grid.Row="0"
          Grid.Column="2">
          <Grid.RowDefinitions>
            <RowDefinition Height="26"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
          </Grid.RowDefinitions>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="Auto"/>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="60"/>
          </Grid.ColumnDefinitions>

          <TextBlock
            Grid.Row="0"
            Grid.Column="0"
            Grid.ColumnSpan="3"
            Style="{StaticResource SectionHeader}"
            Text="FILE HASHES"/>

          <!-- MD5 -->
          <Label
            Grid.Row="1"
            Grid.Column="0"
            Name="lbl_MD5"
            Content="MD5"/>
          <TextBox
            Grid.Row="1"
            Grid.Column="1"
            Name="txt_MD5"
            xml:space="preserve"/>
        <Button
            Grid.Row="1"
            Grid.Column="2"
            Name="btn_MD5_Copy"
            Style="{StaticResource CopyButton}"
            Content="&#xE8C8;"/>

        <!-- SHA1 -->
        <Label
            Grid.Row="2"
            Grid.Column="0"
            Name="lbl_SHA1"
            Content="SHA1"/>
        <TextBox
            Grid.Row="2"
            Grid.Column="1"
            Name="txt_SHA1"
            xml:space="preserve"/>
        <Button
            Grid.Row="2"
            Grid.Column="2"
            Name="btn_SHA1_Copy"
            Style="{StaticResource CopyButton}"
            Content="&#xE8C8;"/>

        <!-- SHA256 -->
        <Label
            Grid.Row="3"
            Grid.Column="0"
            Name="lbl_SHA256"
            Content="SHA256"/>
        <TextBox
            Grid.Row="3"
            Grid.Column="1"
            Name="txt_SHA256"
            xml:space="preserve"/>
        <Button
            Grid.Row="3"
            Grid.Column="2"
            Name="btn_SHA256_Copy"
            Style="{StaticResource CopyButton}"
            Content="&#xE8C8;"/>

        <!-- Digest-1 -->
        <Label
            Grid.Row="4"
            Grid.Column="0"
            Name="lbl_Digest"
            Content="Digest-1"/>
        <TextBox
            Grid.Row="4"
            Grid.Column="1"
            Name="txt_Digest"
            xml:space="preserve"/>
        <Button
            Grid.Row="4"
            Grid.Column="2"
            Name="btn_Digest_Copy"
            Style="{StaticResource CopyButton}"
            Content="&#xE8C8;"/>

        <!-- Digest-256 -->
        <Label
            Grid.Row="5"
            Grid.Column="0"
            Name="lbl_D256"
            Content="Digest-256"/>
        <TextBox
            Grid.Row="5"
            Grid.Column="1"
            Name="txt_D256"
            xml:space="preserve"/>
        <Button
            Grid.Row="5"
            Grid.Column="2"
            Name="btn_D256_Copy"
            Style="{StaticResource CopyButton}"
            Content="&#xE8C8;"/>
      </Grid>

        <Line
          Grid.Row="1"
          Grid.Column="0"
          Grid.ColumnSpan="3"
          X1="0"
          Y1="0"
          X2="1"
          Y2="0"
          Stroke="{StaticResource Border}"
          StrokeThickness="2"
          Stretch="Uniform"/>

        <Grid
          Grid.Row="2"
          Grid.Column="0"
          Grid.ColumnSpan="3">
          <Grid.RowDefinitions>
            <RowDefinition Height="26"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="36"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="105"/>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="60"/>
          </Grid.ColumnDefinitions>
          <Grid.Resources>
            <Style TargetType="Label"
                BasedOn="{StaticResource ThemedLabel}">
              <Setter Property="Margin"
                      Value="2.5"/>
              <Setter Property="FontSize"
                      Value="12"/>
              <Setter Property="HorizontalAlignment"
                      Value="Stretch"/>
              <Setter Property="HorizontalContentAlignment"
                      Value="Right"/>
              <Setter Property="VerticalAlignment"
                      Value="Stretch"/>
              <Setter Property="VerticalContentAlignment"
                      Value="Center"/>
              <Setter Property="IsEnabled"
                      Value="True"/>
            </Style>
            <Style TargetType="TextBox"
                BasedOn="{StaticResource ThemedTextBox}">
              <Setter Property="Margin"
                      Value="2.5"/>
              <Setter Property="Width"
                      Value="Auto"/>
              <Setter Property="HorizontalAlignment"
                      Value="Stretch"/>
              <Setter Property="VerticalAlignment"
                      Value="Stretch"/>
              <Setter Property="VerticalContentAlignment"
                      Value="Center"/>
              <Setter Property="IsEnabled"
                      Value="True"/>
              <Setter Property="IsReadOnly"
                      Value="True"/>
            </Style>
            <Style TargetType="Button"
                BasedOn="{StaticResource ThemedButton}">
              <Setter Property="Margin"
                      Value="2.5"/>
              <Setter Property="Width"
                      Value="Auto"/>
              <Setter Property="HorizontalAlignment"
                      Value="Stretch"/>
              <Setter Property="VerticalAlignment"
                      Value="Stretch"/>
              <Setter Property="VerticalContentAlignment"
                      Value="Center"/>
              <Setter Property="IsEnabled"
                      Value="False"/>
            </Style>
            <Style TargetType="ListBox"
                BasedOn="{StaticResource ThemedListBox}">
              <Setter Property="Margin"
                      Value="2.5"/>
              <Setter Property="HorizontalAlignment"
                      Value="Stretch"/>
              <Setter Property="HorizontalContentAlignment"
                      Value="Center"/>
              <Setter Property="VerticalAlignment"
                      Value="Stretch"/>
              <Setter Property="VerticalContentAlignment"
                      Value="Center"/>
            </Style>
            <Style TargetType="ListBoxItem"
                BasedOn="{StaticResource ThemedListBoxItem}">
              <Setter Property="HorizontalAlignment"
                      Value="Stretch"/>
              <Setter Property="HorizontalContentAlignment"
                      Value="Center"/>
              <Setter Property="VerticalAlignment"
                      Value="Stretch"/>
              <Setter Property="VerticalContentAlignment"
                      Value="Center"/>
              <Setter Property="Height"
                      Value="{Binding ElementName=lsbox_FilePath, Path=ActualHeight}"/>
            </Style>
          </Grid.Resources>

          <TextBlock
            Grid.Row="0"
            Grid.Column="0"
            Grid.ColumnSpan="3"
            Style="{StaticResource SectionHeader}"
            Text="MSI PROPERTIES"/>

          <!-- Row -->
          <Label
            Grid.Row="1"
            Grid.Column="0"
            Name="lbl_ProductName"
            Content="Product Name"/>
          <TextBox
            Grid.Row="1"
            Grid.Column="1"
            Name="txt_ProductName"/>
          <Button
            Grid.Row="1"
            Grid.Column="2"
            Name="btn_ProductName_Copy"
            FontFamily="Segoe MDL2 Assets"
            FontSize="14"
            Content="&#xE8C8;"/>

          <!-- Row -->
          <Label
            Grid.Row="2"
            Grid.Column="0"
            Name="lbl_Manufacturer"
            Content="Manufacturer"/>
          <TextBox
            Grid.Row="2"
            Grid.Column="1"
            Name="txt_Manufacture"
            xml:space="preserve"/>
        <Button
            Grid.Row="2"
            Grid.Column="2"
            Name="btn_Manufacture_Copy"
            FontFamily="Segoe MDL2 Assets"
            FontSize="14"
            Content="&#xE8C8;"/>

        <!-- Row -->
        <Label
            Grid.Row="3"
            Grid.Column="0"
            Name="lbl_ProductVersion"
            Content="Product Version"/>
        <TextBox
            Grid.Row="3"
            Grid.Column="1"
            Name="txt_ProductVersion"
            xml:space="preserve"/>
        <Button
            Grid.Row="3"
            Grid.Column="2"
            Name="btn_ProductVersion_Copy"
            FontFamily="Segoe MDL2 Assets"
            FontSize="14"
            Content="&#xE8C8;"/>

        <!-- Row -->
        <Label
            Grid.Row="4"
            Grid.Column="0"
            Name="lbl_ProductCode"
            Content="Product Code"/>
        <TextBox
            Grid.Row="4"
            Grid.Column="1"
            Name="txt_ProductCode"
            xml:space="preserve"/>
        <Button
            Grid.Row="4"
            Grid.Column="2"
            Name="btn_ProductCode_Copy"
            FontFamily="Segoe MDL2 Assets"
            FontSize="14"
            Content="&#xE8C8;"/>

        <!-- Row -->
        <Label
            Grid.Row="5"
            Grid.Column="0"
            Name="lbl_CompressedGUID"
            Content="Comp Prod Code"/>
        <TextBox
            Grid.Row="5"
            Grid.Column="1"
            Name="txt_CompressedGUID"
            xml:space="preserve"/>
        <Button
            Grid.Row="5"
            Grid.Column="2"
            Name="btn_CompressedGUID_Copy"
            FontFamily="Segoe MDL2 Assets"
            FontSize="14"
            Content="&#xE8C8;"/>

        <!-- Row -->
        <Label
            Grid.Row="6"
            Grid.Column="0"
            Name="lbl_UpgradeCode"
            Content="Upgrade Code"/>
        <TextBox
            Grid.Row="6"
            Grid.Column="1"
            Name="txt_UpgradeCode"
            xml:space="preserve"/>
        <Button
            Grid.Row="6"
            Grid.Column="2"
            Name="btn_UpgradeCode_Copy"
            FontFamily="Segoe MDL2 Assets"
            FontSize="14"
            Content="&#xE8C8;"/>

        <!-- Row -->
        <Button
            Grid.Row="7"
            Grid.Column="0"
            Name="btn_AllProperties"
            Content="All Properties"
            IsEnabled="False"/>
        <ListBox
            Grid.Row="7"
            Grid.Column="1"
            Name="lsbox_FilePath"
            AllowDrop="True"
            IsEnabled="True"
            TabIndex="0">
          <ListBox.Items>
            <ListBoxItem>
              <StackPanel Orientation="Horizontal"
                    HorizontalAlignment="Center">
                <TextBlock Text="&#xE896;"
                      FontFamily="Segoe MDL2 Assets"
                      FontSize="18"
                      VerticalAlignment="Center"
                      Foreground="{StaticResource TextMuted}"
                      Margin="0,0,8,0"/>
                <TextBlock VerticalAlignment="Center"
                      Foreground="{StaticResource TextMuted}"
                      FontStyle="Italic"
                      Text="Drop a file here · hashes for any file, properties for *.msi"/>
              </StackPanel>
            </ListBoxItem>
          </ListBox.Items>
        </ListBox>
        <Button
            Grid.Row="7"
            Grid.Column="2"
            Name="btn_FilePath_Copy"
            FontFamily="Segoe MDL2 Assets"
            FontSize="14"
            Content="&#xE8C8;"/>
      </Grid>
      </Grid>
    </DockPanel>
  </Border>
</Window>
"@

# Create a new XML node reader for reading the XAML content
$readerformMSIProperties = New-Object System.Xml.XmlNodeReader $XAMLformMSIProperties

# Load the XAML content into a WPF window object using the XAML reader
[System.Windows.Window]$formMSIProperties = [Windows.Markup.XamlReader]::Load($readerformMSIProperties)

# Create Variables for all the controls in the XAML form
$XAMLformMSIProperties.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $formMSIProperties.FindName($_.Name) -Scope Script }

# Disable all action buttons until a file is loaded
Disable-AllButtons

#############################################
############## Event Handlers ###############
#############################################
#region Event Handlers

#### Form Load #####
$formMSIProperties.Add_Loaded({
    try {
      # Covert the AppIcon byte array to an Icon and set as the form icon
      $WindowIconBitmap = [System.Windows.Media.Imaging.BitmapImage]::new()
      $WindowIconBitmap.BeginInit()
      $WindowIconBitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($Script:WindowIconBase64)
      $WindowIconBitmap.EndInit()
      $WindowIconBitmap.Freeze()
      $formMSIProperties.Icon = $WindowIconBitmap
    }
    catch {
      # Write the error to the host but continue on. It's an icon, who cares.
      Write-Host "Error setting form icon: $_"
    }

    # Check if the script is running as an administrator
    if (($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {

      Write-Warning "The script is running as an administrator."
      Write-Warning "Drag and Drog will not work while running as an administrator."

      # Clear the listbox
      $lsbox_FilePath.Items.Clear()

      # Add a warning message to the listbox
      $lsbox_FilePath.Items.Add("WARNING: Running as Administrator | Drag and Drop will not work.")

      # Make the warning message bold and yellow
      $lsbox_FilePath.Background = [System.Windows.Media.Brushes]::Yellow
      $lsbox_FilePath.FontWeight = 'Bold'
    }

    # Update Version Information
    $formMSIProperties.Title = "MSI Properties - Version $($ScriptVersion)"
    $MenuItem_Version.Header = "Version $($ScriptVersion)"
    $txtblk_TitleVersion.Text = " $($ScriptVersion)"

    # Check if the FilePath parameter is provided to script
    if ($FilePath) {
      # Check if $FilePath is locked
      if (Test-FileLock -Path $FilePath) {
        Write-Warning "The file is locked: [$FilePath]"

        # Clear the listbox
        $lsbox_FilePath.Items.Clear()

        # Add an error message to the listbox
        $lsbox_FilePath.Items.Add("ERROR: The file is locked:`n[$FilePath]")
        
        # Make the Error message bold, red and yellow
        $lsbox_FilePath.Background = [System.Windows.Media.Brushes]::Red
        $lsbox_FilePath.Foreground = [System.Windows.Media.Brushes]::Yellow
        $lsbox_FilePath.FontWeight = 'Bold'
        $lsbox_FilePath.FontSize = 16
      }
      else {
        Write-Host "FilePath passed: [$FilePath]"

        # Show the UI
        $lsbox_FilePath.Items.Clear()
        $lsbox_FilePath.Items.Add("Loading: [$FilePath]")

        # Process the File
        $formMSIProperties.Dispatcher.InvokeAsync({
            Invoke-GetMSIInformation -MSIPath $FilePath
          }, [System.Windows.Threading.DispatcherPriority]::Background) | Out-Null
      }
    }
  })

#### Listbox Drag and Drop ####
$lsbox_FilePath.Add_Drop({
    $Script:filename = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    Write-Host "File Dropped: [$filename]"
    if ($filename) {
      # Reset the form
      Invoke-FormReset

      # Check if $FilePath is locked
      if (Test-FileLock -Path "$($filename)") {
        Write-Warning "The file is locked: [$filename]"
  
        # Clear the listbox
        $lsbox_FilePath.Items.Clear()
  
        # Add an error message to the listbox
        $lsbox_FilePath.Items.Add("ERROR: The file is locked:`n[$filename]")
          
        # Make the Error message bold, red and yellow
        $lsbox_FilePath.Background = [System.Windows.Media.Brushes]::Red
        $lsbox_FilePath.Foreground = [System.Windows.Media.Brushes]::Yellow
        $lsbox_FilePath.FontWeight = 'Bold'
        $lsbox_FilePath.FontSize = 16
      }
      else {
        # Reset listbox
        $lsbox_FilePath.Items.Clear()
        $lsbox_FilePath.Items.Add("Loading: [$filename]")

        # Process the File
        $formMSIProperties.Dispatcher.InvokeAsync({
            Invoke-GetMSIInformation -MSIPath $Script:filename
          }, [System.Windows.Threading.DispatcherPriority]::Background) | Out-Null
      }
    }
  })

$lsbox_FilePath.Add_DragOver({
    # Check if the dragged data contains file drop data
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
      # Allow any file type to be dropped
      $_.Effects = [System.Windows.DragDropEffects]::Copy
      $_.Handled = $true
    }
  })

$btn_IconNext.add_Click({
    Set-IconImageNavigation -IconObjects $Script:IconImageControlsList -Next
  })

$btn_IconPrevious.add_Click({
    Set-IconImageNavigation -IconObjects $Script:IconImageControlsList -Previous
  })

#### Menu Items ####
$MenuItem_Open.add_Click({
    # Open the Icon Temp Folder
    if (-not (Test-Path $Script:IconTempFolderPath)) {
      New-Item -ItemType Directory -Path $Script:IconTempFolderPath -ErrorAction SilentlyContinue
    }
    Invoke-Item -Path $Script:IconTempFolderPath
  })

$MenuItem_Install.add_Click({
    Write-Host "Menu Item Install Clicked"
    # Set Script Name
    $SaveAsScriptName = $ScriptName

    # Create a new directory in the LOCALAPPDATA folder
    Write-Host "Creating Folder:    [$($Script:RightClickMenuFolderPath)]"
    $DestinationFolderPath = "$($Script:RightClickMenuFolderPath)"
    if (-not (Test-Path $DestinationFolderPath)) {
      $DestinationFolder = New-Item -ItemType Directory -Path $DestinationFolderPath -ErrorAction SilentlyContinue
    }
    else {
      $DestinationFolder = Get-Item -Path $DestinationFolderPath
    }

    # Create an ico file from $Script:WindowIconBase64
    $IconFilePath = "$($DestinationFolder.FullName)\GetMSIInformation.ico"

    # Delete existing Icon file if it exists
    Remove-Item $IconFilePath -Force -ErrorAction SilentlyContinue | Out-Null

    Write-Host "Creating Icon file: [$IconFilePath]"
    $IconByteArray = [System.Convert]::FromBase64String($Script:WindowIconBase64)
    [System.IO.File]::WriteAllBytes($IconFilePath, $IconByteArray)

    # Check if the script is being Invoked from the Internet
    if ($PSCommandPath -ne "") {
      # Copy the script to the new directory
      Write-Host "Creating Script:    [$($DestinationFolder.FullName)\$($SaveAsScriptName)]"
      Copy-Item "$PSScriptRoot\$([System.IO.Path]::GetFileName($PSCommandPath))" -Destination "$($DestinationFolder.FullName)\$($SaveAsScriptName)" -ErrorAction SilentlyContinue
    }
    else {
      Write-Host "PSCommandPath is not available."
      # Script URL
      $ScriptURL = "https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/GetMSIInformation.ps1"
      Write-Host "Downloading script: [$ScriptURL]"
      try {
        Invoke-WebRequest -Uri $ScriptURL -OutFile "$($DestinationFolder.FullName)\$($SaveAsScriptName)" -ErrorAction Stop
        Write-Host "Script saved:       [$($DestinationFolder.FullName)\$($SaveAsScriptName)]"
      }
      catch {
        Write-Host "Failed to download the script: $_"
      }
    }

    # Reg2CI (c) 2020 by Roger Zander
    # https://github.com/asjimene/GetMSIInfo/blob/master/GetMSIInfo.ps1

    # Check if the registry path for .msi file associations exists, if not, create it.
    if ((Test-Path -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi") -ne $true) {
      New-Item "HKCU:\Software\Classes\SystemFileAssociations\.msi" -Force -ErrorAction SilentlyContinue 
    }

    # Check if the 'shell' subkey exists under the .msi file associations, if not, create it.
    if ((Test-Path -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell") -ne $true) {
      New-Item "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell" -Force -ErrorAction SilentlyContinue 
    }

    # Check if the 'Get MSI Information' subkey exists under 'shell', if not, create it.
    if ((Test-Path -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName") -ne $true) {
      New-Item "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName" -Force -ErrorAction SilentlyContinue 
    }

    # Set the 'icon' value under 'Get MSI Information'
    try {
      New-ItemProperty -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName" -Name 'icon' -Value $IconFilePath -PropertyType String -Force -ErrorAction SilentlyContinue
    }
    catch {
      if ($Script:PowerShellPath) {
        New-ItemProperty -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName" -Name 'icon' -Value $Script:PowerShellPath.Path -PropertyType String -Force -ErrorAction SilentlyContinue
      }
      else {
        New-ItemProperty -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName" -Name 'icon' -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force -ErrorAction SilentlyContinue
      }
    }
   
    # Check if the 'command' subkey exists under 'Get MSI Information', if not, create it.
    if ((Test-Path -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName\command") -ne $true) {
      New-Item "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName\command" -Force -ErrorAction SilentlyContinue 
    }

    # Set the default value of the 'Get MSI Information' key to "Get MSI Information".
    New-ItemProperty -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName" -Name '(default)' -Value "$RightClickMenuName" -PropertyType String -Force -ea SilentlyContinue;

    # Prefer pwsh 7.4+ so the menu launches directly and skips the slow relaunch.
    # Fall back to Windows PowerShell (always present) when pwsh isn't installed.
    if ($Script:PowerShellPath -and $Script:PowerShellPath.Version -ge [Version]"7.4") {
      $CommandExe = $Script:PowerShellPath.Path
    }
    else {
      $CommandExe = "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe"
    }

    # Set the default value of the 'command' key to execute a PowerShell script with the .msi file as an argument.
    New-ItemProperty -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName\command" -Name '(default)' -Value "`"$CommandExe`" -NoProfile -ExecutionPolicy Bypass -WindowStyle Minimized -Command `"$($DestinationFolder.FullName)\$($SaveAsScriptName)`" -FilePath '%1'" -PropertyType String -Force -ErrorAction SilentlyContinue;
    Write-Host "Registry Modified:  [HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$($RightClickMenuName)]"
    Write-Host "Installation Complete"
  })

$MenuItem_Uninstall.add_Click({
    Write-Host "Menu Item Uninstall Clicked"

    # Remove the script folder from the LOCALAPPDATA folder
    Remove-item "$env:LOCALAPPDATA\GetMSIInformation" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Deleted Folder:   [$env:LOCALAPPDATA\GetMSIInformation]"

    # Remove the 'Get MSI Information' registry key if it exists
    if ((Test-Path -LiteralPath "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName") -eq $true) { 
      Remove-Item "HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$RightClickMenuName" -force -Recurse -ea SilentlyContinue 
    }
    Write-Host "Deleted Registry: [HKCU:\Software\Classes\SystemFileAssociations\.msi\shell\$($RightClickMenuName)]"
    Write-Host "Uninstallation Complete"
  })

$MenuItem_Open_RCM.add_Click({
    # Open the Right Click Menu Folder
    $RightClickMenuFolderPath = "$env:LOCALAPPDATA\GetMSIInformation"
    if (-not (Test-Path $RightClickMenuFolderPath)) {
      New-Item -ItemType Directory -Path $RightClickMenuFolderPath -ErrorAction SilentlyContinue
    }
    Invoke-Item -Path $RightClickMenuFolderPath
  })

$MenuItem_GitHub.add_Click({
    # Open Github Project Page
    Start-Process "https://github.com/MichaelEscamilla/GetMSIInformation"
  })

$MenuItem_About.add_Click({
    # Open Blog
    Start-Process "https://michaeltheadmin.com"
  })

#### Title Bar Handlers ####
$titlebar.add_MouseLeftButtonDown({
    try { $formMSIProperties.DragMove() } catch { }
  })

$titlebar_Minimize.add_Click({
    $formMSIProperties.WindowState = [System.Windows.WindowState]::Minimized
  })

$titlebar_Close.add_Click({
    $formMSIProperties.Close()
  })

#### Button Handlers ####
$btn_AllProperties.add_Click({
    $SelectedProperty = Get-MsiProperties -Path $lsbox_FilePath.Items[0] | Out-GridView -Title "MSI Database Properties for $($lsbox_FilePath.Items[0])" -OutputMode Single
    $SelectedProperty.Value | Set-Clipboard
  })

$Button_Copy_Handler = {
  # Get the button name
  $ButtonName = $_.Source.Name
  # Get the property name from the button name by parsing between the underscores
  $PropertyName = [regex]::Match($ButtonName, "_(.*?)_").Groups[1].Value
  # Get the variable for the textbox with the same name as the property name
  $TextboxVariable = Get-Variable -Name "txt_$($propertyName)" -ValueOnly -ErrorAction SilentlyContinue
  if ($TextboxVariable) {
    Write-Host "Textbox [$($TextboxVariable.Name)] Value Copied to Clipboard : [$($TextboxVariable.Text)]"
    # Copy the text from the textbox with the same name as the property name
    [System.Windows.Forms.Clipboard]::SetText($TextboxVariable.Text)
  }
  else {
    # Try getting a Listbox variable with the same name as the property name
    $ListboxVariable = Get-Variable -Name "lsbox_$($propertyName)" -ValueOnly -ErrorAction SilentlyContinue
    if ($ListboxVariable) {
      # Check if the item in the listbox contains spaces
      if ($lsbox_FilePath.Items[0] -match "\s") {
        # Copy the item in the listbox to the clipboard with quotes
        [System.Windows.Forms.Clipboard]::SetText("`"$($lsbox_FilePath.Items[0])`"")
        Write-Host "Copied to Clipboard: [`"$($lsbox_FilePath.Items[0])`"]"
      }
      else {
        # Copy the item in the listbox to the clipboard without quotes
        [System.Windows.Forms.Clipboard]::SetText($lsbox_FilePath.Items[0])
        Write-Host "Copied to Clipboard: [$($lsbox_FilePath.Items[0])]"
      }
    }
  }
}

$Button_ExportToPNG_Handler = {
  # Get the Icon Control
  $CurrentIconControl = ($Script:IconImageControlsList | Where-Object { $_.Index -eq $Script:CurrentIconIndex })
    
  # Create a SaveFileDialog to get the export path
  $SaveFileDialog = New-Object Microsoft.Win32.SaveFileDialog
  $SaveFileDialog.Filter = "PNG Image (*.png)|*.png|ICO File (*.ico)|*.ico|All Files (*.*)|*.*"
  $SaveFileDialog.Title = "Export Icon"
  $SaveFileDialog.FileName = "$($CurrentIconControl.IconName)"

  if ($SaveFileDialog.ShowDialog()) {
    $SourcePath = $CurrentIconControl.IconBitmapPath
    Copy-Item -Path $SourcePath -Destination $SaveFileDialog.FileName -Force
    Write-Host "Icon exported to: $($SaveFileDialog.FileName)"
  }
}

# Get all button variables that contain the word "Copy"
$Buttons = Get-Variable -Name "*Copy" -ValueOnly -ErrorAction SilentlyContinue
foreach ($Button in $Buttons) {
  # Add a click event handler to the button
  $Button.add_Click($Button_Copy_Handler)
}

#endregion Event Handlers

# Set the PowerShell Window Title
$Host.UI.RawUI.WindowTitle = "MSI Properties"

#Show the WPF Window
$formMSIProperties.WindowStartupLocation = "CenterScreen"
$formMSIProperties.ShowDialog() | Out-Null
