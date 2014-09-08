class UserPolicyService
  def initialize(user)
    @user = user
  end

  def login?(competition)
    @user.super_admin? ||
      @user.id == competition.delegate_user_id ||
      Permission.where(user: @user, competition: competition).exists?
  end

  def see_users?
    @user.super_admin?
  end

  def edit_users?
    @user.super_admin?
  end
end
