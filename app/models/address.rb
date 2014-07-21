class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  def empty?
    %i<building street locality county post_code country telephone_number>.all? do |attr|
      send(attr).blank?
    end
  end

end
