require 'rails_helper'

RSpec.describe SearchEvent, type: :model do
  it { should belong_to(:search) }
  it { should validate_presence_of(:event_type) }
  it { should validate_presence_of(:session_id) }
end
