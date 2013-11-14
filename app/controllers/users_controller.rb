
class UsersController < ApplicationController
  def new
    # redirect to index if the user is already logged in
    if session[:user_id] != nil
      redirect_to root_path
    end
    @user = User.new
  end


  # Somehow the built-in validation for nil password was not working, so I added a custom validation
  def create
    @user = User.new(user_params)

    if @user.password == ""
      @user.errors.add(:password, "cannot be blank")
      render "sign_up"
      return
    end

    if @user.save
	  session[:user_id] = @user.id
      redirect_to root_path
    else
      render "new"
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
  def search_params
	params.permit(:username);
  end

end
