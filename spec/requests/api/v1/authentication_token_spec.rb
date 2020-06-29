require 'rails_helper'

RSpec.describe DeviseCustomizations::SessionsController, type: :request, order: :defined do
  let(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let(:headers) {
    {
      'ContentType': 'application/json',
      'Accept': 'application/json'
    }
  }

    describe 'POST /users/sign_in' do
      context 'when successful' do
        let(:params) do
          {
            "user":
            {
              "email": user.email,
              "password": "asdfjkl123"
            }
          }
        end

        before do
          post user_session_path,
            params: params,
            headers: headers
        end

        it 'responds with a valid token' do
          response_token = JSON.parse(response.body)
            .dig('meta','authentication_token')

          expect(
            Tiddle::TokenIssuer.build.find_token(user, response_token)
          )
        end

        it 'returns status 200' do
          expect_status 200
        end
      end

    context 'when unsuccessful' do
      let(:params) {
        { "user":
          {
            "email": user.email,
            "password": "lkjfdsa123"
          }
        }
      }

      before do
        post user_session_path, params: params, headers: headers
      end

      it 'returns status 401' do
        expect_status 401
      end

      it 'responds with an error' do
        expect(response.body).to eq "{\"error\":\"Invalid Email or password.\"}"
      end
    end
  end

  describe 'GET /users/sign_out' do
    context 'successfully signs out' do
      before do
        authenticate(user)
        authed_get destroy_user_session_path, headers: headers
      end

      it 'returns status 200' do
        expect_status 200
      end

      it 'returns an empty JSON object' do
        expect(response.body).to eq ("{}")
      end
    end

    context 'is unsuccessful' do
      before do
        get destroy_user_session_path, headers: headers
      end

      it 'returns status 200' do
        expect_status 200
      end

      it 'still returns an empty JSON object' do
        expect(response.body).to eq ("{}")
      end
    end
  end
end
