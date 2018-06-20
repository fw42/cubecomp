ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'minitest/pride'
require 'mocha/minitest'
require 'webmock/minitest'

def with_csrf_protection
  old_csrf_value = ActionController::Base.allow_forgery_protection
  ActionController::Base.allow_forgery_protection = true
  yield
ensure
  ActionController::Base.allow_forgery_protection = old_csrf_value
end

class ActiveSupport::TestCase
  fixtures :all

  setup :paperclip_fixtures

  def paperclip_fixtures
    from = Rails.root.join("test/fixtures/files/logo.png")
    to = Rails.root.join("tmp/cubecomp/test/uploads/theme_files/images/623/173/363/original/logo.png")
    return if File.exist?(to)
    FileUtils.mkdir_p(File.dirname(to))
    FileUtils.cp(from, to)
  end

  def assert_not_valid(object, attribute)
    refute object.valid?, "record shouldn't be valid"
    assert_not_equal [], object.errors[attribute], 'record should have errors'
  end

  def assert_valid(object)
    assert object.valid?, "#{object.class.name} has errors: #{object.errors.full_messages}"
  end

  def assert_attributes(expected_attributes, object)
    actual_attributes = object.attributes.symbolize_keys.slice(*expected_attributes.keys)
    assert_equal expected_attributes, actual_attributes
  end

  def assert_theme_equals(expected_theme_files, actual_theme_files)
    expected = expected_theme_files.map(&:attributes).sort_by{ |h| h['filename'] }
    actual = actual_theme_files.map(&:attributes).sort_by{ |h| h['filename'] }

    (expected + actual).each do |file|
      file.delete('id')
      file.delete('theme_id')
      file.delete('competition_id')
      file.delete('created_at')
      file.delete('updated_at')
      file.delete('image_updated_at')
    end

    assert_equal expected, actual
  end

  def assert_events_equal(expected_events, actual_events)
    expected = expected_events.map(&:attributes).sort_by{ |h| h['start'] }
    actual = actual_events.map(&:attributes).sort_by{ |h| h['start'] }

    (expected + actual).each do |event|
      event.delete('id')
      event.delete('day_id')
      event.delete('competition_id')
      event.delete('created_at')
      event.delete('updated_at')
    end

    assert_equal expected, actual
  end

  def assert_email_templates_equal(expected_templates, actual_templates)
    expected = expected_templates.map(&:attributes).sort_by{ |h| h['name'] }
    actual = actual_templates.map(&:attributes).sort_by{ |h| h['name'] }

    (expected + actual).each do |template|
      template.delete('id')
      template.delete('updated_at')
      template.delete('created_at')
      template.delete('competition_id')
    end

    assert_equal expected, actual
  end
end

class ActionController::TestCase
  def use_https(flag = true)
    @request.env['HTTPS'] = flag ? 'on' : nil
    @request.stubs(:protocol).returns(flag ? "https://" : "http://")
  end

  def login_as(user)
    use_https
    session[:user] = user.session_data
  end

  def logout
    session.delete(:user_id)
  end

  def mock_login_not_allowed(competition)
    policy = UserPolicy.any_instance
    policy.expects(:login?).with{ |c| c.id == competition.id }.returns(false)
  end

  def mock_create_competitions_not_allowed
    policy = UserPolicy.any_instance
    policy.expects(:create_competitions?).returns(false)
  end

  def mock_destroy_competition_not_allowed(competition)
    policy = UserPolicy.any_instance
    policy.expects(:destroy_competition?).with{ |c| c.id == competition.id }.returns(false)
  end
end
