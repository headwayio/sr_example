module DeviseCustomizations
  class PasswordsController < Devise::PasswordsController
    skip_before_action :verify_authenticity_token,
                       only: [:create, :destroy],
                       if: -> { json_request? }
    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        render json: { success: true }
      else
        render json: { success: false }
      end
    end

    def json_request?
      %i[api_json json].include?(request.format.to_sym)
    end

    def resource_params
      params.permit!.fetch("data", {}).fetch("attributes", {})
    end
  end
end
