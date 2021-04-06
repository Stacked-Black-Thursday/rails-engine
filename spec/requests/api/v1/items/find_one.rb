require 'rails_helper'

describe 'find a single item' do
  describe 'happy path' do
    it "finds one item by name fragment" do
      item1 = create(:item, name: "Fancy Item Name")
      item2 = create(:item, name: "A Really Fancy Item Name")
      item3 = create(:item, name: "Not Fancy Item Name")
      fragment = 'fancy'

      get "/api/v1/items/find?name=#{fragment}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to have_key(:id)
      expect(json[:data][:id]).to be_a(String)
      expect(json[:data][:id]).to_not eq(item1.id)
      expect(json[:data][:attributes]).to be_a(Hash)
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to be_a(String)
      expect(json[:data][:attributes][:name]).to eq(item2.name)
      expect(json[:data][:attributes]).to have_key(:unit_price)
      expect(json[:data][:attributes][:unit_price]).to be_a(Float)
      expect(json[:data][:attributes]).to have_key(:merchant_id)
      expect(json[:data][:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  describe 'sad path' do
    it "if nothing is found it returns an empty collection" do
      fragment = 'fancy'

      get "/api/v1/items/find?name=#{fragment}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Hash)
    end
  end
end
