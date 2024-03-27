# Define class for Nginx installation and configuration
class nginx {
    # Install Nginx package
    package { 'nginx':
        ensure => installed,
    }

    # Define Nginx service
    service { 'nginx':
        ensure  => running,
        enable  => true,
        require => Package['nginx'],
    }

    # Configure Nginx to listen on port 80
    file { '/etc/nginx/sites-available/default':
        ensure  => file,
        content => template('nginx/default.erb'),
        notify  => Service['nginx'],
    }
}

# Define content for the Nginx default configuration file
file { '/etc/nginx/sites-available/default':
    content => "server {
        listen 80;
        root /var/www/html;
        index index.html index.htm;
        
        location / {
            return 301 /redirect_me;
        }
        
        location /redirect_me {
            return 301 https://www.example.com;
        }

        location /hello {
            return 200 'Hello, World!';
        }
    }",
    require => Class['nginx'],
}

# Notify Nginx service to reload configuration after changes
service { 'nginx':
    subscribe => File['/etc/nginx/sites-available/default'],
}
