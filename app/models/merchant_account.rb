# frozen_string_literal: true

class MerchantAccount < ApplicationRecord
  belongs_to :user
  belongs_to :merchant
end
