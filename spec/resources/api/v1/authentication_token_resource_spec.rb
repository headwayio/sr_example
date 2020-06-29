require 'rails_helper'

RSpec.describe Api::V1::AuthenticationTokenResource do
  let(:user) { create(:user, :admin) }
  let(:auth_token) { create(:authentication_token, user: user) }

  it '#records' do
    auth_token
    context = { context: { current_user: user } }
    auth_token_records = Api::V1::AuthenticationTokenResource.records(context)
    expect(auth_token_records).to eq AuthenticationToken.where(user_id: user.id)
  end

  it '#records_for' do
    context = { current_user: user }
    auth_token
    auth_token_resource = Api::V1::AuthenticationTokenResource
      .new(user, context)
    expect(auth_token_resource.records_for('authentication_tokens', nil)).to \
      eq AuthenticationToken.where(user_id: user.id)
  end
end
