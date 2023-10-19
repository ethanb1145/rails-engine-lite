class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    end
  end

  def update
    item = Item.update(params[:id], item_params)
    if item.save
      render json: ItemSerializer.new(item)
    else
      render json: { error: "Invalid Merchant ID." }, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    head :no_content
  end

  def merchant
    item = Item.find(params[:id])
    merchant = item.merchant
    render json: ItemSerializer.new(merchant)
  end
  
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def not_found_response(error)
    render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404))
      .serialize_json, status: 404
  end
end