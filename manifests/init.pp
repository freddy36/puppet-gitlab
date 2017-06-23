class gitlab {
  include apt
  include letsencrypt
  include gitlab::config
  include gitlab::repo
  include gitlab::letsencrypt

  if($::osfamily != 'debian') {
    fail('only debian is supported for now')
  }
}
