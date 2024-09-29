# GetMSIInformation
Drag and Drop Application to view key MSI Information and copy the values to the Clipboard

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

## Do Not Run as Admin
The Drag and Drop events will not work when ran as administrator. Run the script without elevated Priveledges.
 ![Invoke MSI Application](/Images/Application_Example_RunAsAdmin.png)
