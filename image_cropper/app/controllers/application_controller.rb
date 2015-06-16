class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SentientController
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def ensure_admin
    return if current_user and current_user.role_id == 1
    error_msg = 'You are not authorized for the requested action.'
    respond_to do |format|
      format.html do
        flash[:alert] = error_msg
        render 'site/index', status: :unauthorized
      end
      format.json { render json: error_msg, status: :unauthorized }
    end
  end

  def ensure_uploader
    return if current_user and current_user.role_id == 1 or current_user.role_id == 2
    error_msg = 'You are not authorized for the requested action.'
    respond_to do |format|
      format.html do
        flash[:alert] = error_msg
        render 'site/index', status: :unauthorized
      end
      format.json { render json: error_msg, status: :unauthorized }
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password) }
  end
end
