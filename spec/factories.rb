# frozen_string_literal: true

FactoryGirl.define do
  factory :create_account do
    id { SecureRandom.uuid }
    name { Faker::Company.name }

    to_create(&:process!)
  end
end
