class Api::V1::Merchants::SearchController < ApplicationController
  def find
    merchant = Merchant.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%").order(:name).first

    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: { data: { attributes: [] } }
    end
  end
end