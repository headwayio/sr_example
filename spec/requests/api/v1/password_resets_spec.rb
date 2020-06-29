require 'rails_helper'

RSpec.describe DeviseCustomizations::PasswordsController, type: :request, order: :defined do
  let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

  describe 'POST /password_resets' do
    it 'sends a password reset email' do
      params = {
        "data" => {
          type: 'password_reset',
          "attributes" => {
            email: user.email,
          },
        },
      }

      post api_v1_password_resets_path, params: params
      expect_status "200"
    end
  end
end
