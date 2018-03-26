Import-Module psPAS

### VARIABLES

$baseURI = "https://components"
$domainName = "joe-garcia.local"

### RECEIVE USER INPUT
Write-Host "===============================" -ForegroundColor Yellow
Write-Host "CyberArk Safe Factory" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow
Write-Host ""
$safeName = Read-Host "Enter Safe Name to Create"

### GET API CREDENTIALS FROM AIM CCP
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$response = Invoke-RestMethod -Method "GET" -Uri "https://components/AIMWebService/api/Accounts?AppID=Safe-Factory&Safe=D-APP-CYBR-SAFEFACTORY&Folder=Root&Object=CyberArk-REST-Safe-Factory-SvcAcct" -Headers @{ "Content-Type" = "application/json" }
$securePassword = ConvertTo-SecureString $response.Content -AsPlainText -Force
$apiCredentials = New-Object System.Management.Automation.PSCredential($response.UserName, $securePassword)

### LOGIN
try {
    $token = New-PASSession -Credential $apiCredentials -BaseURI $baseURI -Verbose

    Write-Host "Securely logged into CyberArk Web Services"
} catch {
    Write-Host "[ ERROR ] Could not login to CyberArk Web Services" -ForegroundColor Red
    Exit
}

### CREATE SAFE
try {
    $token | Add-PASSafe -SafeName $safeName -Description "Automatically Created by CyberArk Safe Factory" -ManagingCPM PasswordManager -NumberOfVersionsRetention 7 -Verbose

    Write-Host "Created ${safeName} safe"
} catch {
    Write-Host "Safe already exists... continuing to Add Safe Members" -ForegroundColor Red
}

### PERMISSION ADMIN ROLE
try {
    $token | Add-PASSafeMember -SafeName $safeName -MemberName "CyberArk_${safeName}_Admin" -SearchIn $domainName -UseAccounts $true -RetrieveAccounts $true -ListAccounts $true `
        -AddAccounts $true -UpdateAccountContent $true -UpdateAccountProperties $true -InitiateCPMAccountManagementOperations $true -SpecifyNextAccountContent $true -RenameAccounts $true `
        -DeleteAccounts $true -UnlockAccounts $true -ManageSafe $true -ManageSafeMembers $true -BackupSafe $true -ViewAuditLog $true -ViewSafeMembers $true -RequestsAuthorizationLevel 2 `
        -AccessWithoutConfirmation $true -CreateFolders $true -DeleteFolders $true -MoveAccountsAndFolders $true -Verbose

    Write-Host "Added the Admin Role via Active Directory group CyberArk_${safeName}_Admin"
} catch {
    Write-Host "[ ERROR ] Could not add Admin role member to safe" -ForegroundColor Red
    Exit
}

### PERMISSION AUDITOR ROLE
try {
    $token | Add-PASSafeMember -SafeName $safeName -MemberName "CyberArk_${safeName}_Auditor" -SearchIn $domainName -UseAccounts $false -RetrieveAccounts $false -ListAccounts $true `
        -AddAccounts $false -UpdateAccountContent $false -UpdateAccountProperties $false -InitiateCPMAccountManagementOperations $false -SpecifyNextAccountContent $false -RenameAccounts $false `
        -DeleteAccounts $false -UnlockAccounts $false -ManageSafe $false -ManageSafeMembers $false -BackupSafe $false -ViewAuditLog $true -ViewSafeMembers $true -RequestsAuthorizationLevel 0 `
        -AccessWithoutConfirmation $false -CreateFolders $false -DeleteFolders $false -MoveAccountsAndFolders $false -Verbose

    Write-Host "Added the Admin Role via Active Directory group CyberArk_${safeName}_Auditor"
} catch {
    Write-Host "[ ERROR ] Could not add Auditor role member to safe" -ForegroundColor Red
    Exit
}

### PERMISSION USER ROLE
try {
    $token | Add-PASSafeMember -SafeName $safeName -MemberName "CyberArk_${safeName}_User" -SearchIn $domainName -UseAccounts $true -RetrieveAccounts $true -ListAccounts $true `
        -AddAccounts $false -UpdateAccountContent $false -UpdateAccountProperties $false -InitiateCPMAccountManagementOperations $true -SpecifyNextAccountContent $false -RenameAccounts $false `
        -DeleteAccounts $false -UnlockAccounts $true -ManageSafe $false -ManageSafeMembers $false -BackupSafe $false -ViewAuditLog $true -ViewSafeMembers $true -RequestsAuthorizationLevel 0 `
        -AccessWithoutConfirmation $false -CreateFolders $false -DeleteFolders $false -MoveAccountsAndFolders $false -Verbose

    Write-Host "Added the Admin Role via Active Directory group CyberArk_${safeName}_User"
} catch {
    Write-Host "[ ERROR ] Could not add User role member to safe" -ForegroundColor Red
    Exit
}

try {
    $token | Close-PASSession -Verbose

    Write-Host "Logged off CyberArk Web Services"
} catch {
    Write-Host "[ ERROR ] Could not logoff CyberArk Web Services - auto-logoff will occur in 20 minutes" -ForegroundColor Red
    Exit
}

Write-Host "Script complete!" -ForegroundColor Green
