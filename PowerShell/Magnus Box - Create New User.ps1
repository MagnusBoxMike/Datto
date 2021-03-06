# --- EDIT SERVER INFO BELOW --- #
# --- Need help? Email support@magnusbox.com --- #

# Set Net Connection TLS Defaults
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

### Datto RMM Start ###

# This script is used to create a New Magnus Box User. 
# It will require a API User on the Magnus Box Server. 

# The Variables and defined location used in this script are - (Account Level) mbapiuser / mbapipassword / mbserver / mbserverport (Site Level) mbuser / mbuserpassword. 

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
$mbp= "$env:mbuserpassword"

### Datto RMM End ###

# --- Post-Create Processing --- #
$assignPolicy = $true
$assignVault = $true


# --- DO NOT MODIFY ANYTHING BELOW THIS LINE --- #
$version = $PSVersionTable.PSVersion
Write-Host "Powershell Version: ${version}"

# Create user
$UserResult = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/add-user" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"; TargetUser=$mbu; TargetPassword=$mbp; StoreRecoveryCode="1"}
$UserResult = $UserResult.Content
# Log the status
if($UserResult.IndexOf('200') -ne -1) {
    Write-Host "Added user successfully"
} else {
    Write-Host "FAILURE: Unable to add user! Response below:"
    Write-Host $UserResult
    Exit 2
}

# Used to signal status of script
$WasError = $false

# Choose policy (if they want it)
if($AssignPolicy -eq $true) {
    
    # Get a list of all of the policies and convert to PSObject
    $PolicyList = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/policies/list-full" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"}
    $PolicyList = $PolicyList | ConvertFrom-Json
    
    # Loop through each policy to check if it's default
    $PolicyID = ""
    $PolicyList.PSObject.Properties | ForEach-Object {
        
        $IsDefault = $_.Value.PSObject.Properties["DefaultUserPolicy"].Value
        if($IsDefault -eq $true) {
            $PolicyID = $_.Name
        }
    }
    
    # Log the result if there wasn't a default set
    if($PolicyID.length -lt 5) {
        Write-Host "WARNING: No default policy specified. Unable to set"
        $WasError = $true
        
    } else {
        # Get current user profile and find policyID index
        $UserProfile = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/get-user-profile" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"; TargetUser=$mbu}
        $UserProfile = $UserProfile.Content
        $PolicyStartIndex = $UserProfile.IndexOf('PolicyID"') + 'PolicyID":"'.length
        $PolicyEndIndex = $UserProfile.IndexOf('"', $PolicyStartIndex)
    
        # Splice the profile into a beginning and end part
        $ProfileFront = $UserProfile.Substring(0, $PolicyStartIndex)
        $ProfileBack = $UserProfile.Substring($PolicyEndIndex, ($UserProfile.length - $PolicyEndIndex))
    
        # Insert new policy ID and send to server
        $UserProfile = $ProfileFront + $PolicyID + $ProfileBack
        $PolicyResult = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/set-user-profile" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"; TargetUser=$mbu; ProfileData="${UserProfile}"}
        $PolicyResult = $PolicyResult.Content
        
        # Let the user know if it was a success
        if($PolicyResult.IndexOf('200') -ne -1) {
            Write-Host "Default policy added successfully"
        } else {
            Write-Host "WARNING: Policy was not added to user! Response below:"
            Write-Host $PolicyResult
            $WasError = $true
        }
    }
    
}

# Vault selection logic
if($AssignVault -eq $true) {
    
    # Grab the ID of the first (and likely only) vault
    $VaultList = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/request-storage-vault-providers" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"}
    $VaultList = $VaultList.Content
    $VaultIdStart = $VaultList.IndexOf('{"') + '{"'.length
    $VaultIdEnd = $VaultList.IndexOf('":"', $VaultIdStart)
    $VaultId = $VaultList.Substring($VaultIdStart, ($VaultIdEnd - $VaultIdStart))
    
    # Assign this vault to the user
    $VaultResult = Invoke-Webrequest -Uri "https://${server}:${port}/api/v1/admin/request-storage-vault" -UseBasicParsing -Method POST -Body @{Username="${username}"; AuthType="Password"; Password="${password}"; TargetUser=$mbu; StorageProvider="${VaultId}"}
    $VaultResult = $VaultResult.Content
    
    # Log the status
    if($VaultResult.IndexOf('200') -ne -1) {
        Write-Host "Storage vault was created for the user"
    } else {
        Write-Host "WARNING: Vault unable to be created! Response below:"
        Write-Host $VaultResult
        $WasError = $true
    }
}

# Exit status 1 = Warning
if($WasError -eq $true) {
    Exit 1
}