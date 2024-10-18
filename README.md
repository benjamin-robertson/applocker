# applocker

A Puppet module which configures applocker on Windows (Application whitelisting). For information about applocker see [here][2]

## Setup requirements

benjaminrobertson-applocker requires the xml-simple ruby gem installed on the Puppet Primary server, compilers and replica. The module will not function without this gem. This can be installed by the following methods.

### Via Puppet manifest

Applocker module since 1.0.0 includes a Puppet class to install the xml-simple gem into your Puppet infrastructure. 

1. Within the PE console, navigate to "Node Groups".
1. Locate the "PE Infrastructure Agent" node group and click into it. **Hint:** its under "All Nodes\PE Infrastructure\PE Agent". 
1. Under the classes tab, add the class "applocker::primary::gem_installer". Commit the change.
1. Run Puppet on every PE infrastructure component. **Note:** This will restart the pe-puppetserver.

**Note:** The above instructions will only work if your Puppet Enterprise infrastructure has internet access or access to ruby gems.

### Manually via command line

1. Install by running `puppetserver gem install xml-simple` as root on the Puppet Primary server and other PE infrastructure components.

**Note:** When Puppet attempts to enable applocker service for the first time, this error will be seen in the Puppet logs. `Error: Cannot enable AppIDSvc, error was: undefined method 'windows' for Puppet::Util:Module` Applocker is running regardless of this error. 

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with applocker](#setup)
    * [What applocker affects](#what-applocker-affects)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

## Setup

### What applocker affects

benjaminrobertson-applocker configures Windows applocker service. Applocker enforces applications whitelisting. 

**Warning:** Ensure applocker policies are first tested on a non-production host. You can very easily break systems by enforcing strict applocker policies.

I suggest applying applocker policies in 'AuditOnly' mode (modules default). Use Windows event viewer to check for unexpected applocker denies. [EventId's][3]

## Usage

Include applocker module in Puppet manifest.
```
include applocker
```

**Note:** If generating a hash for an executable, you cannot use a standard SHA256 filehash. Microsoft uses [Authenticode][4] hash. Generate one by running in powershell.
```
Get-AppLockerFileInformation .\putty.exe | Format-wide -Property hash -AutoSize
```
This will print the hash which should look as follows. `0x7537EBDECCA5F65EA98216C23E9441B72269A546B3234F6CF4069C60269FE18F`

Set applocker rules using hiera data as follows. Customise as required for your environment. 

### Exec applocker rules - Example
```
applocker::exec_applocker_rules:
  Exec %windir/%:
    ensure: "present" # No longer required. Can leave option in for backwards support
    action: "Allow"
    conditions:
      path: "%WINDIR%\\*"
    exceptions:
      - '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'
      - '%SYSTEM32%\spool\drivers\color\*'
      - '%SYSTEM32%\Tasks\*'
      - '%WINDIR%\Tasks\*'
      - '%WINDIR%\Temp\*'
    description: "Allow all users to run apps in windir"
    rule_type: "path"
    type: "Exe" # Not required, we know its a exe rule. Can leave option in for backwards support
    user_or_group_sid: "S-1-1-0"
  Exec %%PROGRAMFILES/%:
    action: "Allow"
    conditions:
      path: "%PROGRAMFILES%\\*"
    description: "Allow all users to run apps in programfiles"
    rule_type: "path"
    type: "Exe"
    user_or_group_sid: "S-1-1-0"
  Exec %OSDRIVE/CHOCO/%:
    action: "Allow"
    conditions:
      path: "%OSDRIVE%\\CHOCO\\*"
    description: "Allow all users to run apps in osdrive choco"
    rule_type: "path"
    type: "Exe"
    user_or_group_sid: "S-1-1-0"
  Exec %OSDRIVE/temp/%:
    action: "Allow"
    conditions:
      path: "%OSDRIVE%\\temp\\doge\\*"
    description: "Allow all users to run apps in osdrive temp"
    rule_type: "path"
    type: "Exe"
    user_or_group_sid: "S-1-1-0"
  Exec putty hash:
    # ensure: "present"
    action: "Allow"
    conditions:
      - type: "SHA256"
        length: "1647912"
        file_name: "putty.exe"
        hash: "0x6E7F0B23165CDD134DA7E893DEE9422640287B02EAE3CE64AA1EE76AE9ED6512"
    rule_type: "hash"
    type: "Exe"
    user_or_group_sid: "S-1-1-0"
```

### MSI applocker rules - Example
```
applocker::msi_applocker_rules:
  MSI rule MS corp:
    ensure: "present"
    action: "Allow"
    conditions:
      publisher: "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US"
      product: "*"
      binaryname: "*"
      hi_version: "*"
      lo_version: "*"
    description: "Allow Package app rule Microsoft corporation"
    rule_type: "publisher"
    type: "Msi"
    user_or_group_sid: "S-1-1-0"
  MSI rule MS corp windows:
    ensure: "present"
    action: "Allow"
    conditions:
      publisher: "CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US"
      product: "*"
      binaryname: "*"
      hi_version: "*"
      lo_version: "*"
    description: "Allow Package app rule Microsoft corporation (Windows)"
    rule_type: "publisher"
    type: "Msi"
    user_or_group_sid: "S-1-1-0"
```

### Packaged applocker rules - Example
```
applocker::appx_applocker_rules:
  Packaged app MS corp:
    ensure: "present"
    action: "Allow"
    conditions:
      publisher: "CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US"
      product: "*"
      binaryname: "*"
      hi_version: "*"
      lo_version: "*"
    description: "Allow Package app rule Microsoft corporation"
    exceptions:
      - publisher: "CN=Louis, O=Robertson, C=AU"
        product: "*"
        binaryname: "*"
        lo_version: "*"
        hi_version: "3.0.0.0" # Note this needs to be in format x.x.x.x
      - publisher: "CN=doge, O=coin, C=AU"
        product: "*"
        binaryname: "*"
        lo_version: "*"
        hi_version: "*"
    rule_type: "publisher"
    type: "Appx"
    user_or_group_sid: "S-1-1-0"
  Packaged app MS corp windows:
    ensure: "present"
    action: "Allow"
    conditions:
      publisher: "CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US"
      product: "*"
      binaryname: "*"
      hi_version: "*"
      lo_version: "*"
    description: "Allow Package app rule Microsoft corporation (Windows)"
    rule_type: "publisher"
    type: "Appx"
    user_or_group_sid: "S-1-1-0"
```

### Script applocker rules - Example
```
applocker::script_applocker_rules:
  Script %WINDIR/%:
    action: "Allow"
    conditions:
      path: "%WINDIR%\\*"
    exceptions:
      - '%SYSTEM32%\Com\dmp\*'
      - '%SYSTEM32%\FxsTmp\*'
      - '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'
      - '%SYSTEM32%\spool\drivers\color\*'
      - '%SYSTEM32%\spool\PRINTERS\*'
      - '%SYSTEM32%\spool\SERVERS\*'
      - '%SYSTEM32%\Tasks\*'
      - '%WINDIR%\Registration\CRMLog\*'
      - '%WINDIR%\Tasks\*'
      - '%WINDIR%\Temp\*'
      - '%WINDIR%\tracing\*'
    description: "Allow scripts in the windir directory"
    rule_type: "path"
    type: "Script"
    user_or_group_sid: "S-1-1-0"
  Script %PROGRAMFILES/%:
    action: "Allow"
    conditions:
      path: "%PROGRAMFILES%\\*"
    description: "Allow scripts in the programfiles directory"
    rule_type: "path"
    type: "Script"
    user_or_group_sid: "S-1-1-0"
  Script powershell hash:
    action: "Allow"
    description: "random test powershell script"
    conditions:
      - type: "SHA256"
        length: "20"
        file_name: "powerfulshell.ps1"
        hash: "0x2057696D8662313670D36C3A3C8009FB038C8732C40C65275F158F63AAAD1629"
    rule_type: "hash"
    user_or_group_sid: "S-1-1-0"
```

### DLL applocker rules - Example
```
applocker::dll_applocker_rules:
  DLL %PROGRAMFILES/%:
    action: "Allow"
    conditions:
      path: "%PROGRAMFILES%\\*"
    description: "Allow dll in the programfiles directory"
    rule_type: "path"
    type: "Dll"
    user_or_group_sid: "S-1-1-0"
  DLL %WINDIR/%:
    action: "Allow"
    conditions:
      path: "%WINDIR%\\*"
    exceptions:
      - '%SYSTEM32%\spool\drivers\color\*'
      - '%SYSTEM32%\Tasks\*'
      - '%WINDIR%\Tasks\*'
      - '%WINDIR%\Temp\'
      - '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'
    description: "Allow dll in the programfiles directory"
    rule_type: "path"
    type: "Dll"
    user_or_group_sid: "S-1-1-0"
```

### Enabling applocker rules

Applocker rules can be enabled or disabled by setting Enum['Enabled','AuditOnly'] for the following parameters.

* executable_rules
* msi_rules
* dll_rules
* script_rules
* packaged_app_rules


## Limitations

* Developed on Puppet Enterprise 2021.7.6 and Windows 2019
* Expected to work with all modern versions of Puppet and Windows.

## Development

If you find any issues with this module, please log them in the issues register of the GitHub project. [Issues][1]

Module was developed with PDK. Unit tests only pass on Windows system. eg `pdk test unit`. 

PR glady accepted :)

[1]: https://github.com/benjamin-robertson/applocker/issues
[2]: https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/applocker/what-is-applocker
[3]: https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/applocker/using-event-viewer-with-applocker#review-the-applocker-logs-in-windows-event-viewer
[4]: https://learn.microsoft.com/en-us/windows-hardware/drivers/install/authenticode