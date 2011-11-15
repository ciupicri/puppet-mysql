class mysql::server::install {
    package { "mysql-server":
        ensure => installed,
    }
}
