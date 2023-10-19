require "rails_helper"

RSpec.describe "Item", type: :model do 
  describe "search by name" do 
    it "searches all items by name" do 
      item1 = create(:item, name: "Item One")
      item2 = create(:item, name: "Two Item")

      searched_items = Item.search_by_name("item")
      expect(searched_items).to include(item1, item2)
      expect(searched_items.length).to eq(2)
    end
  end

  describe "search by max price" do 
    it "searches by max price" do 
      item1 = create(:item, unit_price: 10)
      item2 = create(:item, unit_price: 20)

      searched_items = Item.search_by_max_price(15)
      expect(searched_items).to include(item1)
      expect(searched_items.length).to eq(1)
    end
  end
end