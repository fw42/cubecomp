require 'test_helper'

class DayDropTest < ActiveSupport::TestCase
  setup do
    @controller = ActionController::Base.new
    @day = days(:aachen_open_day_one)
    @drop = DayDrop.new(day: @day, controller: @controller)
  end

  DELEGATIONS = [
    :date,
    :entrance_fee_guests,
    :entrance_fee_competitors,
  ].freeze

  DELEGATIONS.each do |method|
    test "#{method} is delegated to day" do
      assert_equal @day.public_send(method), @drop.public_send(method)
    end
  end

  test "#schedule returns view drop for schedule" do
    assert_kind_of ViewDrop, @drop.schedule
  end

  test "#date returns date" do
    assert_equal @day.date, @drop.date
  end
end
