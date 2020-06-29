RSpec.shared_examples 'dashboard' do
  let(:admin_user) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe '#index' do
    context 'when authenticated' do
      context 'when logged in as an admin' do
        it 'loads dashboard successfully in browser' do
          sign_in(admin_user)
          get path
          expect(response).to be_successful
        end
      end

      context 'when logged in as a regular user' do
        it 'redirects with an alert that you need to be an admin' do
          sign_in(user)
          get path
          expect(response).to be_redirect

          txt = 'You must be an admin to perform that action'
          expect(flash[:alert]).to eq(txt)
        end
      end
    end

    context 'when NOT authenticated' do
      it 'redirects to sign in page with an alert' do
        get path
        expect(response).to be_redirect

        txt = 'You need to sign in or sign up before continuing.'
        expect(flash[:alert]).to eq(txt)
      end
    end
  end
end
