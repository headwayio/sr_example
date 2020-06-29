# rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength
class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery with: :exception
  include AnalyticsTrack
  check_authorization unless: :devise_or_pages_controller?
  impersonates :user

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: -> { is_a?(HighVoltage::PagesController) }
  before_action :detect_device_type
   before_action :set_action_cable_identifier

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error "Access denied on #{exception.action} #{exception.subject.inspect}"
    if request.format.html?
      redirect_to '/unauthorized', alert: exception.message
    else
      jsonapi_render_errors json: {}, status: :unprocessable_entity
    end
  end

  protected

  def devise_or_pages_controller?
    devise_controller? == true || is_a?(HighVoltage::PagesController)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :first_name,
        :last_name,
        :email,
        :photo,
        :password,
        :password_confirmation,
        :remember_me,
      ],
    )

    devise_parameter_sanitizer.permit(
      :sign_in,
      keys: [
        :login, :email, :password, :remember_me
      ],
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :first_name,
        :last_name,
        :email,
        :photo,
        :password,
        :password_confirmation,
        :current_password,
      ],
    )
  end

  def detect_device_type
    request.variant =
      case request.user_agent
      when /iPad/i
        :tablet
      when /iPhone/i
        :phone
      when /Android/i && /mobile/i
        :phone
      when /Android/i
        :tablet
      when /Windows Phone/i
        :phone
      end
  end

  private

  def set_action_cable_identifier
    cookies.encrypted[:user_id] = current_user&.id
  end

   def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/LineLength
