module Api
  module V1
    module Users
      class PasswordsController < ApplicationController
        include JSONAPI::Utils
        include JSONAPI::ActsAsResourceController
        skip_before_action :verify_authenticity_token

        def update
          user = User
            .accessible_by(
              Ability.new(current_user),
              params[:action].to_sym
            )
            .find_by(id: params[:id])
          authorize! :show, user
          if user.update_with_password(resource_params)
            jsonapi_render json: user
          else
            jsonapi_render_errors json: user
          end
        end
      end
    end
  end
end
