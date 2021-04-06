require 'rails_helper'

describe 'find a all merchants' do
  describe 'happy path' do
    it "finds all merchants by name fragment" do
      merchant1 = create(:merchant, name: "Fancy Merchant")
      merchant2 = create(:merchant, name: "A Really Fancy Merchant")
      merchant3 = create(:merchant, name: "Merchant Name")
      fragment = 'fancy'

      get "/api/v1/merchants/find_all?name=#{fragment}"

      json = JSON.parse(response.body, symbolize_names: true)
      # require "pry"; binding.pry
      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json[:data].count).to eq(2)
      expect(json[:data].first).to have_key(:id)
      expect(json[:data].first[:id]).to be_a(String)
      expect(json[:data].first[:id]).to eq(merchant2.id.to_s)
      expect(json[:data].last[:id]).to eq(merchant1.id.to_s)
      expect(json[:data].include?(merchant3.id.to_s)).to eq(false)
      expect(json[:data].first[:attributes]).to be_a(Hash)
      expect(json[:data].first[:attributes]).to have_key(:name)
      expect(json[:data].first[:attributes][:name]).to be_a(String)
    end
  end

  describe 'sad path' do
    it "if nothing is found it returns an empty collection" do
      fragment = 'fancy'

      get "/api/v1/merchants/find_all?name=#{fragment}"

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(json.count).to eq(1)
      expect(json[:data]).to be_a(Array)
      expect(json[:data].empty?).to eq(true)
    end
  end
end
