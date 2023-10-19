class Merchant < ApplicationRecord
  has_many :items

  def self.search_by_name(name)
    Merchant.where("LOWER(name) LIKE ?", "%#{name.downcase}%").order(:name).first
  end
end