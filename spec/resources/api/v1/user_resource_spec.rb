require 'rails_helper'

RSpec.describe Api::V1::UserResource do
  let(:user) { create(:user, :admin) }
  let(:auth_token) { create(:authentication_token, user: user) }

  describe '#records' do
    let(:context) { { context: { current_user: user } } }

    before do
      auth_token
    end

    it 'successfully finds the user records' do
      user_records = Api::V1::UserResource.records(context)
      expect(user_records).to match_array User.where(id: user.id)
    end
  end

  describe '#records_for' do
    let(:context) { { current_user: user } }

    before do
      auth_token
    end

    it 'returns the appropriate records' do
      user_resource = Api::V1::UserResource
        .new(user, context)
      expect(user_resource.records_for('authentication_tokens', nil)).to \
        eq AuthenticationToken.where(user_id: user.id)
    end
  end

  describe '#create_authorization_token' do
    let(:context) {
      {
        current_user: user,
        request: double(remote_ip: '127.0.0.1', user_agent: 'RSpec')
      }
    }

    it 'builds a new authorization token for the user' do
      expect(user.unencrypted_token).to be_nil
      user_resource = Api::V1::UserResource
        .new(user, context)
      user_resource.create_authorization_token
      expect(user.unencrypted_token).to_not be_nil
    end
  end

  describe '#fetchable_fields' do
    let(:context) {
      {
        current_user: user,
        request: double(remote_ip: '127.0.0.1', user_agent: 'RSpec')
      }
    }

    it 'does not return password or password_confirmation' do
      user_resource = Api::V1::UserResource
        .new(user, context)

      expect(user_resource.fetchable_fields).to_not include(:password, :password_confirmation)
    end
  end
end
