class Admin::UsersController < AdminController
  layout 'admin'

  before_action :set_user, only: [:create, :edit, :update, :destroy]
  before_action :ensure_user_can_see_admin_menu, except: [:edit, :update]
  before_action :ensure_user_can_edit_user, only: [:edit, :update]
  before_action :ensure_user_can_edit_permissions, only: [:update, :create]
  before_action :ensure_user_can_edit_permission_level, only: [:update, :create]
  before_action :ensure_user_can_edit_delegate_flag, only: [:update, :create]
  before_action :ensure_user_can_change_active_flag, only: [:update]

  skip_before_action :ensure_current_competition

  PERMITTED_PARAMS = [
    :email,
    :first_name,
    :last_name,
    :password,
    :password_confirmation,
    :permission_level,
    :delegate,
    :address,
    :active,
    permissions_attributes: [:id, :_destroy, :competition_id]
  ]

  def index
    all_users = User
      .select('users.*, COUNT(permissions.competition_id) AS competition_count')
      .joins('LEFT JOIN permissions ON users.id = permissions.user_id')
      .group('users.id')
      .order(:last_name, :first_name)

    @active_users = all_users.select(&:active?)
    @inactive_delegates = all_users.reject(&:active?).select(&:delegate?)
    @inactive_others = all_users - @active_users - @inactive_delegates
  end

  def new
    @user = User.new
  end

  def edit
    @delegating_competitions = @user.delegating_competitions
    @owned_competitions = @user.owned_competitions
  end

  def create
    return render_forbidden unless current_user.policy.create_user?(@user)

    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      session[:user] = @user.session_data if current_user.id == @user.id

      if @user.id == current_user.id
        redirect_to edit_admin_user_path(@user), notice: 'Your user account was successfully updated.'
      else
        redirect_to admin_users_path, notice: 'User was successfully updated.'
      end
    else
      edit
      render :edit
    end
  end

  def destroy
    return render_forbidden unless current_user.policy.destroy_user?(@user)
    @user.destroy
    redirect_to admin_users_url, notice: 'User was successfully deleted.'
  end

  private

  def set_user
    if action_name == 'create'
      @user = User.new(user_params)
    else
      @user = User.find(params[:id])
    end
  end

  def user_params
    params.require(:user).permit(PERMITTED_PARAMS)
  end

  def ensure_user_can_edit_user
    return render_forbidden unless current_user.policy.edit_user?(@user)
  end

  def ensure_user_can_change_active_flag
    return unless user_params.key?(:active)
    render_forbidden unless current_user.policy.disable_user?(@user)
  end

  def ensure_user_can_edit_permissions
    return unless user_params.key?(:permissions_attributes)

    user_params[:permissions_attributes].each do |_, attributes|
      next unless attributes[:competition_id]
      competition = Competition.find(attributes[:competition_id])
      return render_forbidden unless current_user.policy.change_competition_permissions?(competition)
    end
  end

  def ensure_user_can_edit_permission_level
    return unless user_params.key?(:permission_level)
    return if current_user.policy.change_permission_level_to?(@user, user_params[:permission_level].to_i)
    render_forbidden
  end

  def ensure_user_can_edit_delegate_flag
    return unless user_params.key?(:delegate)
    return if current_user.policy.change_delegate_flag?(@user)
    render_forbidden
  end
end
