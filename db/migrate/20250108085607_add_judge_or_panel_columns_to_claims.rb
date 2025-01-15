class AddJudgeOrPanelColumnsToClaims < ActiveRecord::Migration[7.2]
  def change
    add_column :claims, :case_heard_by_preference, :string, default: 'no_preference'
    add_column :claims, :case_heard_by_preference_reason, :text
  end
end
