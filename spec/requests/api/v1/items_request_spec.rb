require 'rails_helper'

describe "Items API" do
  describe 'all items' do
    describe "happy path" do
      it "sends a list of items up to 20 items" do
        create_list(:item, 30)

        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(items[:data].count).to eq(20)
        expect(items[:data].first).to have_key(:id)
        expect(items[:data].first[:id]).to be_a(String)
        expect(items[:data].first[:attributes]).to be_a(Hash)
        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes][:name]).to be_a(String)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes][:description]).to be_a(String)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes][:unit_price]).to be_a(Float)
      end

      it "sends a unique list of up to 20 items per page, and the page results do not repeat" do
        create_list(:merchant, 41)

        get '/api/v1/items?page=1'

        items1 = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(items1.count).to eq(20)
        expect(items1.second[:id].to_i).to eq(items1.first[:id].to_i + 1)
        expect(items1.last[:id].to_i).to eq(items1.first[:id].to_i + 19)

        get '/api/v1/items?page=2'

        items2 = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(items2.count).to eq(20)
        expect(items2.first[:id].to_i).to eq(items1.first[:id].to_i + 20)
        expect(items2.second[:id].to_i).to eq(items2.first[:id].to_i + 1)
        expect(items2.last[:id].to_i).to eq(items2.first[:id].to_i + 19)
      end

      xit "sends a list of up to 20 items when there are less than that in the DB" do
        create_list(:merchant, 10)

        get '/api/v1/items?page=1'

        items = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(items.count).to eq(10)
      end
    end

    describe 'sad path' do
      xit "sends a lit of up to 20 items when the page number is 0 or less" do
        create_list(:merchant, 30)

        get '/api/v1/items?page=-1'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(items[:data].count).to eq(20)
        expect(items[:data].first).to have_key(:id)
      end
    end
  end

  describe 'one item' do
    describe 'happy path' do
      xit "sends a single item by id" do
        items = create_list(:merchant, 2)
        merchant = items.first

        get "/api/v1/items/#{merchant.id}"

        data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(data.count).to eq(1)
        expect(data[:data]).to have_key(:id)
        expect(data[:data][:id]).to be_a(String)
        expect(data[:data][:id]).to_not eq(items.last.id)
        expect(data[:data][:attributes]).to be_a(Hash)
        expect(data[:data][:attributes]).to have_key(:name)
        expect(data[:data][:attributes][:name]).to be_a(String)
      end
    end

    describe 'sad path' do
      xit "returns a 404 when the id is not found" do
        get '/api/v1/items/8923987297'

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(response).to be_not_found
      end
    end
  end

  it "sends a list of all items for a single merchant by id" do

  end
end
