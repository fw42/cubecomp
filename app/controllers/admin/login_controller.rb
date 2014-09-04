class Admin::LoginController < ApplicationController
  def login
    reset_session
  end

  def logout
    reset_session
    redirect_to admin_root_path
  end
end
