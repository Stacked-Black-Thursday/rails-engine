require 'rails_helper'

RSpec.describe 'Revenue for a merchant', type: :request do
  describe 'total revenue for a single merchant' do
    before :each do
      seed_test_db
    end
    describe 'happy path' do
      it "returns the total revenue by merchant when valid id" do

        get "/api/v1/revenue/merchants/#{@merchant10.id}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(3)
        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_a(String)
        expect(json[:data][:id]).to eq(@merchant10.id.to_s)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes]).to have_key(:revenue)
        expect(json[:data][:attributes][:revenue]).to be_a(Float)
        expect(json[:data][:attributes][:revenue]).to eq(250.00)
      end
    end

    describe 'sad path' do
      it "it returns an erorr if the merchant id is invalid" do

        get "/api/v1/revenue/merchants/18461615"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'merchants with the most revenue' do
    before :each do
      seed_test_db
    end
    describe 'happy path' do
      it "10 top merchants when with a quantity of 10" do
        quantity = 10
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(10)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@merchant9.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:name)
        expect(json[:data].first[:attributes][:name]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(json[:data].second[:attributes][:revenue]).to eq(10880.35)
      end

      it "top merchant when the quantity 1 is provided" do
        quantity = 1
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(1)
        expect(json[:data].first[:id]).to eq(@merchant9.id.to_s)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
      end

      it "all merchants if quantity is too large" do
        quantity = 101
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(11)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@merchant9.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:revenue)
        expect(json[:data].first[:attributes][:revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:revenue]).to eq(11400.0)
        expect(json[:data].last[:attributes][:revenue]).to eq(1.0)
      end
    end

    describe 'sad path' do
      it "returns an error when the quantity is not provided" do
        get "/api/v1/revenue/merchants"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "returns an error when the quantity is blank" do
        quantity = ''
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "returns an error if the quantity is not an integer" do
        quantity = 'asdj'
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "returns an error if the quantity is 0 or less" do
        quantity = -1
        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end
