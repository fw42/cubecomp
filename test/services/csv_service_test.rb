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

  private

  def service
    CsvService.new(@competition)
  end
end
