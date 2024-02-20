require 'rails_helper'

RSpec.describe Search, type: :model do
  it { should have_many(:search_events) }
  it { should validate_presence_of(:session_id) }
  it { should validate_uniqueness_of(:session_id) }
end
