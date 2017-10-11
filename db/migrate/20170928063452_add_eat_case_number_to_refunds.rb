class AddEatCaseNumberToRefunds < ActiveRecord::Migration
  def change
    add_column :refunds, :eat_case_number, :text
  end
end
