class DropSearchEvents < ActiveRecord::Migration[6.0]
  def up
    drop_table :search_events
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
