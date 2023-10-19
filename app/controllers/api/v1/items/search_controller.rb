class Api::V1::Items::SearchController < ApplicationController
  def find_all
    if params[:name]
      items = Item.search_by_name(params[:name])
      render json: ItemSerializer.new(items)

    elsif params[:max_price]
      items = Item.search_by_max_price(params[:max_price])
      render json: ItemSerializer.new(items)

    elsif params[:min_price]
      items = Item.search_by_min_price(params[:min_price])
      render json: ItemSerializer.new(items)

    else
      render json: { error: "Not found" }, status: :not_found
    end
  end
end