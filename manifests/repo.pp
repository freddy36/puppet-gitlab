class gitlab::repo {
  apt::key {'gitlab-ce':
    id     => '1A4C919DB987D435939638B914219A96E15E78F4',
    server => 'pool.sks-keyservers.net',
  }

  apt::source {'gitlab_gitlab-ce':
    comment  => 'Gitlab repositories',
    location => 'https://packages.gitlab.com/gitlab/gitlab-ce/debian/',
    repos    => 'main',
    require  => [Apt::Key['gitlab-ce']],
  }

  package {'gitlab-ce':
    ensure  => latest,
    require => [Class['apt::update'], Apt::Source['gitlab_gitlab-ce']],
    notify  => Exec['gitlab_ctl_reconfigure'],
  }
}
