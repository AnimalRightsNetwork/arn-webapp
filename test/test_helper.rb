require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Require shared helpers
Dir[Rails.root.join('test/shared/**/*.rb')].each { |f| require f }

# Load seed into test database
Rails.application.load_seed

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Assert record produces certain errors
  def assert_invalid record, errors={}
    # Assert record to be invalid
    assert_not_predicate record, :save

    # Assert specified errors to occur
    errors.each do |attr, error|
      assert record.has_error? attr, error
    end
  end
end
