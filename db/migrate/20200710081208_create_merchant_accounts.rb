# frozen_string_literal: true

class CreateMerchantAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :merchant_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
