Import-Module $env:SyncroModule

# --- EDIT SERVER INFO BELOW ---
# --- Need help? Email support@magnusbox.com ---

### Datto RMM Start ###

# This script is used to Remove the desktop Icon. 

# The Variables and defined location used in this script are - (Account Level) mbappname

# To use this script simply create a new Datto Component. Give it a meaningful Name and Description. 
# Choose PowerShell as the script language and simply past this entire script into the script box.
# Ensure you set your other script options as required.

# This script will use Datto Variable. Datto Variable are passed to the host running the script as Environment Variables. 
# This script reads in the Environment variables and maps to the required script variables.

# Set At Account Level
$backupname = "$env:mbappname"

### Datto RMM End ###

$driveid = "C"

# --- DO NOT MODIFY ANYTHING BELOW THIS LINE ---

Remove-Item "${driveid}:\Users\*\Desktop\$backupname.lnk"