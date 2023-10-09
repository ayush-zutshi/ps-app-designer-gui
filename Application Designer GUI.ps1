###############################################################################
# Ayush Zutshi                                                                #
# 09/2023                                                                     #
#                                                                             #
# Powershell GUI Launcher for PS Application Designer.                        #
# Loads the correct pscfg file and then launches PS Application Designer.     #
# Fuck that old console bullshit!  It is 2023.                                #
#                                                                             #
# Shortcut Info:                                                              #
# %SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe                 #
# -WindowStyle Hidden -file "G:\My Drive\Projects\git\ps-app-designer-gui\    #
# Application Designer GUI.ps1"                                               #
#                                                                             #                                                                            #
# Set shortcut to "Run Minimized" to eliminate the console window pop up.     #
# Set "Change Icon" to Your %PS_HOME%\bin\client\winx86\pside.exe and select  #
# the Application Designer icon.                                              #
#                                                                             #
###############################################################################
# Runtime environment and configuration:                                      #
#  *) Define $default_db. The database you want to show on startup.           #
#  *) Define $global:ptHome. The path to pscfg.exe and pside.exe.             #
#  *) Define $global:hData.  A hashtable map for database to pscfg file.      #
#  N.B. Follow the convention below for "DESCR - DBNAME"                      #
###############################################################################
$global:hData = @{
  'CM  - PHIRE'      = 'C:\psoft\config\phire.cfg'
  'CM  - STAT'       = 'C:\psoft\config\stat.cfg'
  'DEV - HRDEV'      = 'C:\psoft\config\hrdev.cfg'
  'DEV - CRDEV'      = 'C:\psoft\config\crdev.cfg'
  'DEV - LMDEV'      = 'C:\psoft\config\lmdev.cfg'
  'DEV - FSDEV'      = 'C:\psoft\config\fsdev.cfg'
  'DMO - HRDMO'      = 'C:\psoft\config\hrdmo.cfg'
  'DMO - CRDMO'      = 'C:\psoft\config\crdmo.cfg'
  'DMO - LMDMO'      = 'C:\psoft\config\lmdmo.cfg'
  'DMO - FSDMO'      = 'C:\psoft\config\fsdmo.cfg'
  'PRD - HRPRD'      = 'C:\psoft\config\hrprd.cfg'
  'PRD - CRPRD'      = 'C:\psoft\config\crprd.cfg'
  'PRD - LMPRD'      = 'C:\psoft\config\lmprd.cfg'
  'PRD - FSPRD'      = 'C:\psoft\config\fsprd.cfg'
  'TST - HRTST'      = 'C:\psoft\config\hrtst.cfg'
  'TST - CRTST'      = 'C:\psoft\config\crtst.cfg'
  'TST - LMTST'      = 'C:\psoft\config\lmtst.cfg'
  'TST - FSTST'      = 'C:\psoft\config\fstst.cfg'
}
$default_db = "DEV - HRDEV"
$global:ptHome = 'C:\Psoft\PT8.59.10\bin\client\winx86'
###############################################################################
# Functions:                                                                  #
###############################################################################
function launchAppDes {
  # Line below: Turn 'DEV - HRDEV' into 'HRDEV'
  $db = $dbName.Text.Split('-')[1].trim()
  $u = $dbUser.text
  $p = $dbPass.Password
  if ($u -and $p) {
    $cfx = "$global:ptHome\pscfg.exe -import:$global:cfgFile -setup -quiet" 
    $adx = "$global:ptHome\pside.exe -CD $db -CO $u -CP $p"
    write-host $cfx
    write-host $adx
    invoke-expression $cfx
    invoke-expression $adx
    $window.Close()  
  } else {
    [void] [System.Windows.Forms.MessageBox]::Show("Please Enter User ID and/or Password", "Parameters:","OK")
  }
}
###############################################################################
# Set up XAML GUI and Window:                                                 #
###############################################################################
Add-Type -AssemblyName PresentationFramework
Add-Type -Assemblyname System.Windows.Forms
[xml]$xaml = @"
<Window 
 x:Name="Window" 
 Width="250"
 Height="240" 
 ResizeMode="NoResize"
 WindowStartupLocation="CenterScreen"
 xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
 xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
 <Grid>
  <TextBlock   HorizontalAlignment="Left" VerticalAlignment="Top" Height="30" x:Name="appTitle" Margin="15,10,0,0"   Width="400" Text="App Designer Launcher" FontSize="18"/>
  <Label       HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" x:Name="lbl1"     Margin="15,50,0,0"   Width="60"  Content="Database"/>
  <ComboBox    HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" x:Name="dbName"   Margin="80,50,0,0"   Width="140"/>
  <Label       HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" x:Name="lbl2"     Margin="15,80,0,0"   Width="60"  Content="User ID"/>
  <TextBox     HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" x:Name="dbUser"   Margin="80,80,0,0"   Width="140"/>
  <Label       HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" x:Name="lbl3"     Margin="15,110,0,0"  Width="60"  Content="Password"/>
  <PasswordBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" x:Name="dbPass"   Margin="80,110,0,0"  Width="140"/>
  <Button      HorizontalAlignment="Left" VerticalAlignment="Top" Height="25" x:Name="launch"   Margin="80,140,0,0"  Width="140" Content="Launch"/>
  <Label       HorizontalAlignment="Left" VerticalAlignment="Top" Height="27" x:Name="cfgDisp"  Margin="15,170,0,0"  Width="190" Content=""/>
 </Grid>
</Window>
"@
$reader    = (New-Object System.Xml.XmlNodeReader $xaml)
$window    = [Windows.Markup.XamlReader]::Load($reader)
###############################################################################
# Grab variables from GUI:                                                    #
###############################################################################
$dbName    = $window.FindName("dbName")
$dbUser    = $window.FindName("dbUser")
$dbPass    = $window.FindName("dbPass")
$launchBtn = $window.FindName("launch")
$cfgDisp   = $window.FindName("cfgDisp")
###############################################################################
# Set up GUI events:                                                          #
###############################################################################
$dbName.add_SelectionChanged({ 
  $global:cfgFile = $global:hData[$dbname.SelectedValue.ToString()] 
  $cfgDisp.Content = $global:cfgFile 
})
$dbUser.Add_KeyDown({ 
  if ($_.Key -eq "Enter") { launchAppDes } 
})
$dbPass.Add_KeyDown({ 
  if ($_.Key -eq "Enter") { launchAppDes } 
})
$launchBtn.Add_Click({ launchAppDes })
###############################################################################
# Populate GUI drop downs and default values:                                 #
###############################################################################
$dbName.ItemsSource = $global:hData.GetEnumerator()|Sort-Object -Property Name|foreach-object {$_.key}
$dbUser.Text = ""
$dbPass.Password = ""
$dbName.Text = $default_db
$global:cfgFile = $global:hData[$default_db]
$cfgDisp.Content = $global:cfgFile
###############################################################################
# Load GUI:                                                                   #
###############################################################################
$window.ShowDialog()
