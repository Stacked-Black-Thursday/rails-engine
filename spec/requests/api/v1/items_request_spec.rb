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
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)
        expect(items[:data].first[:attributes][:merchant_id]).to be_a(Integer)
      end

      it "sends a unique list of up to 20 items per page, and the page results do not repeat" do
        create_list(:item, 41)

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

      it "sends a list of up to 20 items when there are less than that in the DB" do
        create_list(:item, 10)

        get '/api/v1/items?page=1'

        items = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(items.count).to eq(10)
      end
    end

    describe 'sad path' do
      it "sends a lit of up to 20 items when the page number is 0 or less" do
        create_list(:item, 30)

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
      it "sends a single item by id" do
        items = create_list(:item, 2)
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
      it "returns a 404 when the id is not found" do
        get '/api/v1/items/8923987297'

        data = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(response).to be_not_found
      end
    end
  end

  describe 'create an item' do
    describe 'happy path' do
      it "creates an item record when provided valid data" do
        merchant = create(:merchant)
        item_params = ({
                      name: 'Foo wand',
                      description: 'Creates bar magic',
                      unit_price: 15.99,
                      merchant_id: merchant.id
                      })
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
        created_item = Item.last
        returned_json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(created_item.name).to eq(item_params[:name])
        expect(created_item.merchant.id).to eq(item_params[:merchant_id])
        expect(created_item.description).to eq(item_params[:description])
        expect(created_item.unit_price).to eq(item_params[:unit_price])
        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(returned_json[:id]).to be_a(String)
        expect(returned_json[:attributes]).to be_a(Hash)
        expect(returned_json[:attributes]).to have_key(:name)
        expect(returned_json[:attributes][:name]).to be_a(String)
        expect(returned_json[:attributes]).to have_key(:unit_price)
        expect(returned_json[:attributes][:unit_price]).to be_a(Float)
      end
    end

    describe 'sad path' do
      it "return an error if any attribute is missing " do
        merchant = create(:merchant)
        item_params = ({
                      description: 'Creates bar magic',
                      unit_price: 15.99,
                      merchant_id: merchant.id
                      })
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
        created_item = Item.last
        returned_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(406)
        expect(created_item).to be_nil
        expect(returned_json[:message]).to be_a(String)
        expect(returned_json[:message]).to eq("your request cannot be completed")
        expect(returned_json[:errors]).to be_a(Array)
        expect(returned_json[:errors][0]).to eq("Name can't be blank")
      end

      it "ignores any attributes that are not allowed" do
        merchant = create(:merchant)
        item_params = ({
                      name: 'Foo Wand',
                      description: 'Creates bar magic',
                      unit_price: 15.99,
                      merchant_id: merchant.id,
                      rainbows: "YAY!"
                      })
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

        created_item = Item.last
        returned_json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(created_item.name).to eq(item_params[:name])
        expect(created_item.merchant.id).to eq(item_params[:merchant_id])
        expect(created_item.description).to eq(item_params[:description])
        expect(created_item.unit_price).to eq(item_params[:unit_price])
        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(returned_json[:attributes].include?(:rainbows)).to eq(false)
      end
    end
  end
end
