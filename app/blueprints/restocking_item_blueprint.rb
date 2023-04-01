# frozen_string_literal: true

class RestockingItemBlueprint < Blueprinter::Base
  identifier :id

  fields :quantity

  association :sku, blueprint: SkuBlueprint, view: :normal
end
