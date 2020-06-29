module Api
  class BaseApiController < ApplicationController
    include JSONAPI::Utils
    include JSONAPI::ActsAsResourceController

    authorize_resource

    def context
      { current_user: current_user, request: request }
    end

    # Disable CSRF protection for API calls
    protect_from_forgery with: :null_session, prepend: true

    # Disable cookie usage
    before_action :destroy_session

    # Handle objects that aren't found
    rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found

    rescue_from CanCan::AccessDenied do |exception|
      denied_message = "Access denied on #{exception.action} " \
                       "#{exception.subject.inspect} for #{current_user&.id}"
      Rails.logger.error(denied_message)

      render json: { errors: [denied_message] }, status: :unprocessable_entity
    end


    def respond_with_errors(object)
      serialized_errors = object.errors.messages.map do |field, errors|
        errors.map do |error_message|
          {
            status: 422,
            source: { pointer: "/data/attributes/#{field}" },
            detail: error_message,
          }
        end
      end.flatten

      render json: { errors: serialized_errors },
             status: :unprocessable_entity
    end

    private

    def destroy_session
      request.session_options[:skip] = true
    end
  end
end
