# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  it { should have_many(:books).dependent(:destroy) }
end
