class ChangeDefaultOfCaseHeardByPreferenceInClaims < ActiveRecord::Migration[7.2]
  def change
    change_column_default :claims, :case_heard_by_preference, from: 'no_preference', to: nil
  end
end
