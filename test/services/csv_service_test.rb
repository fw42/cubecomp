require 'test_helper'

class CsvServiceTest < ActiveSupport::TestCase
  setup do
    @competition = competitions(:aachen_open)
  end

  test "#handles includes events that are waiting or closed" do
    event = events(:aachen_open_rubiks_cube)

    event.state = 'open_with_waiting_list'
    event.save!
    assert service.handles.include?(event.wca_handle)

    event.state = 'registration_closed'
    event.save!
    assert service.handles.include?(event.wca_handle)
  end

  test "#competitor_to_csv" do
    competitor = competitors(:flo_aachen_open)
    expected = "a,Florian Weingarten,Germany,2007WEIN01,1985-12-18,m,,1,0,1"
    assert_equal expected, service.competitor_to_csv(competitor)
  end

  test "#competitor_to_csv includes events that don't have a wca handle" do
    competitor = competitors(:flo_aachen_open)

    event = events(:aachen_open_rubiks_cube)
    event.handle = '3x'
    event.save!

    assert_nil event.wca_handle

    expected = "a,Florian Weingarten,Germany,2007WEIN01,1985-12-18,m,,1,0,1"
    assert_equal expected, service.competitor_to_csv(competitor)
  end

  private

  def service
    CsvService.new(@competition)
  end
end
