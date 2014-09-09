module Admin::UsersHelper
  def user_for_form(user)
    return user unless current_user.policy.edit_users?

    competition_ids = user.permissions.pluck(:competition_id)
    missing = if competition_ids.empty?
      Competition.all
    else
      Competition.where('id NOT IN (?)', competition_ids)
    end

    missing.each do |competition|
      user.permissions.build(competition: competition)
    end

    Rails.logger.info(user.permissions.inspect)

    user
  end
end
