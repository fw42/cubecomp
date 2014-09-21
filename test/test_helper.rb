ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'

class ActiveSupport::TestCase
  fixtures :all

  def assert_not_valid(object, attribute)
    refute object.valid?, "record shouldn't be valid"
    assert_not_equal [], object.errors[attribute], "record should have errors"
  end

  def assert_valid(object)
    assert object.valid?, "#{object.class.name} has errors: #{object.errors.full_messages}"
  end

  def assert_attributes(expected_attributes, object)
    actual_attributes = object.attributes.symbolize_keys.slice(*expected_attributes.keys)
    assert_equal expected_attributes, actual_attributes
  end
end

class ActionController::TestCase
  def login_as(user)
    raise 'Invalid user' unless user
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
  end
end
