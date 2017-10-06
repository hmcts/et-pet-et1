class EmptyRefunds < ActiveRecord::Migration
  class Refund < ActiveRecord::Base
    self.table_name = :refunds
  end

  def up
    Refund.delete_all
  end

  def down
    # NOOP
  end
end
