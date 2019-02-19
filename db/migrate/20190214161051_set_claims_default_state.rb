class SetClaimsDefaultState < ActiveRecord::Migration[5.2]
  def change
    change_column_default :claims, :state, 'created'
  end
end
