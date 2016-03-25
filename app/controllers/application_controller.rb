class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def create_or_return_uniq_id
    session[:session_id] ||= SecureRandom.base64(10)
  end

  def load_poll!
    @poll ||= Poll.find_by_slug params[:slug] 
  end
end
