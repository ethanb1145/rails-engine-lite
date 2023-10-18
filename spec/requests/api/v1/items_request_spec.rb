require "rails_helper"

RSpec.describe "Items API" do
  describe "get all items" do 
    it "should send a list of the items; happy path" do
      merchant = create(:merchant)
      create_list(:item, 5, merchant: merchant)

      get "/api/v1/items"

      expect(response).to be_successful

      data_response = JSON.parse(response.body, symbolize_names: true)
      items = data_response[:data]

      expect(items.count).to eq(5)

      items.each do |data|
        key_count = data.keys.count
        expect(key_count).to eq(3)

        expect(data).to have_key(:id)
        expect(data[:id]).to be_a(String)

        expect(data).to have_key(:type)
        expect(data[:type]).to be_a(String)

        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)

        attributes = data[:attributes]
        expect(attributes.length).to eq(4)

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)

        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a(String)

        expect(attributes).to have_key(:unit_price)
        expect(attributes[:unit_price]).to be_a(Float)

        expect(attributes).to have_key(:merchant_id)
        expect(attributes[:merchant_id]).to be_a(Integer)
      end
    end
  end

  describe "get one item" do 
    it "should get one item by id; happy path" do 
      id = create(:item).id
    
      get "/api/v1/items/#{id}"
    
      expect(response).to be_successful

      data_response = JSON.parse(response.body, symbolize_names: true)
      item_data = data_response[:data]

      key_count = item_data.keys.count
      expect(key_count).to eq(3)

      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)

      expect(item_data).to have_key(:type)
      expect(item_data[:type]).to be_a(String)
      
      expect(item_data).to have_key(:attributes)
      expect(item_data[:attributes]).to be_a(Hash)

      attributes = item_data[:attributes]
      expect(attributes.length).to eq(4)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
    end

    it "sad path; bad integer id returns 404" do
      invalid_id = 8923987297 

      get "/api/v1/items/#{invalid_id}"

      expect(response).to have_http_status(404)
    end
  end

  describe "create an item, delete an item" do
    it "should create an item and delete it" do
      merchant = create(:merchant).id
      item_params = ({
                    name: 'Item Name',
                    description: 'Item Description',
                    unit_price: 20.50, 
                    merchant_id: merchant
                  })
      
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/items", headers: headers, params: JSON.generate(item_params)
      
      expect(response).to be_successful
      expect(response).to have_http_status(201)

      created_item = Item.last
      expect(created_item).not_to be_nil

      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
  
      delete "/api/v1/items/#{created_item.id}"
      expect(response).to have_http_status(204)

      get "/api/v1/items/#{created_item.id}"

      expect(response).to have_http_status(404)
    
      expect{Item.find(created_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "update an item" do
    it "should update an item; happy path" do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: "Name" }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)
    
      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("Name")
    end
  end

  describe "get an item's merchant" do
    it "should get one merchant by id; happy path" do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)
      item_id = item.id

      get "/api/v1/items/#{item_id}/merchant"

      expect(response).to be_successful
      
      data_response = JSON.parse(response.body, symbolize_names: true)
      merchant = data_response[:data]
    end
  end
end