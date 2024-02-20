class AddQueryToSearchEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :search_events, :query, :string
  end
end
