Given(/^I(\'| a)m logged in as (a|an) (.+)$/) do |_i_iam, _a_an, user_with_role|
  user = User.find_by(email: "#{user_with_role}@example.com")

  unless user
    role_trait = user_with_role.parameterize.underscore
    user = create(:user, role_trait.to_s.to_sym)
  end

  login_as(user)
end

Given(/^I am logged in as that user$/) do
  if @user
    login_as(@user)
  else
    login_as(find_model('user'))
  end
end

def login_as(user)
  visit(sign_out_path)
  visit(sign_in_path)
  fill_in('Email', with: user.email)
  fill_in('Password', with: 'asdfjkl123')
  click_button('Sign In')
  @current_user = user
  find_model('user')
end

Given(/^I logout$/) do
  visit(sign_out_path)
end

Given(/^the following user records$/) do |table|
  table.hashes.each do |hash| # table is a Cucumber::Ast::Table
    @user = create(:user, hash)
  end
end
