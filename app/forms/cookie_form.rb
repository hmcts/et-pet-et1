class CookieForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::Serializers::JSON
  attribute :usage, :boolean, default: false
  attribute :essential, :boolean, default: true
  attribute :seen, :boolean, default: false
end
