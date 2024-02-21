class AddIpAddressToSearches < ActiveRecord::Migration[7.1]
  def change
    add_column :searches, :ip_address, :string
  end
end
