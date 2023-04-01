# frozen_string_literal: true

class SkuBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :name
  end
end
