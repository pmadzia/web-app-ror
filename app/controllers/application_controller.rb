class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user

  private

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_login
    return if current_user&.active?
    if session[:user_id].nil?
      redirect_to login_path
    else
      message = current_user.nil? ? "Account no longer exists." : "Account is blocked."
      reset_session
      redirect_to login_path, alert: message
    end
  end
end
