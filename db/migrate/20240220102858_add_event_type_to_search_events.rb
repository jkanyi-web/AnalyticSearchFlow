class AddEventTypeToSearchEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :search_events, :event_type, :string
  end
end
