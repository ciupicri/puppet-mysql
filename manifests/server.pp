class mysql::server($enable = true) {
    include install, config
    class { "service": enable => $enable }

    # Collect all databases and users
    Mysql_database<<| tag == "mysql_${fqdn}" |>>
    Mysql_user<<| tag == "mysql_${fqdn}"  |>>
    Mysql_grant<<| tag == "mysql_${fqdn}" |>>
}
