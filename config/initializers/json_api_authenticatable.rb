require 'devise/strategies/database_authenticatable'

module Devise
  module Strategies
    class JsonApiAuthenticatable < DatabaseAuthenticatable
      private

      def params_auth_hash
        hash = params.fetch(:data, {}).fetch(:attributes, nil) || params
        hash.slice(:email, :password)
      end
    end
  end
end

Warden::Strategies.add(
  :unwrapped_authenticatable,
  Devise::Strategies::JsonApiAuthenticatable,
)
