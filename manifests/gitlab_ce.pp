class gitlab::gitlab_ce {
  include gitlab::gitlab_ce::repo
  include gitlab::gitlab_ce::config
  include gitlab::gitlab_ce::letsencrypt

  package {'gitlab-ce':
    ensure  => latest,
    require => [Class['apt::update'], Apt::Source['gitlab_gitlab-ce']],
    notify  => Exec['gitlab_ctl_reconfigure'],
  }

  if($::osfamily != 'debian') {
    fail('only debian is supported for now')
  }
}
