class CreateApplicationReferences < ActiveRecord::Migration
  def change
    create_table :application_references do |t|
      t.string :reference, index: true
      t.belongs_to :claim, index: true

      t.timestamp :created_at, null: false
    end
  end
end
