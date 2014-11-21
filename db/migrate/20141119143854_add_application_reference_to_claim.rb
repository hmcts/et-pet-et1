class AddApplicationReferenceToClaim < ActiveRecord::Migration
  class Claim < ActiveRecord::Base
    def generate_application_reference!
      update application_reference: ApplicationReference.generate
    end
  end

  def change
    add_column 'claims', 'application_reference', :string
    Claim.all.each do |claim|
      claim.generate_application_reference!
    end
    add_index 'claims', 'application_reference', unique: true
    change_column_null 'claims', 'application_reference', false
  end
end
