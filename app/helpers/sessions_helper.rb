module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end
  
  def sign_out
    session[:user_id] = nil
    self.current_user = nil
  end
  
  def current_user=(user)
    @current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    if session[:user_id].nil?
      return nil
    end
    @current_user ||= User.find(session[:user_id])
  end
end

  def ensure_logged_in
    if !signed_in?
      redirect_to log_in_url, message: "Please log in first."
    end
  end
    
