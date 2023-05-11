class ApplicationController < ActionController::Base
  before_action :configure_sign_up_params, if: :devise_controller?

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf])
  end
end
