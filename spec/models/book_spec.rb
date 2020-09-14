# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(3) }

  it { should belong_to(:author) }
end
