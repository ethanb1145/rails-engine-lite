class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    begin
      render json: ItemSerializer.new(Item.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: 404
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    end
  end

  def update
    begin
      item = Item.update(params[:id], item_params)
      if item.save
        render json: ItemSerializer.new(item)
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: 404
    end
  end

  def destroy
    begin
      item = Item.find(params[:id])
      item.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: 404
    end
  end

  def merchant
    begin
      item = Item.find(params[:id])
      merchant = item.merchant
      render json: ItemSerializer.new(merchant)
    rescue ActiveRecord::RecordNotFound => e
      render json: ErrorSerializer.new(ErrorMessage.new(e.message, 404))
      .serialize_json, status: 404
    end
  end
  
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end