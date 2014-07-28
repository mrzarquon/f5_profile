class f5_profile::example {
  f5_v11_vlan {['VLAN09','VLAN10','VLAN11','VLAN12','VLAN13','VLAN14','VLAN15','VLAN16','VLAN17','VLAN18','VLAN19','VLAN20','VLAN21']:
    ensure    => present,
    vlan_tag  => 'auto',
    interface => '1.3',
  }

  f5_v11_vlan {'VLAN22':
    ensure => absent,
  }

  f5_v11_vlan {'VLAN08':
    ensure      => present,
    vlan_tag    => '08',
    interface   => '1.2',
    description => 'Test VLAN08',
    tag_type    => 'tagged',
  }

  f5_v11_node {'test_node_0':
    ensure      => present,
    ipaddress   => '192.168.62.110',
    description => "This is our test node 0",
  }

  f5_v11_node {'test_node_1':
    ensure      => present,
    ipaddress   => '192.168.62.111',
    description => "This is our test node 1",
    state       => 'user-up',
    session     => 'user-enabled',
  }

  f5_v11_node {'test_node_2':
    ensure        => present,
    ipaddress     => '192.168.62.112',
    description   => "This is our test node 2",
    state         => 'user-up',
    session       => 'user-enabled',
    dynamic_ratio => 2 ,
  }

  f5_v11_node {'test_node_3':
    ensure      => present,
    ipaddress   => '192.168.62.113',
    description => "This is our test node 3",
    state       => 'user-up',
    session     => 'user-enabled',
  }

  f5_v11_pool {'test_pool_0':
    ensure           => present,
    members          => ['test_node_0:80','test_node_1:80'],
    description      => "A test pool",
    lb_method        => 'fastest-node',
    allow_nat_state  => 'yes',
    allow_snat_state => 'no',
    require          => [F5_v11_node['test_node_0'],F5_v11_node['test_node_1']],
  }

  f5_v11_pool {'test_pool_1':
    ensure                  => present,
    description             => 'This is the description of the pool',
    action_on_service_down  => 'reset',
    allow_nat_state         => 'no',
    allow_snat_state        => 'yes',
    client_ip_tos           => 'pass-through',
    client_link_qos         => '2',
    lb_method               => 'fastest-node',
    members                 => ['test_node_2:80','test_node_3:80'],
    server_ip_tos           => '5',
    server_link_qos         => 'pass-through',
    slow_ramp_time          => '10',
    require                 => [F5_v11_node['test_node_2'],F5_v11_node['test_node_3']],
  }

  f5_v11_virtualserver {"test_virtual_server_0":
    ensure      => present,
    destination => '192.168.111.2',
    port        => '8281',
    pool        => 'test_pool_1',
    protocol    => 'tcp',
  }

}
