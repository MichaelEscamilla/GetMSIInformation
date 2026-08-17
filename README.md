# GetMSIInformation
Drag and Drop Application to view key MSI Information and copy the values to the Clipboard<br>
 ![FirstLoad](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_FirstLoad.png)

## Example after loading an MSI
 ![ExampleLoad](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_Example00.png)

## Quick Access
Quickly access the app by invoking the URL [msiapp.michaeltheadmin.com](https://msiapp.michaeltheadmin.com)

### Invoke-Expression
```powershell
iex (irm msiapp.michaeltheadmin.com)
```
 ![Invoke MSI Application](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_Example_Run.png)

## Check for Updates
When the app launches, it quietly checks for a newer version in the background, so it never slows down or freezes while you use it.

If an update is found, you'll see an **Update Available** item appear in the menu.<br>
![Update Available](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_Update_Available.png)

You can also check for updates anytime from the **About** menu.<br>
![Manual Update Check](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_Update_Check_Manual.png)

Updates are based on the [Releases](https://github.com/MichaelEscamilla/GetMSIInformation/releases) published on GitHub.

## Icon Extraction
If the MSI contains an icon, it will be extracted and displayed<br>
![Icon Display](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_IconDisplay_Single.png)

If multiple icons are found, you can view each one using the navigation arrows<br>
![Icon Display Multiple](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_IconDisplay_Multiple.gif)

### Export Icon
Click the desired icon to Export<br>
![Icon Export](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_IconDisplay_Export.gif)

### Export Quality
Use PowerShell (pwsh.exe) to export higher quality icons, .NET 8+ has newer methods that make it eaisier to extract higher quality icons. You'll see the quality difference in the preview<br>
![Icon Export Quality](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_IconDisplay_Quality.png)

## Right-Click Context Menu Option
Right-Click Context Menu Option to Lauch the app and automatically load the information<br>
![Right-Click Context Menu](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_ContextMenu_OnFile.png)

### Install the Context Menu Option
Install the Context Menu Option from the menu bar<br>
![Install Context Menu](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_ContextMenu_Install.png)

### Uninstall the Context Menu Option
Uninstall the Context Menu Option from the menu bar<br>
![Uninstall Context Menu](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_ContextMenu_Uninstall.png)

### Open the Folder of the Righ Click Menu
Open the Folder that contains the script and icon files used for the Context Menu<br>
![Open Context Menu Folder](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_ContextMenu_OpenFolder.png)

### Example
![Context Menu Example](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application-ContextMenu-Gif.gif)

## View all MSI Properties
Easily view all the properties of the MSI Database<br>
![View All Properties](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_AllProperties.png)

## Do Not Run as Admin
The Drag and Drop events will not work when ran as administrator. Run the script without elevated Priveledges.<br>
 ![Invoke MSI Application](https://raw.githubusercontent.com/MichaelEscamilla/GetMSIInformation/main/Images/Application_Example_RunAsAdmin.png)

 # Credit
Got the inspiration from [Andrew Jimenez](https://github.com/asjimene) GetMSIInfo<br>
 https://github.com/asjimene/GetMSIInfo

 
