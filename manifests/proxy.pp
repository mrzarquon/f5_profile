class f5_profile::proxy (
  $username = 'admin',
  $password = 'puppetlabs',
  $devfqdn = 'f5.puppetlabs.demo',
  $deviceconf = '/etc/puppetlabs/puppet/device.conf',
) {

  # we need to create the bigip configuration
  # luckily it is an ini-esque file

  package { 'faraday':
    ensure   => present,
    provider => 'pe_gem',
    notify   => Service['pe-puppetserver'],
  }


  ini_setting { 'bigip_type':
    ensure            => present,
    path              => $deviceconf,
    section           => $devfqdn,
    setting           => 'type',
    value             => 'f5',
    key_val_separator => ' ',
  }
  ini_setting { 'bigip_url':
    ensure            => present,
    path              => $deviceconf,
    section           => $devfqdn,
    setting           => 'url',
    value             => "https://${username}:${password}@${devfqdn}/",
    key_val_separator => ' ',
  }

  file { $deviceconf:
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
  }


}
