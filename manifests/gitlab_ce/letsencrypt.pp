class gitlab::gitlab_ce::letsencrypt {
  include letsencrypt

  file { '/opt/gitlab/embedded/html/letsencrypt':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['gitlab-ce'],
  }

  letsencrypt::certonly { 'gitlab':
    domains              => [$gitlab::gitlab_ce::config::external_domain],
    plugin               => 'webroot',
    webroot_paths        => ['/opt/gitlab/embedded/html/letsencrypt'],
    manage_cron          => true,
    cron_success_command => '/usr/bin/gitlab-ctl hup nginx',
    suppress_cron_output => true,
    require              => File['/opt/gitlab/embedded/html/letsencrypt'],
    before               => File['/etc/gitlab/gitlab.rb'],
  }
}
