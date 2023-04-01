# frozen_string_literal: true

class CreateSkus < ActiveRecord::Migration[6.0]
  def change
    create_table :skus do |t|
      t.string :name

      t.timestamps
    end
  end
end
