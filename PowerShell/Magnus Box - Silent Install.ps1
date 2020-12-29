# --- EDIT SERVER INFO BELOW ---
# --- Need help? Email support@magnusbox.com ---

### Datto RMM Start ###

# This script is used to Install Magnus Box on the Device . 

# The Variables and defined location used in this script are - (Account Level) mbappname (Site Level) mbuser / mbuserpassword. 

# To use this script simply create a new Datto Component. Give it a meaningful Name and Description. 
# Choose PowerShell as the script language and simply past this entire script into the script box.
# Ensure you set your other script options as required.

# This script will use Datto Variable. Datto Variable are passed to the host running the script as Environment Variables. 
# This script reads in the Environment variables and maps to the required script variables.

# Set At Account Level
$backupname = "$env:mbappname"

# Set At Site Level
$mbu= "$env:mbuser"
$mbp= "$env:mbuserpassword"

### Datto RMM End ###

$driveid = "C"
$mbtemploc = "${driveid}:\mbtemp"
$dircheck = "${driveid}:\Program Files" + "\$backupname"

# --- DO NOT MODIFY ANYTHING BELOW THIS LINE ---

# Check to see if MagnusBox is installed already
if (-Not (Test-Path $dircheck)) { 

# Creates Temp Directory if not already created
if (-Not (Test-Path $mbtemploc)) { New-Item -ItemType dir $mbtemploc }

# Downloads installer 
Invoke-WebRequest "https://${server}/dl/6" -OutFile "${mbtemploc}\install_backup.exe"

# Runs installer from Platform Variable
Start-Process -NoNewWindow -FilePath "${mbtemploc}\install_backup.exe" -ArgumentList "/CONFIGURE=${mbu}:${mbp}"

# Pause the script for 60 seconds to allow the software to install
Start-Sleep -s 60

# Remove the icon from the desktop
Remove-Item "${driveid}:\Users\*\Desktop\$backupname.lnk"
Write-Host "Backup Software successfully installed."

} else {
Write-Error "Backup Software is already installed."
}