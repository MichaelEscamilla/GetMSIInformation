# GetMSIInformation
Drag and Drop Application to view key MSI Information and copy the values to the Clipboard<br>
 ![FirstLoad](/Images/Application_FirstLoad.png)

## Example after loading an MSI
 ![ExampleLoad](/Images/Application_Example00.png)

## Quick Access
Quickly access the app by invoking the URL [msiapp.michaeltheadmin.com](https://msiapp.michaeltheadmin.com)

### Invoke-Expression
```powershell
iex (irm msiapp.michaeltheadmin.com)
```
 ![Invoke MSI Application](/Images/Application_Example_Run.png)

## Right-Click Context Menu Option
Right-Click Context Menu Option to Lauch the app and automatically load the information

![Right-Click Context Menu](/Images/Application_ContextMenu_OnFile.png)

### Install the Context Menu Option
Install the Context Menu Option from the menu bar<br>
![Install Context Menu](/Images/Application_ContextMenu_Install.png)

### Uninstall the Context Menu Option
Uninstall the Context Menu Option from the menu bar<br>
![Uninstall Context Menu](/Images/Application_ContextMenu_Uninstall.png)

## Do Not Run as Admin
The Drag and Drop events will not work when ran as administrator. Run the script without elevated Priveledges.<br>
 ![Invoke MSI Application](/Images/Application_Example_RunAsAdmin.png)