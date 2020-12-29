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

### Datto RMM End ###

$driveid = "C"
$dircheck = "${driveid}:\Program Files" + "\$backupname"

# --- DO NOT MODIFY ANYTHING BELOW THIS LINE ---

Start-Process "${dircheck}\Uninstall.exe" -ArgumentList "/S"