class ChecklistService
  delegate :wca,
    :user_comment,
    :admin_comment,
    :free_entrance?,
    :free_entrance_reason,
    :birthday_on_competition?,
    to: :competitor

  attr_reader :competitor

  def initialize(competitor)
    @competitor = competitor
  end

  def entrance_fee
    # TODO
    0
  end

  def comments
    comments = []
    comments << 'Newcomer (Check identification!)' if wca.blank?
    comments << "User comment: #{user_comment}" if user_comment.present?
    comments << "Admin comment: #{admin_comment}" if admin_comment.present?
    comments << free_entrance_comment if free_entrance?
    comments << 'Birthday!' if birthday_on_competition?

    ## TODO
    # if number_of_wca_competitions % 10 == 0
    #   comments << "Competition #{number_of_wca_competitions}"
    # end

    comments
  end

  private

  def free_entrance_comment
    line = 'Free entrance'
    line << " (#{free_entrance_reason})" if free_entrance_reason.present?
    line
  end
end
