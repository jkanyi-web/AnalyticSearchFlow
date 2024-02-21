require 'rails_helper'

RSpec.describe Search, type: :model do
  it { should validate_presence_of(:session_id) }
end
