module Api
  module V1
    class RestockingShipmentController < ApiController
      before_action :authenticate_request!

      def new
        merchant = Merchants::FetchUserMerchant.call(@current_user.id).result
        return fail! 'configure merchant' unless merchant

        outcome = RestockingShipments::CreateRestockingShipment.call(merchant, new_params.to_h)
        return fail! outcome.error if outcome.failure?

        success! RestockingShipmentBlueprint.render_as_hash(outcome.result, view: :extended)
      end

      def show
        merchant = Merchants::FetchUserMerchant.call(@current_user.id).result
        return fail! 'configure merchant' unless merchant

        restocking_shipment = RestockingShipment.find_by(id: params[:id].to_i, merchant: merchant)
        return not_found! "restocking shipment for merchant #{merchant.id} does not exist" unless restocking_shipment

        success! RestockingShipmentBlueprint.render_as_hash(restocking_shipment, view: :extended)
      end

      private

      def new_params
        params.permit(:shipping_cost, :estimated_arrival_date, :tracking_code, shipper: {}, skus: [:id, :quantity])
      end
    end
  end
end
