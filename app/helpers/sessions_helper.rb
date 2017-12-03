module SessionsHelper
  # Set user logged in
  def log_in user
    log_out
    session[:user_id] = user.id
  end

  # Log user out
  def log_out
    @current_user = nil
    if session[:user_id]
      session.delete :user_id
      true
    else
      false
    end
  end

  # Get current user
  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    end
  end

  # Check if current user
  def current_user? user
    user == current_user
  end

  # Check if logged in
  def logged_in?
    !current_user.nil?
  end
end
