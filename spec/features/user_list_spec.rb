require 'rails_helper'

describe 'Retrieve user list from browser', type: :feature do
  it 'without admin privileges' do
    user = create(:user)

    sign_in(user.email, user.password)
    visit admin_users_path

    expect(page).to have_content('You must be an admin to perform that action')
  end

  it 'with admin privileges' do
    user = create(:user, :admin)

    sign_in(user.email, user.password)
    visit admin_users_path

    expect(page).to have_content(user.last_name)
  end
end
