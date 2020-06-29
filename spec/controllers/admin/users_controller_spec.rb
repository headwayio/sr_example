require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  it_behaves_like 'dashboard' do
    let(:path) { admin_users_path }
  end

  let(:user) { create(:user, device_token: 'asdf') }
  let(:admin_user) { create(:user, :admin) }

  describe '#update' do
    it 'returns 200 status' do
      sign_in(admin_user)
      patch admin_user_path(user), params: { user: { password: 'test' } }

      expect(response.status).to eq(200)
    end
  end

  describe 'impersonation' do
    describe '#impersonate' do
      it 'changes the current user from admin to the specified user' do
        sign_in(admin_user)
        get impersonate_admin_user_path(user)
        expect(controller.current_user).to eq(user)
      end
    end

    describe '#stop_impersonating' do
      it 'returns the current_user to the admin user' do
        sign_in(admin_user)
        get impersonate_admin_user_path(user)
        expect(controller.current_user).to eq(user)
        get stop_impersonating_admin_users_path
        expect(controller.current_user).to eq(admin_user)
      end
    end
  end

  describe '#test_push_notification' do
    it 'finds a user and something something' do
      allow(user).to receive(:send_push_notification)
        .with(any_args).and_return(true)
      sign_in admin_user

      post test_push_notification_admin_user_path(user)

      expect(response.status).to eq(204)
    end
  end
end
