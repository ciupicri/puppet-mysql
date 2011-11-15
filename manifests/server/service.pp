class mysql::server::service($enable = true) {
    service { "mysqld":
        ensure  => $enable,
        require => Class["mysql::server::config"],
    }
}
