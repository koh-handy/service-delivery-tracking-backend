require easypost
EasyPost.api_key = "EZTK64db8af78176488188cd7d21dc422f2392gIr0Rbi6BMXA50iAp0nQ"

Rails.application.routes.draw do

  post "/track/:tracking_number" do

  end

  post "/easypost-webhook" do
    result = params["result"]

    case result["object"]
    when "Batch"
      batch = EasyPost::Batch.new(result)

      case batch.state
      when "purchase_failed"
        batch.shipments.each do |shipment|
          if shipment.batch_status == "postage_purchase_failed"
            batch.remove_shipments([shipment])
          end
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
