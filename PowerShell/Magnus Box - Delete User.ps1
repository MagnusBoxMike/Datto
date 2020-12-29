# --- EDIT SERVER INFO BELOW ---
# --- Need help? Email support@magnusbox.com ---
# --- This is the nuclear option! ALL DATA WILL BE DELETED FROM THE USER ACCOUNT! ---
# --- We will not be able to recover the data ---

# Set Net Connection TLS Defaults
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Datto RMM Start ###

# This script is used to DELETE a  Magnus Box User. 
# It will require a API User on the Magnus Box Server. 

# The Variables and defined location used in this script are - (Account Level) mbapiuser / mbapipassword / mbserver / mbserverport (Script Level) mbuserdel / mbuserpassworddel

# To use this script simply create a new Datto Component. Give it a meaningful Name and Description. 
# Choose PowerShell as the script language and simply past this entire script into the script box.
# Ensure you set your other script options as required.

# This script will use Datto Variable. Datto Variable are passed to the host running the script as Environment Variables. 
# This script reads in the Environment variables and maps to the required script variables.


# When this script runs is will prompt for the Magnus Box User and Password to be deleted.

# Set At Account Level
$username = "$env:mbapiuser"
$password = "$env:mbapipassword"
$server= "$env:mbserver"
$port= "$env:mbserverport"

# Set At Script Level
$mbu= "$env:mbuserdel"
$mbp= "$env:mbuserpassworddel"

### Datto RMM End ###

# --- DO NOT MODIFY ANYTHING BELOW THIS LINE ---

Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/delete-user" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"; TargetUser=$mbu; TargetPassword=$mbp; StoreRecoveryCode="1"} | Select-Object Content