require 'test_helper'

class DayDropTest < ActiveSupport::TestCase
  setup do
    @controller = ActionController::Base.new
    @day = days(:aachen_open_day_one)
    @drop = DayDrop.new(day: @day, controller: @controller)
  end

  test "#schedule returns view drop for schedule" do
    assert_kind_of ViewDrop, @drop.schedule
  end
end
