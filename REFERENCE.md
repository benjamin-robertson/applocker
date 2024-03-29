# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`applocker`](#applocker): Set applocker rules for windows
* [`applocker::service`](#applockerservice): Starts applocker service

### Functions

* [`applocker::compare_rules`](#applockercompare_rules): Compares Windows applocker rules.
* [`applocker::extract_rules`](#applockerextract_rules): Extract applocker rules
* [`applocker::get_id`](#applockerget_id): Get ID of existing applocker rules. If no existing rule by that name, a new hash is generated.
* [`applocker::hash_toxml`](#applockerhash_toxml): Convert hash to xml
* [`applocker::xml_tohash`](#applockerxml_tohash): XML to hash

## Classes

### <a name="applocker"></a>`applocker`

Configures applocker rules for windows. See readme on how to structure applocker rules.

lint:ignore:140chars

#### Examples

##### 

```puppet
include applocker
```

#### Parameters

The following parameters are available in the `applocker` class:

* [`exec_applocker_rules`](#exec_applocker_rules)
* [`msi_applocker_rules`](#msi_applocker_rules)
* [`appx_applocker_rules`](#appx_applocker_rules)
* [`script_applocker_rules`](#script_applocker_rules)
* [`dll_applocker_rules`](#dll_applocker_rules)
* [`executable_rules`](#executable_rules)
* [`msi_rules`](#msi_rules)
* [`dll_rules`](#dll_rules)
* [`script_rules`](#script_rules)
* [`packaged_app_rules`](#packaged_app_rules)
* [`start_service`](#start_service)

##### <a name="exec_applocker_rules"></a>`exec_applocker_rules`

Data type: `Hash`

Exec applocker rules to configure.

Default value: `{}`

##### <a name="msi_applocker_rules"></a>`msi_applocker_rules`

Data type: `Hash`

msi applocker rules to configure.

Default value: `{}`

##### <a name="appx_applocker_rules"></a>`appx_applocker_rules`

Data type: `Hash`

Packaged app rules to configure.

Default value: `{}`

##### <a name="script_applocker_rules"></a>`script_applocker_rules`

Data type: `Hash`

scipt applocker rules to configure.

Default value: `{}`

##### <a name="dll_applocker_rules"></a>`dll_applocker_rules`

Data type: `Hash`

dll applocker rules to configure.

Default value: `{}`

##### <a name="executable_rules"></a>`executable_rules`

Data type: `Enum['Enabled','AuditOnly']`

Mode for executable rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.

Default value: `'AuditOnly'`

##### <a name="msi_rules"></a>`msi_rules`

Data type: `Enum['Enabled','AuditOnly']`

Mode for msi rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.

Default value: `'AuditOnly'`

##### <a name="dll_rules"></a>`dll_rules`

Data type: `Enum['Enabled','AuditOnly']`

Mode for dll rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.

Default value: `'AuditOnly'`

##### <a name="script_rules"></a>`script_rules`

Data type: `Enum['Enabled','AuditOnly']`

Mode for script rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.

Default value: `'AuditOnly'`

##### <a name="packaged_app_rules"></a>`packaged_app_rules`

Data type: `Enum['Enabled','AuditOnly']`

Mode for packaged app rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.

Default value: `'AuditOnly'`

##### <a name="start_service"></a>`start_service`

Data type: `Boolean`

Whether to start the applocker service. Default: true

Default value: ``true``

### <a name="applockerservice"></a>`applocker::service`

Starts applocker service

#### Examples

##### 

```puppet
private class
```

## Functions

### <a name="applockercompare_rules"></a>`applocker::compare_rules`

Type: Ruby 4.x API

Compares Windows applocker rules.

#### `applocker::compare_rules(Hash $rules, Hash $desired_rules)`

Compares Windows applocker rules.

Returns: `Hash` Returns true if match, if no match, false along with which rule failed to match.

##### `rules`

Data type: `Hash`

Existing rules from a host

##### `desired_rules`

Data type: `Hash`

Desired applocker rules from Puppet manifest.

### <a name="applockerextract_rules"></a>`applocker::extract_rules`

Type: Ruby 4.x API

Extract applocker rules

#### `applocker::extract_rules(Hash $rules)`

Extract applocker rules

Returns: `Hash` Hash of all applocker rules in policy along with the rule hash.

##### `rules`

Data type: `Hash`

Applocker rules to extract

### <a name="applockerget_id"></a>`applocker::get_id`

Type: Ruby 4.x API

Get ID of existing applocker rules. If no existing rule by that name, a new hash is generated.

#### `applocker::get_id(Hash $applocker_rules, Hash $name_to_id)`

Get ID of existing applocker rules. If no existing rule by that name, a new hash is generated.

Returns: `Hash` Hash with rulename to rule mapping.

##### `applocker_rules`

Data type: `Hash`

Applocker rules to check from Puppet catalog

##### `name_to_id`

Data type: `Hash`

Name to ID mapping to check.

### <a name="applockerhash_toxml"></a>`applocker::hash_toxml`

Type: Ruby 4.x API

Convert hash to xml

#### `applocker::hash_toxml(Hash $hash_val)`

Convert hash to xml

Returns: `String` XML string

##### `hash_val`

Data type: `Hash`

Hash to convert to XML

### <a name="applockerxml_tohash"></a>`applocker::xml_tohash`

Type: Ruby 4.x API

XML to hash

#### `applocker::xml_tohash(String $xml_content)`

XML to hash

Returns: `Hash` Hash converted from XML

##### `xml_content`

Data type: `String`

XML to convert to hash

