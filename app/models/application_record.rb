class ApplicationRecord < ::ActiveRecord::Base
  self.abstract_class = true

  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end
end
