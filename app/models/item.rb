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
end