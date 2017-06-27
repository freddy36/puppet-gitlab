class gitlab::repokey {
  apt::key {'gitlab':
    id     => '1A4C919DB987D435939638B914219A96E15E78F4',
    server => 'pool.sks-keyservers.net',
  }
}
