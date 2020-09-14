# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { 'First_Name' }
    last_name { 'Last_Name' }
    age { 1 }
  end
end
