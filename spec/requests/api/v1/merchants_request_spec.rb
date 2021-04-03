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

  it "sends one merchant" do

  end

  it "sends a list of all items for a single merchant by id" do

  end
end
