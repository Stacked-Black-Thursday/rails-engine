
require 'rails_helper'

RSpec.describe 'Revenue for items', type: :request do
  describe 'items with the most revenue' do
    before :each do
      seed_test_db
    end
    describe 'happy path' do
      it "up to top 10 items when the quantity is not provided" do
        get "/api/v1/revenue/items"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(10)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@item11.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:name)
        expect(json[:data].first[:attributes][:name]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:description)
        expect(json[:data].first[:attributes][:description]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:description)
        expect(json[:data].first[:attributes][:description]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:unit_price)
        expect(json[:data].first[:attributes][:unit_price]).to be_a(Float)
        expect(json[:data].first[:attributes]).to have_key(:merchant_id)
        expect(json[:data].first[:attributes][:merchant_id]).to be_a(Integer)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(json[:data].second[:attributes][:revenue]).to eq(8550.0)
      end

      it "top item when the quantity 1 is provided" do
        quantity = 1
        get "/api/v1/revenue/items?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(1)
        expect(json[:data].first[:id]).to eq(@item11.id.to_s)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
      end

      it "all items if quantity is too large" do
        quantity = 101
        get "/api/v1/revenue/items?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(12)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@item11.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(json[:data].last[:attributes][:revenue]).to eq(1.0)
      end
    end

    describe 'sad path' do
      it "returns an error when the quantity is blank" do
        quantity = ''
        get "/api/v1/revenue/items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "returns an error if the quantity is not an integer" do
        quantity = 'asdj'
        get "/api/v1/revenue/items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "returns an error if the quantity is 0 or less" do
        quantity = 0
        get "/api/v1/revenue/items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end
