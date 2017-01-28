require 'test_helper'

class PricingModelTest < ActiveSupport::TestCase
  setup do
    @competitor = competitors(:aachen_open_day_one_guest)
    @competition = @competitor.competition
  end

  test "per_day #entrance_fee and #entrance_fee_total return 0 if free entrance" do
    @competitor.free_entrance = true
    pricing = pricing('per_day')
    assert_equal 0, pricing.entrance_fee(@competition.days.first)
    assert_equal 0, pricing.entrance_fee_total
  end

  test "per_day #entrance_fee returns guest fee for guests, competitor fee for competitors, and 0 if not coming" do
    pricing = pricing('per_day')

    assert_equal 0, pricing.entrance_fee(@competition.days.last)
    assert_equal @competition.days.first.entrance_fee_guests, pricing.entrance_fee(@competition.days.first)

    RegistrationService.new(@competitor).register_for_event(@competition.days.first.events.first)
    assert_equal @competition.days.first.entrance_fee_competitors, pricing.entrance_fee(@competition.days.first)
  end

  test "per day #entrance_fee_total returns sum of fees for days" do
    assert_equal @competition.days.first.entrance_fee_guests, pricing('per_day').entrance_fee_total

    RegistrationService.new(@competitor).register_for_event(@competition.days.last.events.first)
    assert_equal @competition.days.first.entrance_fee_guests + @competition.days.last.entrance_fee_competitors,
      pricing('per_day').entrance_fee_total
  end

  test "per_day_discounted #entrance_fee and #entrance_fee_total return 0 if free entrance" do
    @competitor.free_entrance = true
    pricing = pricing('per_day_discounted')
    assert_equal 0, pricing.entrance_fee(@competition.days.first)
    assert_equal 0, pricing.entrance_fee_total
  end

  test "per_day_discounted #entrance_fee returns fee for day if coming only one day" do
    assert_equal @competition.days.first.entrance_fee_guests,
      pricing('per_day_discounted').entrance_fee(@competition.days.first)
  end

  test "per_day_discounted #entrance_fee returns nil if coming on both days" do
    @competitor = competitors(:aachen_open_both_days_guest)
    assert_nil pricing('per_day_discounted').entrance_fee(@competitor.competition.days.first)
  end

  test "per_day_discounted #entrance_fee_total returns sum of fees for days if not coming on all days" do
    assert_equal @competition.days.first.entrance_fee_guests, pricing('per_day_discounted').entrance_fee_total
  end

  test "per_day_discounted #entrance_fee_total returns competition entrance_fee if coming on all days" do
    assert_equal @competition.days.first.entrance_fee_guests, pricing('per_day_discounted').entrance_fee_total
    RegistrationService.new(@competitor).register_as_guest(@competition.days.last.events.first)
    assert_equal @competition.entrance_fee_guests, pricing('per_competition').entrance_fee_total
  end

  test "per_competition #entrance_fee returns nil" do
    assert_nil pricing('per_competition').entrance_fee(@competition.days.first)
  end

  test "per_competition total returns competitors fee if competing >= 1 day, even if guest on other day" do
    RegistrationService.new(@competitor).register_for_event(@competition.days.last.events.first)
    assert_equal @competition.entrance_fee_competitors, pricing('per_competition').entrance_fee_total
  end

  test "per_competition #entrance_fee_total returns 0 if free entrance" do
    @competitor.free_entrance = true
    pricing = pricing('per_competition')
    assert_equal 0, pricing.entrance_fee_total
  end

  private

  def pricing(handle)
    PricingModel.for_handle(handle).new(@competitor)
  end
end
