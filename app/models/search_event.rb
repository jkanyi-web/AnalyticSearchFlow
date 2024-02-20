class SearchEvent < ApplicationRecord
  belongs_to :search

  validates :search_id, :event_type, :session_id, presence: true
end
