# Get-CCPPassword.ps1

In CyberArk Safe Factory, we store the CyberArk REST API service account used to authenticate to CyberArk's Web Services (REST API) in CyberArk's Enterprise Password Vault.  It is retrieved just-in-time securely via CyberArk's Application Identity Manager (AIM) Centralized Credential Provider (CCP).

This file is borrowed from its original project page created by [pspete](https://github.com/pspete) on GitHub at: [https://github.com/pspete/CyberArk-PowerTools/tree/master/CentralCredentialProvider](https://github.com/pspete/CyberArk-PowerTools/tree/master/CentralCredentialProvider)

We can include it for use in CyberArk Safe Factory by dot sourcing it by doing the following at the top of the script:

```powershell
. .\modules\Get-CCPPassword.ps1
```

For an example of how to use it:

```powershell
Get-CCPPassword -AppID Safe-Factory -Safe $safeName -Object $objectName -URL https://components/AIMWebService
```

For an example of how to use it and secure the credentials into a PSCredential object for easy use with [psPAS](https://github.com/pspete/psPAS):

```powershell
### GET API CREDENTIALS FROM AIM CCP
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$response = Get-CCPPassword -AppID Safe-Factory -Safe D-APP-CYBR-SAFEFACTORY -Object CyberArk-REST-Safe-Factory-SvcAcct -WebServiceName AIMWebService -URL $baseURI
$securePassword = ConvertTo-SecureString $response.Content -AsPlainText -Force
$apiCredentials = New-Object System.Management.Automation.PSCredential($response.UserName, $securePassword)
```