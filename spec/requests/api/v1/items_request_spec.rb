require 'rails_helper'

describe "Items API" do
  describe 'all items' do
    describe "happy path" do
      it "sends a list of items up to 20 items" do
        items = create_list(:item, 30)

        get '/api/v1/items'

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json[:data].count).to eq(20)
        expect(json[:data].first).to have_key(:id)
        expect(json[:data].first[:id]).to be_a(String)
        expect(json[:data].first[:attributes]).to be_a(Hash)
        expect(json[:data].first[:attributes]).to have_key(:name)
        expect(json[:data].first[:attributes][:name]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:description)
        expect(json[:data].first[:attributes][:description]).to be_a(String)
        expect(json[:data].first[:attributes]).to have_key(:unit_price)
        expect(json[:data].first[:attributes][:unit_price]).to be_a(Float)
        expect(json[:data].first[:attributes]).to have_key(:merchant_id)
        expect(json[:data].first[:attributes][:merchant_id]).to be_a(Integer)
      end

      it "sends a unique list of up to 20 items per page, and the page results do not repeat" do
        items = create_list(:item, 41)

        get '/api/v1/items?page=1'

        json1 = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json1.count).to eq(20)
        expect(json1.second[:id].to_i).to eq(json1.first[:id].to_i + 1)
        expect(json1.last[:id].to_i).to eq(json1.first[:id].to_i + 19)

        get '/api/v1/items?page=2'

        json2 = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json2.count).to eq(20)
        expect(json2.first[:id].to_i).to eq(json1.first[:id].to_i + 20)
        expect(json2.second[:id].to_i).to eq(json2.first[:id].to_i + 1)
        expect(json2.last[:id].to_i).to eq(json2.first[:id].to_i + 19)
      end

      it "sends a list of up to 20 items when there are less than that in the DB" do
        items = create_list(:item, 10)

        get '/api/v1/items?page=1'

        json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json.count).to eq(10)
      end

      it "sends list of items using per_page parameter that limits the returned results" do
        items = create_list(:item, 51)

        get '/api/v1/items?per_page=50'

        json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json.count).to eq(50)
        expect(json.last[:id]).to_not eq(items.last.id.to_s)
      end
    end

    describe 'sad path' do
      it "sends a list of up to 20 items when the page number is 0 or less" do
        items = create_list(:item, 30)

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
        item = items.first

        get "/api/v1/items/#{item.id}"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json.count).to eq(1)
        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_a(String)
        expect(json[:data][:id]).to_not eq(items.last.id)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes][:name]).to be_a(String)
      end
    end

    describe 'sad path' do
      it "returns a 404 when the id is not found" do
        get '/api/v1/items/8923987297'

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
        expect(returned_json[:message]).to eq("your request cannot be completed")
        expect(returned_json[:error]).to be_a(Array)
        expect(returned_json[:error][0]).to eq("Name can't be blank")
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

  describe 'udpate an item' do
    describe 'happy path' do
      it "updates an item record when provided valid data" do
        merchant = create(:merchant)
        item = create(:item)
        previous_name = Item.last.name
        previous_description = Item.last.description
        previous_unit_price = Item.last.unit_price
        previous_merchant_id = Item.last.merchant_id
        item_params = ({ name: 'Foo wand',
                      description: 'Creates bar magic',
                      unit_price: 15.99,
                      merchant_id: merchant.id
                      })
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
        returned_json = JSON.parse(response.body, symbolize_names: true)[:data]
        item.reload

        expect(item.name).to_not eq(previous_name)
        expect(item.description).to_not eq(previous_description)
        expect(item.unit_price).to_not eq(previous_unit_price)
        expect(item.merchant_id).to_not eq(previous_merchant_id)
        expect(response).to be_successful
        expect(response.status).to eq(202)
        expect(returned_json[:id]).to be_a(String)
        expect(returned_json[:attributes]).to be_a(Hash)
        expect(returned_json[:attributes]).to have_key(:name)
      end
    end

    describe 'sad path' do
      it "return an error if the item id is not found" do
        merchant = create(:merchant)
        item = create(:item)
        previous_name = Item.last.name
        previous_description = Item.last.description
        previous_unit_price = Item.last.unit_price
        previous_merchant_id = Item.last.merchant_id
        item_params = ({ name: 'Foo wand',
                      description: 'Creates bar magic',
                      unit_price: 15.99,
                      merchant_id: merchant.id
                      })
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/13165413", headers: headers, params: JSON.generate(item: item_params)
        returned_json = JSON.parse(response.body, symbolize_names: true)[:data]
        item.reload

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect(item.name).to eq(previous_name)
        expect(item.description).to eq(previous_description)
        expect(item.unit_price).to eq(previous_unit_price)
        expect(item.merchant_id).to eq(previous_merchant_id)
      end

      it "return an error if the merchant id is not found" do
        item = create(:item)
        previous_name = Item.last.name
        previous_description = Item.last.description
        previous_unit_price = Item.last.unit_price
        previous_merchant_id = Item.last.merchant_id
        item_params = ({ name: 'Foo wand',
                      description: 'Creates bar magic',
                      unit_price: 15.99,
                      merchant_id: 18416546
                      })
        headers = {"CONTENT_TYPE" => "application/json"}

        patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
        returned_json = JSON.parse(response.body, symbolize_names: true)[:data]
        item.reload

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(item.name).to eq(previous_name)
        expect(item.description).to eq(previous_description)
        expect(item.unit_price).to eq(previous_unit_price)
        expect(item.merchant_id).to eq(previous_merchant_id)
      end
    end
  end

  describe 'delete an item' do
    describe 'happy path' do
      it "destroys the current record when valid id provided" do
        items = create_list(:item, 2)
        item_id = items.first.id

        delete "/api/v1/items/#{item_id}"

        expect(response).to be_successful
        expect(response.status).to eq(204)
        expect{ Item.find(item_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "if a valid item id is the only item on an invoice, the item and invoice are destroyed" do
        invoices = create_list(:invoice, 2)
        items = create_list(:item, 2)
        invoice_1 = invoices.first
        invoice_2 = invoices.last
        item_1 = items.first
        item_2 = items.last
        invoice_1.items << item_1
        invoice_2.items << item_1
        invoice_2.items << item_2

        delete "/api/v1/items/#{item_1.id}"

        expect(response).to be_successful
        expect(response.status).to eq(204)
        expect{ Item.find(item_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect{ Invoice.find(invoice_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(Invoice.find(invoice_2.id)).to eq(invoice_2)
      end
    end

    describe 'sad path' do
      it "does not destroy the item record when item id is invalid" do

        delete "/api/v1/items/15468456514"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'get merchant data for an item' do
    describe 'happy path' do
      it "sends the merchant data back for an item with valid id" do
        merchant = create(:merchant)
        item = create(:item, merchant_id: merchant.id)

        get "/api/v1/items/#{item.id}/merchant"

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(json.count).to eq(1)
        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_a(String)
        expect(json[:data][:attributes]).to be_a(Hash)
        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes][:name]).to be_a(String)
        expect(json[:data][:attributes][:name]).to eq(merchant.name)
      end
    end

    describe 'sad path' do
      it "sends an error when the item id is invalid" do
        get '/api/v1/items/8923987297/merchant'

        expect(response.status).to eq(404)
        expect(response).to be_not_found
      end
    end
  end
end
