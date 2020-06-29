module HttpHelpers
  def authenticate(user)
    request = double(remote_ip: '127.0.0.1', user_agent: 'RSpec') # rubocop:disable RSpec/VerifiedDoubles, Metrics/LineLength
    @user = user
    @authentication_token = Tiddle.create_and_return_token(user, request)
  end

  def authed_get(endpoint, opts = {})
    get endpoint,
        headers: auth_header(opts),
        params: opts[:params],
        xhr: true
  end

  def authed_post(endpoint, opts = {})
    post endpoint,
         params: opts,
         headers: auth_header(opts),
         as: :json
  end

  def authed_patch(endpoint, opts = {})
    patch endpoint,
          params: opts,
          headers: auth_header(opts),
          xhr: true,
          as: :json
  end

  def authed_delete(endpoint, opts = {})
    delete endpoint,
           headers: auth_header(opts),
           xhr: true,
           as: :json
  end

  private

  def auth_header(opts)
    headers = {
      'X-User-Email' => @user.email,
      'X-User-Token' => @authentication_token,
    }
    headers.merge!(opts[:headers]) if opts[:headers]
    headers
  end
end

RSpec.configure do |config|
  config.include HttpHelpers
end
