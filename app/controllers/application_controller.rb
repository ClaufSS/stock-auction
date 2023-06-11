class ApplicationController < ActionController::Base
  before_action :configure_sign_up_params, if: :devise_controller?

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf])
  end

  def require_admin
    unless user_signed_in? && current_user.admin?
      flash[:alert] = "Acesso restrito apenas para administradores."
      redirect_to root_path
    end
  end
end
