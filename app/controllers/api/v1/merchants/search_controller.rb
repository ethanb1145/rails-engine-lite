class Api::V1::Merchants::SearchController < ApplicationController
  def find
    if params[:name].present?
      merchant = Merchant.search_by_name(params[:name])

      if merchant
        render json: MerchantSerializer.new(merchant)
      else
        render json: { data: { attributes: [] } }
      end
    else 
      render json: { error: "Cannot send this param." }, status: 400
    end
  end

  def find_all
    if params[:name].present?
      merchants = Merchant.all_by_name(params[:name])

      if merchants
        render json: MerchantSerializer.new(merchants)
      else
        render json: { data: { attributes: [] } }
      end
    else
      render json: { error: "Cannot send this param." }, status: 400
    end
  end
end