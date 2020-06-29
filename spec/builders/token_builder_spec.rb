require 'rails_helper'

describe TokenBuilder do
  describe '.build' do
    it 'creates a new token for the user' do
      user = create(:user)
      auth_token1 = create(:authentication_token, user: user)
      request = instance_double('http request').as_null_object

      _token, auth_token2 = described_class.build(user, request)

      expect(user.authentication_tokens)
        .to match_array([auth_token1, auth_token2])
    end
  end
end
