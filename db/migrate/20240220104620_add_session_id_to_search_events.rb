class AddSessionIdToSearchEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :search_events, :session_id, :string
  end
end
