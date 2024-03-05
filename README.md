# applocker

A Puppet module which configures applocker on Windows (Application whitelisting). For information about applocker see [Here][2]

## Setup requirements

benjaminrobertson-applocker requires the xml-simple ruby gem installed on the Puppet Primary server. Install by running 
```
puppetserver gem install xml-simple
```
As root on the Puppet Primary server.


## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with applocker](#setup)
    * [What applocker affects](#what-applocker-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with applocker](#beginning-with-applocker)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Briefly tell users why they might want to use your module. Explain what your
module does and what kind of problems users can solve with it.

This should be a fairly short description helps the user decide if your module
is what they want.

## Setup

### What applocker affects **OPTIONAL**

benjaminrobertson-applocker configure Windows applocker service. Applocker enforces applications whitelisting. 

** Warning: ensure  **

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
another module, etc.), mention it here.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you might want to include an additional "Upgrading" section here.

### Beginning with applocker

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most basic
use of the module.

## Usage



## Limitations

* Developed on Puppet Enterprise 2021.7.6 and Windows 2019
* Expected to work with all modern versions of Puppet and Windows.

## Development

If you find any issues with this module, please log them in the issues register of the GitHub project. [Issues][1]

PR glady accepted :)

[1]: https://github.com/benjamin-robertson/applocker/issues
[2]: https://learn.microsoft.com/en-us/windows/security/application-security/application-control/windows-defender-application-control/applocker/what-is-applocker