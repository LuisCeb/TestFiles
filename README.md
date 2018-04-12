This module is written to be used with https://github.com/voxpupuli/puppet-nginx

I started creating two clusters, one for each server, 
to make easier adding more servers for each part of the aplication.
Then I created the virtual host for the main domain forwarding the request to the first cluster,
and a location for the extra resources to the second cluster. With the fail_timeaout and max_fails statements 
we can control the status of the upstreams, and if we add more servers to the cluster, we can add also the 
slow_start statement to give the servers time to recover from an overload.

For the forward proxy, I never did think that nginx can be used, but after a bit of research I found something 
that could work, and I wrote it for puppet+nginx.
