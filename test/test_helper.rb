require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Assert record produces certain errors
  def assert_invalid record, errors={}
    # Assert record to be invalid
    assert_not_predicate record, :save

    # Assert specified errors to occur
    errors.each do |attr, msg|
      errs = record.errors.details[attr].map{|d| d[:error]}
      assert_includes errs, msg
    end
  end
end
