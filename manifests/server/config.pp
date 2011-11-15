class mysql::server::config {
    case $mysql_rootpw {
        '': { fail("You need to define a mysql root password! Please set \$mysql_rootpw in your site.pp or host config") }
    }

    Config_file {
        require => Class["mysql::server::install"],
        notify  => Class["mysql::server::service"],
    }

    config_file { "/etc/my.cnf":
        source => "/etc/my.cnf",
    }

    file { "/root/.my.cnf":
        content => template("${caller_module_name}/root/my.cnf.erb"),
        require => Class["mysql::server::install"],
        owner   => "root",
        group   => "root",
        mode    => "0400",
        notify  => Exec['mysql_set_rootpw'],
    }

    file { "mysql_setmysqlpass.sh":
        path => "/usr/local/sbin/setmysqlpass.sh",
        source => $operatingsystem ? {
            "Scientific" => "puppet:///modules/${caller_module_name}/scripts/EL/setmysqlpass.sh",
            "CentOS"     => "puppet:///modules/${caller_module_name}/scripts/EL/setmysqlpass.sh",
            default      => "puppet:///modules/${caller_module_name}/scripts/${operatingsystem}/setmysqlpass.sh",
        },
        owner => "root",
        group => "root",
        mode  => 0500;
    }

    exec { "mysql_set_rootpw":
        command     => "/usr/local/sbin/setmysqlpass.sh",
        unless      => "mysqladmin -uroot status > /dev/null",
        require     => [File["mysql_setmysqlpass.sh"],
                        Class["mysql::server::install"]],
        refreshonly => true,
    }

    #file { "/root/mysql-init.sql":
    #    content => template("${caller_module_name}/root/mysql-init.sql.erb"),
    #    owner => "root",
    #    group => "root",
    #    mode => "0400",
    #    require => Class["mysql::server::install"],
    #}
}
