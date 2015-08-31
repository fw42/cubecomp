require 'test_helper'

class ChecklistServiceTest < ActiveSupport::TestCase
  setup do
    @competitor = competitors(:flo_aachen_open)
  end

  test '#comments includes user_comment and admin_comment' do
    @competitor.admin_comment = 'haha'

    assert_match /Admin comment.*#{@competitor.admin_comment}/i, service.comments.join("\n")
  end

  test '#comments includes birthday if it is on one of the competition days' do
    @competitor.birthday = @competitor.competition.days.first.date
    assert_match /birthday/i, service.comments.join("\n")
  end

  test '#comments includes free entrance' do
    @competitor.free_entrance = true
    @competitor.free_entrance_reason = nil
    assert_match /free entrance/i, service.comments.join("\n")

    @competitor.free_entrance_reason = 'nice guys get in for free'
    assert_match /free entrance.*nice guys/i, service.comments.join("\n")
  end

  test '#comments includes newcomer note if competitor is competing' do
    @competitor.wca = nil

    assert_match /newcomer.*check identification/i, service.comments.join("\n")

    @competitor.event_registrations.destroy_all
    assert_no_match /newcomer/i, service.comments.join("\n")
  end

  test '#comments includes paid already' do
    @competitor.paid = true
    assert_match /Paid already/i, service.comments.join("\n")
  end

  test '#entrance_fee is 0 if paid already' do
    @competitor.paid = true
    assert_equal 0, service.entrance_fee
  end

  test '#entrance_fee uses the right pricing model' do
    @competitor = competitors(:aachen_open_both_days_guest)
    competition = @competitor.competition
    competition.pricing_model = 'per_day'
    competition.entrance_fee_guests = 100

    assert_equal competition.days.to_a.sum(&:entrance_fee_guests), service.entrance_fee

    competition.pricing_model = 'per_competition'
    assert_equal BigDecimal.new(100), service.entrance_fee
  end

  private

  def service
    ChecklistService.new(@competitor)
  end
end
