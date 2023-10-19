class Item < ApplicationRecord
  belongs_to :merchant

  def self.search_by_name(name)
    Item.where("LOWER(name) LIKE ?", "%#{name.downcase}%").order(:name)
  end

  def self.search_by_max_price(max_price)
    Item.where("unit_price <= ?", max_price).order(:unit_price)
  end

  def self.search_by_min_price(min_price)
    Item.where("unit_price >= ? AND unit_price > 0", min_price).order(:unit_price)
  end

  def self.search_one_by(name)
    Item.where("LOWER(name) LIKE ?", "%#{name.downcase}%").order(:name).first
  end

  def self.search_one_by_max(max_price)
    Item.where("unit_price <= ?", max_price).order(:name).first
  end

  def self.search_one_by_min(min_price)
    Item.where("unit_price >= ? AND unit_price > 0", min_price).order(:name).first
  end
end