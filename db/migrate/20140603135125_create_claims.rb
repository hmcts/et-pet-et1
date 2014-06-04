class CreateClaims < ActiveRecord::Migration
  class << self
    def up
      enable_extension "uuid-ossp"

      create_table :claims, id: :uuid do |t|
        t.timestamps
      end
    end

    def down
      disable_extension "uuid-ossp"

      drop_table :claims
    end
  end
end
