class f5_profile::nodes {

  @@f5_node { "/Common/${ec2_instance_id}":
    ensure                   => 'present',
    address                  => $ipaddress,
    description              => "Puppet Exported Server $${ec2_instance_id}",
    availability_requirement => 'all',
    health_monitors          => ['/Common/icmp'],
  }

}
