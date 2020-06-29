require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request, order: :defined do
  let(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let(:user_attributes) do
    {
      email: user.email,
    }
  end

  before { authenticate(admin) }

  describe 'GET /users' do
    it 'lists all users' do
      authed_get api_v1_users_path
      expect_attributes_in_list(user_attributes)
    end
  end

  describe 'GET /users/:id' do
    it 'gets a specific user' do
      authed_get api_v1_user_path(user)
      expect_attributes(user_attributes)
    end
  end

  describe 'POST /users' do
    email = {
      email: 'test@example.com',
    }

    context 'when successful' do
      it 'creates a user' do
        params = {
          data: {
            type: 'users',
            attributes: {
              password: 'password',
              password_confirmation: 'password',
            }.merge(email),
          },
        }

        authed_post api_v1_users_path, params

        expect_attributes(email)
      end
    end

    context 'when unsuccessful' do
      it 'does not create a user' do
        params = {
          data: {
            type: 'users',
            attributes: {
              password: 'password',
              password_confirmation: 'password2',
            },
          },
        }

        authed_post api_v1_users_path, params

        expect_status :unprocessable_entity

        expect_error_text("password_confirmation - doesn't match Password")
        expect_error_text("email - Can't be blank")
        expect_error_text('email - is invalid')
      end
    end
  end

  describe 'PATCH /users/:id' do
    context 'when successful' do
      it 'updates the user' do
        params = {
          data: {
            id: user.id,
            type: 'users',
            attributes: {
              email: 'new@example.com',
            },
          },
        }

        authed_patch api_v1_user_path(user.id), params

        expect_attributes(email: 'new@example.com')
      end
    end

    context 'when unsuccessful' do
      it 'does not update the user' do
        params = {
          data: {
            id: user.id,
            type: 'users',
            attributes: {
              email: '',
            },
          },
        }

        authed_patch api_v1_user_path(user.id), params

        expect_status :unprocessable_entity
        expect_error_text("email - Can't be blank")
      end
    end
  end

  describe 'DELETE /users/:id' do
    it 'deletes the user' do
      authed_delete api_v1_user_path(user.id)
      expect_status :no_content
    end
  end
end
