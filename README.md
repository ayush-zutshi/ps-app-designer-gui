# PeopleSoft Application Designer GUI for multiple CONNECTID/CONNECTPSSWD tuples

### Overview
So you have multiple PeopleSoft environments each with a different CONNECTID/CONNECTPSWD (This is the "people" login and password).  Your PeopleSoft administrator probably has some cmd.exe menu driven file where you can pick an environment so that you can get to developing.

**IT IS A NEW CENTURY PEOPLE! You deserve a proper GUI!**

This program is a simple Powershell XAML GUI that loads a PeopleSoft Configuration Manager (pscfg.exe) exported config file and then starts the PeopleSoft Application Designer.

### Features
* Written in PowerShell so should work by default on any Windows system (Desktop/Laptop/VDI/RDP).
* Single PowerShell file that has embedded configuration.
* No extra libraries or exe files - nothing that might be prohibited on a locked down corporate|government furnished equipment.

### Runtime
![Run example screenshot:](https://github.com/ayush-zutshi/ps-app-designer-gui/blob/main/demo.png)

### Setup
* **See the header in "App Designer GUI.ps1" for configuration options**.
### Shortcut Creation
* Right-Click on the desktop and select "New --> Shortcut"
* Set "Location" to:
  ```
  %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -file "<path to>\Application Designer GUI.ps1"
  ```
* Click "Next"
* Type a Name for this Shortcut.  For example: 
  ```
  App Designer GUI
  ```
* Click "Finish"
* Right-click on the newly created shortcut and select "Properties".
* Set "Run" property to "Minimized".
* You may click on the "Change Icon" button and browse for:
  ```
  %PS_HOME%\bin\client\winx86\pside.exe
  ```
  and select the App Designer icon.
* Click "Okay" and you are done!
* Double-Click the shortcut to execute the PowerShell script.
