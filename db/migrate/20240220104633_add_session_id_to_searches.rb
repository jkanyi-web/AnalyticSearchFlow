class AddSessionIdToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :session_id, :string
  end
end
