# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
class osconfig_eita_mgmt::implement (
  $collector_ip = undef
  ) {
  case "${os_brand}-${os_revision}-${mas_is_vda}-${os_product}" {
     'redhat-7-vda-server': {
        file { '/etc/audit/auditd.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/auditd.new.el.erb'),
        }
        
        file { '/etc/audit/rules.d/':
          ensure   => 'directory',
          owner    => '0',
          group    => '0',
          mode     => '0750',
          purge    => 'true',
          recurse  => 'true',
        }
        
        file { '/etc/audit/rules.d/audit.rules':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rules.new.el.erb'),
        }
        
        file { '/usr/local/sbin/auditd.cron':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'unconfined_u',
          content  => template('osconfig_eita_mgmt/cron.new.el.erb'),
        }
        
        cron { 'Rollover_auditLogs_at_midnight':
          ensure  => 'present',
          command => '/usr/local/sbin/auditd.cron >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '0',
          minute  => '0',
        }
        
        service { 'auditd':
          ensure => 'running',
          enable => 'true',
        }

        file { '/usr/local/bin/audit-local4.sh':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/audit-local4.sh.new.el.erb'),
        }

        cron { 'Forward_audit_events':
          ensure  => 'present',
          command => 'sh /usr/local/bin/audit-local4.sh >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '*',
          minute  => '*/10',
        }

        exec { 'system-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/system-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/system-auth-ac 2>/dev/null',
        }

        exec { 'password-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/password-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/password-auth-ac 2>/dev/null',
        }

        file { '/etc/rsyslog.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0644',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'syslog_conf_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rsyslog.conf.new.el.erb'),
        }
        
        service { 'rsyslog':
          ensure    => 'running',
          enable    => 'true',
          subscribe => File['/etc/rsyslog.conf'],
        }
     }  # apply changes for redhat-7-vda-server

     'redhat-7-not_vda-server': {
        file { '/etc/audit/auditd.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/auditd.new.el.erb'),
        }
        
        file { '/etc/audit/rules.d/':
          ensure   => 'directory',
          owner    => '0',
          group    => '0',
          mode     => '0750',
          purge    => 'true',
          recurse  => 'true',
        }
        
        file { '/etc/audit/rules.d/audit.rules':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rules.new.el.erb'),
        }
        
        file { '/usr/local/sbin/auditd.cron':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'unconfined_u',
          content  => template('osconfig_eita_mgmt/cron.new.el.erb'),
        }
        
        cron { 'Rollover_auditLogs_at_midnight':
          ensure  => 'present',
          command => '/usr/local/sbin/auditd.cron >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '0',
          minute  => '0',
        }
        
        service { 'auditd':
          ensure => 'running',
          enable => 'true',
        }

        file { '/usr/local/bin/audit-local4.sh':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/audit-local4.sh.new.el.erb'),
        }

        cron { 'Forward_audit_events':
          ensure  => 'present',
          command => 'sh /usr/local/bin/audit-local4.sh >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '*',
          minute  => '*/10',
        }

        exec { 'system-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/system-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/system-auth-ac 2>/dev/null',
        }

        exec { 'password-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/password-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/password-auth-ac 2>/dev/null',
        }

        file { '/etc/rsyslog.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0644',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'syslog_conf_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rsyslog.conf.new.el.erb'),
        }
        
        service { 'rsyslog':
          ensure    => 'running',
          enable    => 'true',
          subscribe => File['/etc/rsyslog.conf'],
        }
     }  # apply changes for redhat-7-not_vda-server

     'redhat-7-not_vda-client', 'redhat-7-not_vda-workstation': {
        file { '/etc/audit/auditd.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/auditd.new.el.erb'),
        }
        
        file { '/etc/audit/rules.d/':
          ensure   => 'directory',
          owner    => '0',
          group    => '0',
          mode     => '0750',
          purge    => 'true',
          recurse  => 'true',
        }
        
        file { '/etc/audit/rules.d/audit.rules':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rules.new.el.erb'),
        }
        
        file { '/usr/local/sbin/auditd.cron':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'unconfined_u',
          content  => template('osconfig_eita_mgmt/cron.new.el.erb'),
        }
        
        cron { 'Rollover_auditLogs_at_midnight':
          ensure  => 'present',
          command => '/usr/local/sbin/auditd.cron >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '0',
          minute  => '0',
        }
        
        service { 'auditd':
          ensure => 'running',
          enable => 'true',
        }

        file { '/usr/local/bin/audit-local4.sh':
          ensure   => 'absent',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/audit-local4.sh.new.el.erb'),
        }

        cron { 'Forward_audit_events':
          ensure  => 'absent',
          command => 'sh /usr/local/bin/audit-local4.sh >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '*',
          minute  => '*/10',
        }

        exec { 'system-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/system-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/system-auth-ac 2>/dev/null',
        }

        exec { 'password-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/password-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/password-auth-ac 2>/dev/null',
        }

        file { '/etc/rsyslog.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0644',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'syslog_conf_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rsyslog.conf.new.el.erb'),
        }
        
        service { 'rsyslog':
          ensure    => 'running',
          enable    => 'true',
          subscribe => File['/etc/rsyslog.conf'],
        }
     }  # apply changes for redhat-7-not_vda-client, 'redhat-7-not_vda-workstation'
#
#
#
#
#
     'redhat-6-vda-server': {
        file { '/etc/audit/auditd.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/auditd.new.el.erb'),
        }
        
        file { '/etc/audit/rules.d/':
          ensure   => 'absent',
          owner    => '0',
          group    => '0',
          mode     => '0750',
          purge    => 'true',
          force    => 'true',
          recurse  => 'true',
        }
        
        file { '/etc/audit/audit.rules':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rules.new.el.erb'),
        }
        
        file { '/usr/local/sbin/auditd.cron':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'unconfined_u',
          content  => template('osconfig_eita_mgmt/cron.new.el.erb'),
        }
        
        cron { 'Rollover_auditLogs_at_midnight':
          ensure  => 'present',
          command => '/usr/local/sbin/auditd.cron >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '0',
          minute  => '0',
        }
        
        service { 'auditd':
          ensure => 'running',
          enable => 'true',
        }

        file { '/usr/local/bin/audit-local4.sh':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/audit-local4.sh.new.el.erb'),
        }

        cron { 'Forward_audit_events':
          ensure  => 'present',
          command => 'sh /usr/local/bin/audit-local4.sh >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '*',
          minute  => '*/10',
        }

        exec { 'system-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/system-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/system-auth-ac 2>/dev/null',
        }

        exec { 'password-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/password-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/password-auth-ac 2>/dev/null',
        }

        file { '/etc/rsyslog.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0644',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'syslog_conf_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rsyslog.conf.new.el.erb'),
        }
        
        service { 'rsyslog':
          ensure    => 'running',
          enable    => 'true',
          subscribe => File['/etc/rsyslog.conf'],
        }
     }  # apply changes for redhat-6-vda-server

     'redhat-6-not_vda-server': {
        file { '/etc/audit/auditd.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/auditd.new.el.erb'),
        }
        
        file { '/etc/audit/rules.d/':
          ensure   => 'absent',
          owner    => '0',
          group    => '0',
          mode     => '0750',
          purge    => 'true',
          force    => 'true',
          recurse  => 'true',
        }
        
        file { '/etc/audit/audit.rules':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rules.new.el.erb'),
        }
        
        file { '/usr/local/sbin/auditd.cron':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'unconfined_u',
          content  => template('osconfig_eita_mgmt/cron.new.el.erb'),
        }
        
        cron { 'Rollover_auditLogs_at_midnight':
          ensure  => 'present',
          command => '/usr/local/sbin/auditd.cron >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '0',
          minute  => '0',
        }
        
        service { 'auditd':
          ensure => 'running',
          enable => 'true',
        }

        file { '/usr/local/bin/audit-local4.sh':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/audit-local4.sh.new.el.erb'),
        }

        cron { 'Forward_audit_events':
          ensure  => 'present',
          command => 'sh /usr/local/bin/audit-local4.sh >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '*',
          minute  => '*/10',
        }

        exec { 'system-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/system-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/system-auth-ac 2>/dev/null',
        }

        exec { 'password-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/password-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/password-auth-ac 2>/dev/null',
        }

        file { '/etc/rsyslog.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0644',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'syslog_conf_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rsyslog.conf.new.el.erb'),
        }
        
        service { 'rsyslog':
          ensure    => 'running',
          enable    => 'true',
          subscribe => File['/etc/rsyslog.conf'],
        }
     }  # apply changes for redhat-6-not_vda-server

     'redhat-6-not_vda-client', 'redhat-6-not_vda-workstation': {
        file { '/etc/audit/auditd.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/auditd.new.el.erb'),
        }
        
        file { '/etc/audit/rules.d/':
          ensure   => 'absent',
          owner    => '0',
          group    => '0',
          mode     => '0750',
          purge    => 'true',
          force    => 'true',
          recurse  => 'true',
        }
        
        file { '/etc/audit/audit.rules':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0640',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'auditd_etc_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rules.new.el.erb'),
        }
        
        file { '/usr/local/sbin/auditd.cron':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'unconfined_u',
          content  => template('osconfig_eita_mgmt/cron.new.el.erb'),
        }
        
        cron { 'Rollover_auditLogs_at_midnight':
          ensure  => 'present',
          command => '/usr/local/sbin/auditd.cron >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '0',
          minute  => '0',
        }
        
        service { 'auditd':
          ensure => 'running',
          enable => 'true',
        }

        file { '/usr/local/bin/audit-local4.sh':
          ensure   => 'absent',
          owner    => '0',
          group    => '0',
          mode     => '0700',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'bin_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/audit-local4.sh.new.el.erb'),
        }

        cron { 'Forward_audit_events':
          ensure  => 'absent',
          command => 'sh /usr/local/bin/audit-local4.sh >>/var/log/cron-audit.log 2>&1',
          user    => root,
          hour    => '*',
          minute  => '*/10',
        }

        exec { 'system-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/system-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/system-auth-ac 2>/dev/null',
        }

        exec { 'password-auth-ac_appendment':
          path    => "/usr/bin:/usr/sbin:/bin:/sbin",
          command => 'echo "session     required      pam_tty_audit.so     disable=*      enable=*" >> /etc/pam.d/password-auth-ac',
          unless  => 'egrep "session\s{5}required\s{6}pam_tty_audit.so" /etc/pam.d/password-auth-ac 2>/dev/null',
        }

        file { '/etc/rsyslog.conf':
          ensure   => 'file',
          owner    => '0',
          group    => '0',
          mode     => '0644',
          selrange => 's0',
          selrole  => 'object_r',
          seltype  => 'syslog_conf_t',
          seluser  => 'system_u',
          content  => template('osconfig_eita_mgmt/rsyslog.conf.new.el.erb'),
        }
        
        service { 'rsyslog':
          ensure    => 'running',
          enable    => 'true',
          subscribe => File['/etc/rsyslog.conf'],
        }
     }  # apply changes for redhat-6-not_vda-client, redhat-6-not_vda-workstation
  } # End Case-statement
}
