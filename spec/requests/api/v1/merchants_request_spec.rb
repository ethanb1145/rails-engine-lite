require "rails_helper"

RSpec.describe "Merchants API" do
  describe "get all merchants" do 
    it "should send a list of the merchants; happy path" do 
      create_list(:merchant, 5)

      get "/api/v1/merchants"

      expect(response).to be_successful

      data_response = JSON.parse(response.body, symbolize_names: true)
      merchants = data_response[:data]

      expect(merchants.count).to eq(5)

      merchants.each do |data|
        key_count = data.keys.count
        expect(key_count).to eq(3)

        expect(data).to have_key(:id)
        expect(data[:id]).to be_a(String)

        expect(data).to have_key(:type)
        expect(data[:type]).to be_a(String)

        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)

        attributes = data[:attributes]
        expect(attributes.length).to eq(1)

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)
      end
    end
  end

  describe "get one merchant" do 
    it "should get one merchant by id; happy path" do 
      id = create(:merchant).id
    
      get "/api/v1/merchants/#{id}"
    
      expect(response).to be_successful

      data_response = JSON.parse(response.body, symbolize_names: true)
      merchant_data = data_response[:data]

      key_count = merchant_data.keys.count
      expect(key_count).to eq(3)

      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_a(String)

      expect(merchant_data).to have_key(:type)
      expect(merchant_data[:type]).to be_a(String)
      
      expect(merchant_data).to have_key(:attributes)
      expect(merchant_data[:attributes]).to be_a(Hash)

      attributes = merchant_data[:attributes]
      expect(attributes.length).to eq(1)

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end

    it "sad path; bad integer id returns 404" do
      invalid_id = 8923987297 

      get "/api/v1/merchants/#{invalid_id}"

      expect(response).to have_http_status(404)
    end
  end

  describe "get a merchant's items" do 
    it "should give all items for a given merchant id; happy path" do 
      merchant = create(:merchant)
      create_list(:item, 5, merchant: merchant)
    
      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      data_response = JSON.parse(response.body, symbolize_names: true)
      items_data = data_response[:data]

      items_data.each do |data|
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

    it "sad path; bad integer id returns 404" do
      invalid_id = 8923987297 

      get "/api/v1/merchants/#{invalid_id}/items"

      expect(response).to have_http_status(404)
    end
  end
end