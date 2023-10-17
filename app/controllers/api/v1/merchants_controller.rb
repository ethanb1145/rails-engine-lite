class Api::V1::MerchantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  private

  def record_not_found
    render json: { error: "Merchant not found" }, status: :not_found
  end
end