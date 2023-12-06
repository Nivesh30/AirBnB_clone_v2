# Ensure Nginx package is installed
package { 'nginx':
  ensure => installed,
}

# Ensure required directories exist
file { '/data':
  ensure => directory,
}

file { '/data/web_static':
  ensure => directory,
}

file { '/data/web_static/releases':
  ensure => directory,
}

file { '/data/web_static/shared':
  ensure => directory,
}

file { '/data/web_static/releases/test':
  ensure => directory,
}

# Create a fake HTML file for testing
file { '/data/web_static/releases/test/index.html':
  content => '<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>',
}

# Create or recreate the symbolic link
file { '/data/web_static/current':
  ensure  => link,
  target  => '/data/web_static/releases/test',
  require => File['/data/web_static/releases/test/index.html'],
}

# Change ownership of the /data/ folder recursively to ubuntu user and group
exec { 'change_ownership':
  command => 'chown -R ubuntu:ubuntu /data/',
  path    => ['/bin', '/usr/bin/'],
}

# Update Nginx configuration
file { '/etc/nginx/sites-available/default':
  content => template('path/to/nginx_template.erb'),
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Restart Nginx
service { 'nginx':
  ensure    => running,
  enable    => true,
  subscribe => File['/etc/nginx/sites-available/default'],
}
