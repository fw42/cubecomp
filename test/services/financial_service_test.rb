require 'test_helper'

class FinancialServiceTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
    @day = @competition.days.first
    @guest = competitors(:aachen_open_day_one_guest)
    @competitor = competitors(:flo_aachen_open)
  end

  test "#guest_count only considers confirmed guests" do
    @competitor.update_attributes(state: 'new')
    assert_equal 0, service.guest_count(@day)

    @guest.update_attributes(state: 'confirmed')
    assert_equal 1, service.guest_count(@day)
  end

  test "#competing_competitors_count only considers confirmed competitors" do
    @competitor.update_attributes(state: 'new')
    assert_equal 0, service.competing_competitors_count(@day)

    @competitor.update_attributes(state: 'confirmed')
    assert_equal 1, service.competing_competitors_count(@day)
  end

  private

  def service
    FinancialService.new(@competition)
  end
end
