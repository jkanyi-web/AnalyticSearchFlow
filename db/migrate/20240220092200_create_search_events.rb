class CreateSearchEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :search_events do |t|
      t.references :search, null: false, foreign_key: true

      t.timestamps
    end
  end
end
