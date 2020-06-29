module Api
  module V1
    class AuthenticationTokenResource < BaseResource
      attributes :user_id, :unencrypted_token

      # has_one :user,
      #         class_name: 'User',
      #         foreign_key: 'user_id',
      #         always_include_linkage_data: false
    end
  end
end
