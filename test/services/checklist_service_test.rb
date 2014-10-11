require 'test_helper'

class ChecklistServiceTest < ActiveSupport::TestCase
  setup do
    @competitor = competitors(:flo_aachen_open)
    @service = @competitor.checklist_service
  end

  test '#comments includes user_comment and admin_comment' do
    @competitor.user_comment = 'can I bring my mom?'
    @competitor.admin_comment = 'haha'

    assert_match /User comment.*#{@competitor.user_comment}/i, @service.comments.join("\n")
    assert_match /Admin comment.*#{@competitor.admin_comment}/i, @service.comments.join("\n")
  end

  test '#comments includes birthday if it is on one of the competition days' do
    @competitor.birthday = @competitor.competition.days.first.date
    assert_match /birthday/i, @service.comments.join("\n")
  end

  test '#comments includes free entrance' do
    @competitor.free_entrance = true
    @competitor.free_entrance_reason = nil
    assert_match /free entrance/i, @service.comments.join("\n")

    @competitor.free_entrance_reason = 'nice guys get in for free'
    assert_match /free entrance.*nice guys/i, @service.comments.join("\n")
  end

  test '#comments includes newcomer note' do
    @competitor.wca = nil
    assert_match /newcomer.*check identification/i, @service.comments.join("\n")
  end
end
