# frozen_string_literal: true

FactoryGirl.define do
  factory :account_category do
    name { FakeData.fake_string 'Category' }
    display_order { rand(100) }
    ledger
  end

  factory :transaction_tag do
    name { FakeData.fake_string 'Category' }
    ledger
  end

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

  factory :ledger_user do
    user_id { FakeData.fake_string 'user' }
    ledger
  end

  factory :user do
    sub { FakeData.fake_string 'user' }
    scope { "#{FakeData.fake_string('scope-1')},#{FakeData.fake_string('scope-2')}" }
    initialize_with { new('sub' => sub, 'scope' => scope) }
  end
end
