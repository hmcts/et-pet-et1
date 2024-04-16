### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /admin/password by IP address
Rack::Attack::throttle('admin_password_resets/ip', limit: 5, period: 15.minutes) do |req|
    if req.path == '/apply/admin/password' && req.post?
      req.ip
    end
  end

  Rack::Attack.throttled_responder = lambda do |request|
    if request.env['rack.attack.matched'] == 'admin_password_resets/ip'
      [302, { 'Location' => '/apply/admin/login' }, [""]]
    else
      [429, { 'content-type' => 'text/plain' }, ["Retry later\n"]]
    end
  end
