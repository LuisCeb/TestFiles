nginx::resource::upstream {
	'Cluster1'	=>
		ensure 	=> 	present,
		members =>	['10.10.10.10'],
		upstream_fail_timeout	=> '10s',
		upstream_max_fails		=> '5',
	'Cluster2'	=>
		ensure 	=>	present,
		members	=>	['20.20.20.20'],
		upstream_fail_timeout	=> '10s',
		upstream_max_fails		=> '5',
	}
	
nginx::resource::server {'domain.com':
		server_name	=>	['domain.com'],
		proxy		=>	'http://Cluster1',
		ssl			=>	true,
		ssl_cert	=>	'/service/data/certs/domain.com.crt',
		ssl_key		=>	'/service/data/certs/privatekey/domain.com.key',
		listen_port	=> 	'443',
		ssl_port	=>	'443',
		require => File['/service/data/certs/domain.com.crt', '/service/data/certs/privatekey/domain.com.key'],
		}
		
nginx::resource::location {'resource2':
        location	=>	'~ ^/resource2(.*)$',
        proxy		=>	'http://Cluster2/$1',
        ssl_only	=>	true,
		}
		
nginx::resource::server {'proxy.domain.com':
	server_name	=>	['forward.domain.com'],
    listen_port	=>	8080,
    resolver	=>	['8.8.8.8','8.8.4.4'],
    proxy		=> 'http://$http_host$uri$is_args$args',
    format_log	=> 'proxy_log',
    
nginx::log_format {
	'proxy_log'=> '$remote_addr	$request  $request_time  - $status $http_referer'
	}
	
file { 'domain.com.crt':
	ensure  => present,
	path    => '/service/data/certs/domain.com.crt',
	source  => 'puppet:///modules/apache/ssl/certs/domain.com.crt',
	}
	
file { 'domain.com.key':
	ensure  => present,
	path    => '/service/data/certs/privatekey/domain.com.key',
	source  => 'puppet:///modules/apache/ssl/certs/privatekey/domain.com.key',
	}