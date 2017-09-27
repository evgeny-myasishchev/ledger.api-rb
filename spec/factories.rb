# frozen_string_literal: true

FactoryGirl.define do
  factory :account do
    id { SecureRandom.uuid }
    name { Faker::Company.name }
  end
end
