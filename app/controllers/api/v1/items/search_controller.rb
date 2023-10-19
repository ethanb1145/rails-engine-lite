class Api::V1::Items::SearchController < ApplicationController
  def find_all
    if params.key?(:name) && !params.key?(:max_price) && !params.key?(:min_price)
      items = Item.where("LOWER(name) LIKE ?", "%#{params[:name].downcase}%").order(:name)
      render json: ItemSerializer.new(items)

    elsif params.key?(:max_price) && !params.key?(:min_price) && !params.key?(:name)
      items = Item.where("unit_price <= ?", params[:max_price]).order(:unit_price)
      render json: ItemSerializer.new(items)

    elsif params.key?(:min_price) && !params.key?(:max_price) && !params.key?(:name)
      items = Item.where("unit_price >= ?", params[:min_price]).order(:unit_price)
      render json: ItemSerializer.new(items)

    else
      render json: { error: "Not found" }, status: :not_found
    end
  end
end