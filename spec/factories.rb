# frozen_string_literal: true

FactoryGirl.define do
  factory :account do
    id { SecureRandom.uuid }
    name { FakeData.fake_string 'Account' }
    created_user_id { FakeData.fake_string 'user' }
    currency_code { FFaker::Currency.code }
    display_order { rand(100) }
    ledger
  end

  factory :ledger do
    id { SecureRandom.uuid }
    name { FakeData.fake_string 'Ledger' }
    created_user_id { FakeData.fake_string 'user' }
    currency_code :gb
  end
end
