class Api::V1::Merchants::SearchController < ApplicationController
  def find
    if params[:name]
      merchant = Merchant.search_by_name(params[:name])

      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        render json: { data: { attributes: [] } }
      end
    end
  end
end