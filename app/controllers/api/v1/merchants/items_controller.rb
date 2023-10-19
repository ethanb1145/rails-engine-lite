class Api::V1::Merchants::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    merchant = Merchant.find(params[:merchant_id])
    items = merchant.items
    render json: ItemSerializer.new(items)
  end

  private

  def not_found_response(error)
    render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404))
      .serialize_json, status: 404
  end
end