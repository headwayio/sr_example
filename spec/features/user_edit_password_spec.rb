require 'rails_helper'

describe 'User edits password', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in(user.email, user.password)

    click_link 'Change Password'
  end

  it 'renders the edit view' do
    within('div.main') do
      expect(page).to have_content('Current password')
      expect(page).to have_content('New Password')
      expect(page).to have_content('New Password Confirmation')
    end
  end

  it 'updates the password and redirects to root path' do
    fill_in 'user[current_password]', with: user.password
    fill_in 'user[password]', with: 'new123'
    fill_in 'user[password_confirmation]', with: 'new123'
    click_button('Update User')

    expect(current_path).to eq(root_path)
  end

  it 'renders edit password' do
    fill_in 'user[current_password]', with: user.password
    fill_in 'user[password]', with: 'new123'
    fill_in 'user[password_confirmation]', with: 'new1234'
    click_button('Update User')

    expect(current_path).to eq(update_password_users_path)
  end
end
