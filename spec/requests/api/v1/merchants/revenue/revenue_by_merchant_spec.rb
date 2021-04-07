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
end
