class Api::V1::MerchantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  private 

  def not_found_response(error)
    render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404))
      .serialize_json, status: 404
  end
end