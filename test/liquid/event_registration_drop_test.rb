require 'test_helper'

class EventRegistrationDropTest < ActiveSupport::TestCase
  setup do
    @registration = event_registrations(:aachen_open_flo_rubiks_cube)
    @drop = @registration.to_liquid
  end

  test 'EventRegistration#to_liquid returns a Liquid::Drop' do
    assert @registration.to_liquid.is_a?(EventRegistrationDrop)
    assert @registration.to_liquid.is_a?(Liquid::Drop)
  end

  test '#waiting' do
    assert_equal @registration.waiting, @drop.waiting
  end

  test '#day' do
    assert_equal @registration.event.day.date, @drop.day
  end

  test '#name' do
    assert_equal @registration.event.name, @drop.name
  end
end
