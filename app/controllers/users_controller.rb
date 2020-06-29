class UsersController < ApplicationController
  # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
  # load_and_authorize_resource only: []
  skip_authorization_check only: [:analytics_alias,
                                  :edit_password,
                                  :update_password,
]

  def analytics_alias
    # view file has JS that will identify the anonymous user through segment
    # after registration via "after devise registration path"
  end

  def edit_password
    @user = User.find(current_user.id)
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user) unless true_user && true_user != @user
      flash[:notice] = 'Password successfully updated.'
      redirect_to root_path
    else
      # flash.now[:error] = 'Password not updated'
      render 'edit_password'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password,
                                 :password_confirmation,
                                 :current_password)
  end
end
