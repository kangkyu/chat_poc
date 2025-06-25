class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def require_signin
    redirect_to new_session_url unless current_user_id.present?
  end

  def require_logout
    redirect_to root_url if current_user_id.present?
  end

  def current_user
    @current_user ||= User.find_by(id: current_user_id)
  end

  def current_user_id
    session[:user_id]
  end
end
