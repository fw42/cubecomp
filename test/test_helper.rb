ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all

  def assert_not_valid(object, attribute)
    refute object.valid?, "record shouldn't be valid"
    assert_not_equal [], object.errors[attribute], "record should have errors"
  end

  def assert_valid(object)
    assert object.valid?, "record should be valid"
  end
end
