class TokenBuilder
  def self.build(user, request)
    token = Tiddle.create_and_return_token(user, request)
    auth_token = Tiddle::TokenIssuer.build.find_token(user, token)
    [token, auth_token]
  end
end
