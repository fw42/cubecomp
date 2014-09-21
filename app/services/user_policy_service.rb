class UserPolicyService
  def initialize(user)
    @user = user
  end

  def login?(competition)
    admin? || @user.delegate_for?(competition) || @user.has_permission?(competition)
  end

  def admin_user_menu?
    admin?
  end

  def create_competition?
    admin?
  end

  def change_competition_permissions?
    admin?
  end

  def change_permission_level_to?(other_user, level)
    return false if other_user == @user

    superadmin? ||
      (@user.permission_level > level) ||
      (@user == other_user && @user.permission_level == level)
  end

  def change_delegate_flag?(other_user)
    admin?
  end

  def create_user?(other_user)
    higher_permission_level_than?(other_user)
  end

  def edit_user?(other_user)
    (other_user == @user) || higher_permission_level_than?(other_user)
  end

  def destroy_user?(other_user)
    (other_user != @user) && higher_permission_level_than?(other_user)
  end

  private

  def admin?
    @user.permission_level >= User::PERMISSION_LEVELS[:admin]
  end

  def superadmin?
    @user.permission_level >= User::PERMISSION_LEVELS[:superadmin]
  end

  def higher_permission_level_than?(other_user)
    @user.permission_level > (other_user.permission_level || 0)
  end
end
