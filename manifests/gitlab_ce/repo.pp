class gitlab::gitlab_ce::repo {
  include apt
  include gitlab::repokey
  apt::source {'gitlab_gitlab-ce':
    comment  => 'Gitlab repositories',
    location => 'https://packages.gitlab.com/gitlab/gitlab-ce/debian/',
    repos    => 'main',
    require  => [Apt::Key['gitlab']],
  }

}
