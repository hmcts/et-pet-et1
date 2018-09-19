class AddEatCaseNumberToRefunds < ActiveRecord::Migration[4.2]
  def change
    add_column :refunds, :eat_case_number, :text
  end
end
