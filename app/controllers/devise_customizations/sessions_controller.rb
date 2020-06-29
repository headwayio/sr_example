module DeviseCustomizations
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token,
                       only: [:create, :destroy],
                       if: -> { json_request? }

    def create
      super and return unless json_request?

      user = warden.authenticate!(auth_options)
      token = Tiddle.create_and_return_token(user, request)
      auth_token = Tiddle::TokenIssuer.build.find_token(user, token)
      auth_token.unencrypted_token = token

      token_resource = Api::V1::AuthenticationTokenResource.new(auth_token, nil)
      json = JSONAPI::ResourceSerializer
        .new(Api::V1::AuthenticationTokenResource)
        .serialize_to_hash(token_resource)

      render json:
        json.merge(
          meta: {
            authentication_token: token,
          },
        )
    end

    def destroy
      super and return unless json_request?

      Tiddle.expire_token(current_user, request) if current_user
      render json: {}
    end

    private

    # This is invoked before destroy and we have to override it
    def verify_signed_out_user; end

    def json_request?
      %i[api_json json].include?(request.format.to_sym)
    end
  end
end
