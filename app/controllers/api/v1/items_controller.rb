class Api::V1::ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :merchant_not_found

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
    item = Item.update!(params[:id], item_params)

    if item.save
      render json: ItemSerializer.new(item)
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

  def record_not_found
    render json: { error: "Item not found" }, status: :not_found
  end

  def merchant_not_found
    render json: { error: "Merchant not found" }, status: :not_found
  end
end