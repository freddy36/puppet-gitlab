class gitlab::gitlab_ce::config (
  String $external_domain = $facts['fqdn'],
  Optional[String] $gitlab_ssh_host = undef,
  Boolean $use_ldap = false,
  Optional[String] $ldap_server = undef,
  Integer $ldap_port = 389,
  String $ldap_uid_field = 'sAMAccountName',
  String $ldap_method = 'tls',
  Optional[String] $ldap_bind_dn = undef,
  Optional[String] $ldap_bind_password = undef,
  Boolean $ldap_active_directory = true,
  Optional[String] $ldap_base_dn = undef,
  String $ldap_filter = '',
) {
  file { '/etc/gitlab/gitlab_http.rb':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('gitlab/gitlab_config.epp', {
      external_domain => $external_domain,
      use_https       => false,
    }),
    require => [Package['gitlab-ce'], File['/opt/gitlab/embedded/html/letsencrypt']],
    notify  => Exec['gitlab_temp_symlink_http'],
  }

  exec { 'gitlab_temp_symlink_http':
    command => '/bin/ln -sfn gitlab_http.rb gitlab.rb',
    cwd     => '/etc/gitlab',
    require => Package['gitlab-ce'],
    creates => "/etc/letsencrypt/live/${external_domain}/fullchain.pem",
    notify  => Exec['gitlab_ctl_reconfigure_http'],
  }

  exec { 'gitlab_ctl_reconfigure_http':
    command     => '/usr/bin/gitlab-ctl reconfigure',
    refreshonly => true,
    require     =>   File['/etc/gitlab/gitlab_http.rb'],
    before      => Exec['gitlab_ctl_reconfigure'],
  }


  file { '/etc/gitlab/gitlab_https.rb':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('gitlab/gitlab_config.epp', {
      external_domain       => $external_domain,
      gitlab_ssh_host       => $gitlab_ssh_host,
      use_https             => true,
      use_ldap              => true,
      ldap_server           => $ldap_server,
      ldap_port             => $ldap_port,
      ldap_uid_field        => $ldap_uid_field,
      ldap_method           => $ldap_method,
      ldap_bind_dn          => $ldap_bind_dn,
      ldap_bind_password    => $ldap_bind_password,
      ldap_active_directory => $ldap_active_directory,
      ldap_base_dn          => $ldap_base_dn,
      ldap_filter           => $ldap_filter,
    }),
    require => [Package['gitlab-ce'], File['/opt/gitlab/embedded/html/letsencrypt']],
    notify  => Exec['gitlab_ctl_reconfigure'],
  }

  file { '/etc/gitlab/gitlab.rb':
    ensure  => link,
    target  => 'gitlab_https.rb',
    notify  => Exec['gitlab_ctl_reconfigure'],
    require => [Package['gitlab-ce'], File['/etc/gitlab/gitlab_https.rb']],
  }

  exec { 'gitlab_ctl_reconfigure':
    command     => '/usr/bin/gitlab-ctl reconfigure',
    refreshonly => true,
  }
}
