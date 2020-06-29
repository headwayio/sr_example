require 'rails_helper'

RSpec.describe Api::V1::BaseResource do
  let(:user) { create(:user, :admin) }
  let(:auth_token) { create(:authentication_token, user: user) }

  it 'is abstract' do
    api_resource = Api::V1::BaseResource
    expect(api_resource.abstract).to be true
  end

  describe '#self.records' do
    it 'errors when not inherited' do
      expect { Api::V1::BaseResource.records }.to raise_error(NoMethodError)
    end
  end

  describe '#records_for' do
    it 'responds with appropriate records' do
      auth_token
      context = { current_user: user.reload }
      auth_tokens = Api::V1::BaseResource
        .new(user.reload, context)
        .records_for(:authentication_tokens, context)
      expect(auth_tokens).to eq AuthenticationToken.where(user_id: user.id)
    end
  end

end
