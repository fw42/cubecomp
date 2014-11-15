class UserPolicyService
  def initialize(user)
    @user = user
  end

  def competitions
    Competition.all.select{ |c| login?(c) }
  end

  def login?(competition)
    admin? || @user.delegate_for?(competition) || @user.permission?(competition)
  end

  def admin_user_menu?
    admin?
  end

  def create_competitions?
    admin?
  end

  def destroy_competition?(_competition)
    admin?
  end

  def change_competition_permissions?(_competition)
    admin?
  end

  def change_permission_level_to?(other_user, _level)
    (other_user != @user) && superadmin?
  end

  def change_delegate_flag?(_other_user)
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
