class gitlab::gitlab_ci_multi_runner::repo {
  include apt
  include gitlab::repokey
  apt::source {'gitlab_ci_multi_runner':
    comment  => 'Gitlab Runner repositories',
    location => 'https://packages.gitlab.com/runner/gitlab-ci-multi-runner/debian/',
    repos    => 'main',
    require  => [Apt::Key['gitlab']],
  }
}
