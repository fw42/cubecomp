class ChecklistService
  delegate :wca,
    :user_comment,
    :admin_comment,
    :free_entrance?,
    :free_entrance_reason,
    :birthday_on_competition?,
    :paid?,
    to: :competitor

  attr_reader :competitor

  def initialize(competitor)
    @competitor = competitor
  end

  def entrance_fee
    if paid?
      0
    else
      competitor.days.reduce(0) { |total, day| total + competitor.entrance_fee(day) }
    end
  end

  def comments
    comments = []
    comments << 'Newcomer (Check identification!)' if wca.blank?
    comments += comment_comments
    comments << 'Birthday!' if birthday_on_competition?
    comments << 'Paid already' if paid?
    comments
  end

  private

  def comment_comments
    comments = []
    comments << "Admin comment: #{admin_comment}" if admin_comment.present?
    comments << free_entrance_comment if free_entrance?
    comments
  end

  def free_entrance_comment
    line = 'Free entrance'
    line << " (#{free_entrance_reason})" if free_entrance_reason.present?
    line
  end
end
