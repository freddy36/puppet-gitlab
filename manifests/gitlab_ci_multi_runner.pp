class gitlab::gitlab_ci_multi_runner {
  include gitlab::gitlab_ci_multi_runner::repo

  if($::osfamily != 'debian') {
    fail('only debian is supported for now')
  }

  package {'gitlab-ci-multi-runner':
    ensure  => latest,
    require => [Class['apt::update'], Apt::Source['gitlab_ci_multi_runner']],
  }

  service { 'gitlab-runner':
    ensure => running,
    enable => true,
    require => Package['gitlab-ci-multi-runner']
  }
}
