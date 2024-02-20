class Search < ApplicationRecord
  has_many :search_events

  validates :session_id, presence: true, uniqueness: true
end
