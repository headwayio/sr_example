module Api
  module V1
    class UserResource < BaseResource
      attributes :first_name,
                 :last_name,
                 :email,
                 :birthdate,
                 :roles,
                 :password,
                 :password_confirmation,
                 :photo_url,
                 :photo_data_uri,
                 :unencrypted_token

      after_create :create_authorization_token

      def create_authorization_token
        token, _auth_token = TokenBuilder.build(@model, context[:request])
        @model.unencrypted_token = token
      end

      def fetchable_fields
        super - [:password, :password_confirmation]
      end
    end
  end
end
