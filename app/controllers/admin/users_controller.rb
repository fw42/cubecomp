class Admin::UsersController < AdminController
  layout 'admin'

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to [:admin, @user], notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to [:admin, @user], notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted = [
      :email,
      :first_name,
      :last_name,
      :password,
      :password_confirmation
    ]

    if current_user.policy.edit_users?
      permitted += [ :super_admin, :delegate ]
    end

    user_params = params.require(:user).permit(permitted)

    # if user_params[:password].blank? && user_params[:password_confirmation].blank?
    #   user_params.delete(:password)
    #   user_params.delete(:password_confirmation)
    # end

    Rails.logger.info(user_params)
    user_params
  end
end
