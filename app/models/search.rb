class Search < ApplicationRecord
  validates :query, presence: true
  validates :session_id, presence: true
  validates :ip_address, presence: true
end
