class Api::V1::Items::SearchController < ApplicationController
  def find_all
    if params[:min_price].present? && params[:name].present? || params[:max_price].present? && params[:name].present?
      render json: { error: "Cannot send two at once." }, status: 400

    elsif params[:name].present?
      items = Item.search_by_name(params[:name])
      render json: ItemSerializer.new(items)

    elsif params[:max_price].present?
      if params[:max_price].to_f > 0
        items = Item.search_by_max_price(params[:max_price])
        render json: ItemSerializer.new(items)
      else
        render json: { errors: "Cannot send max price less than 0." }, status: 400
      end

    elsif params[:min_price].present?
      if params[:min_price].to_f > 0
        items = Item.search_by_min_price(params[:min_price])
        render json: ItemSerializer.new(items)
      else
        render json: { errors: "Cannot send min price less than 0." }, status: 400
      end

    else 
      render json: { error: "Not found." }, status: 400
    end
  end

  def find 
    if params[:min_price].present? && params[:name].present? || params[:max_price].present? && params[:name].present?
      render json: { error: "Cannot send two at once." }, status: 400

    elsif params[:min_price].present? && params[:max_price].present? && params[:min_price].to_f > params[:max_price].to_f
      render json: { error: "Min price cannot be greater than max price." }, status: 400

    elsif params[:name].present?
      item = Item.search_one_by(params[:name])
        if item
          render json: ItemSerializer.new(item)
        else
          render json: { data: { attributes: [] } }
        end

    elsif params[:max_price].present?
      if params[:max_price].to_f > 0
        item = Item.search_one_by_max(params[:max_price])
        if item.present?
          render json: ItemSerializer.new(item)
        else
          render json: { data: {} }
        end
      else
        render json: { errors: "Cannot send max price less than 0." }, status: 400
      end
        
    elsif params[:min_price].present?
      if params[:min_price].to_f > 0
        item = Item.search_one_by_min(params[:min_price])
        if item.present?
          render json: ItemSerializer.new(item)
        else
          render json: { data: {} }
        end
      else
        render json: { errors: "Cannot send min price less than 0." }, status: 400
      end

    else 
      render json: { error: "Not found." }, status: 400
    end
  end
end