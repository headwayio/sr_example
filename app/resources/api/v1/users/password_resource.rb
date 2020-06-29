module Api
  module V1
    module Users
      class PasswordResource < JSONAPI::Resource
        model_name 'User'
        attributes :password,
                  :password_confirmation,
                  :current_password

        def fetchable_fields
          super - [:password, :password_confirmation, :current_password]
        end
      end
    end
  end
end
