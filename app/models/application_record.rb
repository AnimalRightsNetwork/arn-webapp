class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def has_error? attribute, error
    errors.details[attribute].map{|e| e[:error]}.include? error
  end

  def get_error_message attribute, error
    error_details = errors.details[attribute]
    message = errors.generate_message attribute, error
    errors.full_message attribute, message
  end
end
