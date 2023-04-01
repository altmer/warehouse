# frozen_string_literal: true

FactoryBot.define do
  factory :merchant_account do
    merchant { build(:merchant) }
    user { build(:user) }
  end
end