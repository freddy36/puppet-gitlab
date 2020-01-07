class gitlab::gitlab_runner {
  include gitlab::gitlab_runner::repo

  if($::osfamily != 'debian') {
    fail('only debian is supported for now')
  }

  package {'gitlab-runner':
    ensure  => latest,
    require => [Class['apt::update'], Apt::Source['runner_gitlab-runner']],
  }

  service { 'gitlab-runner':
    ensure  => running,
    enable  => true,
    require => Package['gitlab-runner']
  }
}
