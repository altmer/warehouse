Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      scope :user do
        scope :restocking_shipments do
          post '/', to: 'restocking_shipment#new'
        end

        scope :restocking_shipment do
          get '/:id', to: 'restocking_shipment#show', constraints: {id: /\d+/}
        end
      end
    end
  end
end