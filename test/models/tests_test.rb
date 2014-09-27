require 'test_helper'

class TestsTest < ActiveSupport::TestCase
  test 'all fixtures are valid' do
    keys = ActiveRecord::FixtureSet.all_loaded_fixtures.keys.sort
    keys.each do |key|
      model = key.camelize.singularize.constantize
      model.all.each do |object|
        assert object.valid?, "Fixture for #{model} with id #{object.id} doesn't " \
          "pass it's own validations: #{object.errors.full_messages}"
      end
    end
  end
end
