require 'rails_helper'

RSpec.describe Api::V1::Users::PasswordsController, type: :request, order: :defined do
  let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

  before { authenticate(user) }

  describe 'PATCH /users/passwords/:id' do
    it 'lists all users' do
      params = {
        data: {
          type: 'passwords',
          id: user.id,
          attributes: {
            current_password: 'password',
            password: 'password2',
            password_confirmation: 'password2',
          },
        },
      }

      authed_patch api_v1_users_password_path(user.id), params
      expect_status "200"
    end
  end
end
