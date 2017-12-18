# osconfig_eita_mgmt

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with osconfig_eita_mgmt](#setup)
    * [What osconfig_eita_mgmt affects](#what-osconfig_eita_mgmt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with osconfig_eita_mgmt](#beginning-with-osconfig_eita_mgmt)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module will manage the auditd.conf (and daemon), audit.rules (by consolidating) them, 
 and the AUDIT-forwarding capability through RSYSLOG.  It will do this for all RHEL machines
 of majorVersions 6 & 7, and Products: clients, workstations and servers. These machine types
 based on majorVersions and Products will be determined using customfacts/opersys.rb 
 Facts (os_brand, os_product and os_revision), because only the servers will enable  the 
 AUDIT-forwarding capability and configure it to point/forward records to a central audit logging server.
Finally, this module will also manage the /etc/rsyslog.conf file for general purposes, as well as 
 for the explicit purposes of forwarding the audit messages using the LOCAL4 facility.

## Module Description

This module will incorporate parameters to be used by the sysadmin using this module.  The parameters are
 applied to the rsyslog.conf file as the file is generated from an ERB-template (one for each major release
 of RHEL). There is some logic used within the ERB-template to determine if UDP or TCP is being requested 
 to configure clients to forward traffic to a central host (collector_ip) on the standard port 514 using 
 the standard protocol of (TCP).

Based on the single input from the sysadmin, collector_ip, an rsyslog.conf file should be generated properly
 to point to whichever server on the network as configured.  This module is being written for flexibility for
 changes from the UDIF Lab to Production, and again in Production once the newer RSYSLOG server is built in
 support of the MAS enterprise.

This module does not install rsyslog; it merely configures the rsyslog.conf to those requirements as provided by EITA.

Finally, this module configures the standard RHEL Audit software. It will make use of customfacts to determine
 which of the following (or all three) setting groups will be applied, since servers only (both RHEL-6-server
 and RHEL-7-server) will receive AUDIT-forward configurations.

## Setup

### What osconfig_eita_mgmt affects

For RHEL servers, whether 6 or 7, the following will be altered:

  1. /etc/audit/auditd.conf 
  2. /etc/audit/rules.d/audit.rules
  3. /usr/local/sbin/auditd.cron will be dropped into place.
  4. auditd.cron will be implemented
  5. /usr/local/bin/audit-local4.sh will be dropped into place.
  6. audit-local4.sh Cronjob will be implemented
  7. /etc/rsyslog.conf (allowing for LOCAL4 {AUDIT event} forwarding)

For all of the clients and workstations, the following will be altered:

  1. /etc/audit/auditd.conf 
  2. /etc/audit/rules.d/audit.rules
  3. /usr/local/sbin/auditd.cron will be dropped into place.
  4. auditd.cron will be implemented
  5. /usr/local/bin/audit-local4.sh will __NOT__ be dropped into place.
  6. /etc/rsyslog.conf (disabling LOCAL4 {AUDIT event} forwarding)

Special Details:
* Packages altered: NONE
* Services restart: rsyslogd (is restarted, __ONLY__ if rsyslog.conf is updated),
   also auditd (is restarted, if __EITHER__ auditd.conf or audit.rules is restarted.
* ALL authpriv priorities> triggered will cause such records to be forwarded to the central (collector) server
   designated for any given site.

### Setup Requirements **OPTIONAL**

After installing the module into the Satellite or Puppetmaster:

  1. the sysadmin MUST add the one (1) class to each of the Host Groups of interest, and
  2. then must provide values for the single parameter collector_ip.
  3. No other requirements are necessary.

### Beginning with osconfig_eita_mgmt

This module requires that the MAS enterprise has the host-based-firewalls disabled and off! 
 If IPTABLES or FIREWALLD is not off on all of the machines within the Host Group associated with this module
 then the module will not work on those particular hosts.

## Usage

Implement the class; then, provide values for the single parameter - collector_ip.

Otherwise __USE AT YOUR OWN RISK__.

## Reference

CLASSes: osconfig_eita_mgmt::implement, osconfig_eita_mgmt::backout
Types:   Files, Services, Cron
Resources: Service['rsyslog'], File['/etc/rsyslog.conf']
Parameters: collector_ip

## Limitations

This module is only compatible with RHEL6 and RHEL7, servers, clients and workstations.

## Development

Use at your own risk.

## Release Notes/Contributors/Etc **Optional**

This module was cobbled together from syntax originally written as 2 independent Puppet Modules, specifically,
 baseline_audit_mgmt and baseline_rsyslog_mgmt.  Both of these modules should be removed prior to the implementation
 of this specific module - osconfig_eita_mgmt.




## ChangeLog - documented from newest on top, down to oldest.

mm/dd/yyyy(newest on top)       -ModuleName_Rev-Maj.Min        `-Addresses={DR#....,DR#....}`   -BITS=number    -Author;

11/28/2017      -__osconfig_eita_mgmt-1.0.2__     `-Addresses={DR#2996454,NETS#IM477834}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.2          -WFrench;
        Updated rules.new.erb to correct audit rules missing some relevant syntax (-p raw for example).  PRivera discovered another flaw, the buffer length (currently 8192) was
         too small, therefore increasing it to 16384 was the solution.

10/26/2017      -__osconfig_eita_mgmt-1.0.1__     `-Addresses={DR#2996454,NETS#IM477834}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.2          -WFrench;
        Updated to add the single (1) parameter that is only used in the ERB-template for the /etc/rsyslog.conf file; apparently the parameter __MUST ALSO BE DEFINED__ inside
         the manifest file as well,  __NO EXCEPTION.__

10/18/2017      -__osconfig_eita_mgmt-1.0.0__     `-Addresses={DR#2996454,NETS#IM477834}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.2          -WFrench;
        Approved for release to Production by PRivera.

10/17/2017      -__osconfig_eita_mgmt-0.1.18__      `-Addresses={DR#2996454,NETS#IM477834}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.2          -WFrench;
        Added additional syntax to address redhat-6 machines to force the removal of the rules.d subdirectory from /etc/audit.

10/10/2017      -__osconfig_eita_mgmt-0.1.17__      `-Addresses={DR#2996454,NETS#IM477834}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.2          -WFrench;
        Corrected onlyif checks, due to missing whitespace character.  Problem should now be resolved.

10/10/2017      -__osconfig_eita_mgmt-0.1.16__      `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Corrected Puppet resources, based on RHEL6 versus RHEL7 requirements, and also based on server versus client/workstation requirements.
        Also added Exec resources to append the appropriate PAM configuration changes required by the EITA-AUDIT.

09/12/2017      -__osconfig_eita_mgmt-0.1.15__      `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Added Server-check logic for __determining whether or not to use__ the IP address given; to prevent client machines from being configured to forward RSYSLOG (AUDIT) events.

09/07/2017      -__osconfig_eita_mgmt-0.1.14__      `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Added also puppet syntax to address the caveats of redhat-6-not_vda-client, redhat-6-not_vda-server,  redhat-6-vda-server, redhat-7-not_vda-server, redhat-7-not_vda-client, redhat-7-not_vda-workstation.

09/07/2017      -__osconfig_eita_mgmt-0.1.13__      `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Added puppet syntax to address the caveats of redhat-6-not_vda-workstation and redhat-7-vda-server.

08/31/2017      -__osconfig_eita_mgmt-0.1.12__      `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Corrected rsyslog.conf.new.el.erb template conditionals again.  This time I realized the "@" symbol was missing in front of collector_ip; which is mandatory.

08/31/2017     -__osconfig_eita_mgmt-0.1.11__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Corrected rsyslog.conf.new.el.erb conditionals testing for data.  I forgot the necessary/required % for the tags.

08/31/2017     -__osconfig_eita_mgmt-0.1.10__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Rev-0.1.9 was a major improvement focused specifically on the delivery of the auditd.conf file, and it was correct finally.  All of the other ERB-templates were updating
         accordingly and the 'empty' variable test was inserted into the rsyslog.conf ERB-template too.

08/31/2017      -__osconfig_eita_mgmt-0.1.9__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Rev-0.1.8 finally generated a proper auditd.conf file __BUTTTT__ with the extra text from the first line of the ERB-template.  Removing line numbers 1 and 2; testing again.

08/31/2017      -__osconfig_eita_mgmt-0.1.8__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Added back the #{ and }` everywhere.

08/31/2017      -__osconfig_eita_mgmt-0.1.7__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Still not working so I am adding a variable-date insertion to see if logic with concatenated variables doesn't work at all.

08/30/2017      -__osconfig_eita_mgmt-0.1.6__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Still not working with the ERB-templates.  Trying without the #{ and }` now.

08/30/2017      -__osconfig_eita_mgmt-0.1.5__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Discovered the conditional was comparing against "rhel" and it should have been comparing against "redhat" instead.  I keep making this mistake too.

08/30/2017      -__osconfig_eita_mgmt-0.1.4__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Added back the double-quotes and some extra syntax such as #{...}` to the facts being used for coditionals.

08/30/2017      -__osconfig_eita_mgmt-0.1.3__       `-Addresses={DR#2996454}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Removed "" from the ERB-template for the auditd.conf file.  Testing to see if it fixes the delivery problem of a zeroed-out file.

08/30/2017      -__osconfig_eita_mgmt-0.1.2__       `-Addresses={all prior DRs for both baseline_audit_mgmt and baseline_rsyslog_mgmt}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Added RHEL7-specific audit rules to the appropriate template.  Found some corrections before they presented themselves, within the implement.pp file (wheh!).  Added audit-local4.sh script cronjob
         and with stderr/stdout redirection as A51 requests.  Corrected the ERB-templates that used a string comparison against a concatenation of 2-variables.

08/18/2017      -__osconfig_eita_mgmt-0.1.1__       `-Addresses={all prior DRs for both baseline_audit_mgmt and baseline_rsyslog_mgmt}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Corrected metadata.json file to __REQUIRE__ the customfacts module.  New technique I am implementing with an old technology.

08/11/2017      -__osconfig_eita_mgmt-0.1.0__       `-Addresses={all prior DRs for both baseline_audit_mgmt and baseline_rsyslog_mgmt}`       -BITS=2842.57113_OSCONFIG_EITA_MGMT_1_0.0000.1          -WFrench;
        Initial build of the new module in the new "namespace" as consolidated; with only auditd.conf and PARTOF audit.rules in place.  I need to work in EITA-specific extra AUDIT rules, if there are any.

