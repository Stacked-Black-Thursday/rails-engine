require 'rails_helper'

describe "Merchants API" do
  describe 'all merchants' do
    describe "happy path" do
      it "sends a list of merchants up to 20 merchants" do
        create_list(:merchant, 30)

        get '/api/v1/merchants'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(merchants[:data].count).to eq(20)
        expect(merchants[:data].first).to have_key(:id)
        expect(merchants[:data].first[:id]).to be_a(String)
        expect(merchants[:data].first[:attributes]).to be_a(Hash)
        expect(merchants[:data].first[:attributes]).to have_key(:name)
        expect(merchants[:data].first[:attributes][:name]).to be_a(String)
      end

      it "sends a unique list of up to 20 merchants per page, and the page results do not repeat" do
        create_list(:merchant, 41)

        get '/api/v1/merchants?page=1'

        merchants1 = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(merchants1.count).to eq(20)
        expect(merchants1.second[:id].to_i).to eq(merchants1.first[:id].to_i + 1)
        expect(merchants1.last[:id].to_i).to eq(merchants1.first[:id].to_i + 19)

        get '/api/v1/merchants?page=2'

        merchants2 = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(merchants2.count).to eq(20)
        expect(merchants2.first[:id].to_i).to eq(merchants1.first[:id].to_i + 20)
        expect(merchants2.second[:id].to_i).to eq(merchants2.first[:id].to_i + 1)
        expect(merchants2.last[:id].to_i).to eq(merchants2.first[:id].to_i + 19)
      end

      it "sends a list of up to 20 merchants when there are less than that in the DB" do
        create_list(:merchant, 10)

        get '/api/v1/merchants?page=1'

        merchants = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(merchants.count).to eq(10)
      end
    end

    describe 'sad path' do
      it "sends a lit of up to 20 merchants when the page number is 0 or less" do
        create_list(:merchant, 30)

        get '/api/v1/merchants?page=-1'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(merchants[:data].count).to eq(20)
        expect(merchants[:data].first).to have_key(:id)
      end
    end
  end

  describe 'one merchant' do
    describe 'happy path' do
      it "sends a single merchant by id" do
        merchants = create_list(:merchant, 2)
        merchant = merchants.first

        get "/api/v1/merchants/#{merchant.id}"

        data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(data.count).to eq(1)
        expect(data[:data]).to have_key(:id)
        expect(data[:data][:id]).to be_a(String)
        expect(data[:data][:id]).to_not eq(merchants.last.id)
        expect(data[:data][:attributes]).to be_a(Hash)
        expect(data[:data][:attributes]).to have_key(:name)
        expect(data[:data][:attributes][:name]).to be_a(String)
      end
    end

    describe 'sad path' do
      it "returns a 404 when the id is not found" do
        get '/api/v1/merchants/8923987297'

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(response).to be_not_found
      end
    end
  end

  describe 'all items for a single merchant' do
    describe 'happy path' do
      it "sends a list of all items when merchant id is valid" do
        merchants = create_list(:merchant, 2)
        merchant = merchants.first
        items = create_list(:item, 5, merchant_id: merchant.id)

        get "/api/v1/merchants/#{merchant.id}/items"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json.count).to eq(1)
        expect(json[:data].count).to eq(5)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to_not eq(merchants.last.id)
        expect(json[:data].first[:attributes]).to have_key(:name)
        expect(json[:data].first[:attributes][:name]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:description)
        expect(json[:data].first[:attributes][:description]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:unit_price)
        expect(json[:data].first[:attributes][:unit_price]).to be_a(Float)
        expect(json[:data].first[:attributes]).to have_key(:merchant_id)
        expect(json[:data].first[:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    describe 'sad path' do
      it "sends an error when the merchant id is invalid" do
        get '/api/v1/merchants/8923987297/items'

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(response).to be_not_found
      end
    end
  end
end
