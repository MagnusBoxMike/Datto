# --- EDIT SERVER INFO BELOW --- #
# --- Need help? Email support@magnusbox.com --- #

# Set Net Connection TLS Defaults
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Datto RMM Start ###

# This script is used to assign a Policy to a Magnus Box User Account. 
# It will require a API User on the Magnus Box Server.

# The Variables and defined location used in this script are - (Account Level) mbapiuser / mbapipassword / mbserver / mbserverport (Site Level) mbuser / policyID

# To use this script simply create a new Datto Component. Give it a meaningful Name and Description. 
# Choose PowerShell as the script language and simply past this entire script into the script box.
# Ensure you set your other script options as required.

# This script will use Datto Variable. Datto Variable are passed to the host running the script as Environment Variables. 
# This script reads in the Environment variables and maps to the required script variables.


# Set At Account Level
$username = "$env:mbapiuser"
$password = "$env:mbapipassword"
$server= "$env:mbserver"
$port= "$env:mbserverport"

# Set At Site Level
$mbu= "$env:mbuser"
$policyID = "$env:mbpolicyid"

### Datto RMM End ###

# To find policyID, copy the end text from the web dashboard when viewing the policy

# --- DO NOT MODIFY ANYTHING BELOW THIS LINE --- #

# Get current user profile and find policyID index
$UserProfile = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/get-user-profile" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"; TargetUser=$mbu}
$UserProfile = $UserProfile.Content
Write-Host $UserProfile
$PolicyStartIndex = $UserProfile.IndexOf('PolicyID"') + 'PolicyID":"'.length
$PolicyEndIndex = $UserProfile.IndexOf('"', $PolicyStartIndex)

# Splice the profile into a beginning and end part
$ProfileFront = $UserProfile.Substring(0, $PolicyStartIndex)
$ProfileBack = $UserProfile.Substring($PolicyEndIndex, ($UserProfile.length - $PolicyEndIndex))

# Insert new policy ID and send to server
$UserProfile = $ProfileFront + $policyID + $ProfileBack
$Result = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/set-user-profile" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"; TargetUser=$mbu; ProfileData="${UserProfile}"}
Write-Host $Result.Content