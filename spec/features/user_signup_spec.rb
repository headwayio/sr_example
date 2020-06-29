require 'rails_helper'

describe 'User signup', type: :feature do
  it 'Valid user information' do
    sign_up_with('First', 'Last', 'test@example.com', 'password', 'password')
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  it 'Passwords do not  match' do
    sign_up_with('First', 'Last', 'test@example.com', 'password', 'password2')
    expect(page).to have_content("doesn't match Password")
  end

  it 'Email is invalid' do
    sign_up_with('First', 'Last', 'test2example.com', 'password', 'password')
    expect(page).to have_content('is invalid')
  end
end
