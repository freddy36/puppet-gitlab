class gitlab::gitlab_runner::repo {
  include apt
  include gitlab::repokey
  apt::source {'runner_gitlab-runner':
    comment  => 'Gitlab Runner repositories',
    location => 'https://packages.gitlab.com/runner/gitlab-runner/debian/',
    repos    => 'main',
    require  => [Apt::Key['gitlab']],
  }
}
