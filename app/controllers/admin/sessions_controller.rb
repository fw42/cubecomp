class Admin::SessionsController < ApplicationController
  force_ssl unless Rails.env.development?
  layout 'admin/empty'
  protect_from_forgery with: :null_session

  def new
  end

  def create
    if user = authenticate_user(user_params)
      successful_login(user)
    else
      failed_login
    end
  end

  def destroy
    reset_session
    redirect_to admin_login_path
  end

  private

  def authenticate_user(user_params)
    return unless user = User.active.find_by(email: user_params[:email])
    return unless user.authenticate(user_params[:password])
    user
  end

  def successful_login(user)
    reset_session
    session[:user] = user.session_data
    redirect_to admin_root_path
  end

  def failed_login
    reset_session
    flash[:error] = 'Login failed.'
    render action: 'new', status: 401
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
