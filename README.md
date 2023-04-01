# Warehouse

## User Story

As a shop owner, I want to be able to announce a restocking shipment whenever I need to fill up my inventory in warehouse.

## Context

**What's a restocking shipment**: With `Restocking shipment` we concretely mean that a shop owner announces new inventory coming to warehouse at a specific point in time. You can imagine a shop selling different t-shirts (e.g. white, black and blue) and the white one almost being out of stock. In that case, the shop owner will likely re-order the white t-shirts and announce to us that there will be an inbound delivery.

## Tasks

The endpoint restocking_shipment_controller#new should take as input a POST request with a payload of the following form:
`{
    "estimated_arrival_date": "2020-07-01",
    "tracking_code": "YY",
    "shipper": {
        "shipment_provider_id": 1
     },
    "skus": [
        {"id": 1, "quantity": 2}
    ],
    "shipping_cost": 2
}`

And create the corresponding Restocking Shipment and Restocking Shipment Items. It should then return a JSON object containing the data for the newly created restocking shipment and restocking shipment items.

Please also add tests in RSpec for the things you implement - we really care about good testing practices, so make sure to invest enough time here!
