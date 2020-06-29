module Api
  module V1
    class UsersController < BaseApiController
      load_and_authorize_resource except: :create
      skip_authorization_check only: :create
      skip_authorize_resource only: :create
      skip_before_action :authenticate_user!, only: :create

      def index
        jsonapi_render json: User.accessible_by(Ability.new(current_user))
      end

      def show
        authorize! :show, @user
        jsonapi_render json: @user
      end
    end
  end
end
