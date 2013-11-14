
class SessionsController < ApplicationController
  def new
    # redirect to index if the user is already logged in
    if session[:user_id] != nil
      redirect_to root_path
    end
  end

  # Controls the log in action. 
  # For any invalid combination of username and password, the page will redirect to itself with an error message 
  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to log_in_path, alert: "Invalid username or password"
    end
  end

  # Controls the log out action
  def destroy
    session[:user_id] = nil
    redirect_to log_in_path
  end
  
  private
end
