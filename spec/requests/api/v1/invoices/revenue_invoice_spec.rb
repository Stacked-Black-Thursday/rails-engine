require 'rails_helper'

RSpec.describe 'Revenue for invoices', type: :request do
  describe 'potential revenue for all invoices that are packaged' do
    before :each do
      seed_test_db
    end
    describe 'happy path' do
      it "up to 10 top invoices when no quantity is provided" do
        get "/api/v1/revenue/unshipped"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(10)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@invoice6.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:potential_revenue)
        expect(json[:data].first[:attributes][:potential_revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:potential_revenue]).to eq(20770.0)
        expect(json[:data].second[:attributes][:potential_revenue]).to eq(4000.0)
      end

      it "top invoice when the quantity 1 is provided" do
        quantity = 1
        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(1)
        expect(json[:data].first[:id]).to eq(@invoice6.id.to_s)
        expect(json[:data].first[:attributes]).to have_key(:potential_revenue)
        expect(json[:data].first[:attributes][:potential_revenue]).to eq(20770.0)
      end

      it "all invoices if quantity is too large" do
        quantity = 100
        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(11)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:id]).to eq(@invoice6.id.to_s)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:potential_revenue)
        expect(json[:data].first[:attributes][:potential_revenue]).to be_a(Float)
        expect(json[:data].first[:attributes][:potential_revenue]).to eq(20770.0)
        expect(json[:data].last[:attributes][:potential_revenue]).to eq(100.0)
      end
    end

    describe 'sad path' do
      it "returns an error when the quantity is blank" do
        quantity = ''
        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "returns an error if the quantity is not an integer" do
        quantity = 'asdj'
        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end

      it "returns an error if the quantity is less than 0" do
        quantity = -1
        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
      end
    end
  end
end
