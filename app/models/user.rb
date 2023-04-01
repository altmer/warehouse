# frozen_string_literal: true

class User < ApplicationRecord
  has_one :merchant_account
  has_one :merchant, through: :merchant_account
end
