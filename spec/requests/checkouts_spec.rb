require 'rails_helper'

RSpec.describe Api::V1::CheckoutsController, type: :request do
    describe 'POST #checkout', type: :request do
        before(:context) do
            Laptop.destroy_all
            @headers = { content_type: "application/json" }

            laptop_codes = ["AP1", "LN1", "HP1"]
            laptop_names = ["Macbook Pro 13", "Lenovo Thinkpad", "HP 850 G5"]
            laptop_prices = [60, 41, 39]
    
            laptop_codes.each_with_index do |code, ind|
                Laptop.create!(code: code, name: laptop_names[ind], price: laptop_prices[ind])
            end
        end

        it 'should returns a cart' do
            post api_v1_checkouts_path(ids: ["AP1", "AP1", "MA1"]), headers: @headers
            json_response = JSON.parse(response.body)   

            expect(response).to have_http_status(:success)
        end

        it "should display a greeting message" do
            post api_v1_checkouts_path(ids: ["AP1", "AP1", "MA1"]), headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["message"]).to eq("This is your bill. Come back soon!")
        end

        it "should display the total amount to pay" do
            post api_v1_checkouts_path, params: { ids: ["AP1", "LN1", "HP1", "HP1"] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["total_price"]).to eq("The total amount to pay is 179€")
        end

        describe 'Buy one get one free discount' do
            it "should apply a 'Buy one get one free discount' if the users buys 2 Lenovos" do
                post api_v1_checkouts_path, params: { ids: ["LN1", "LN1"] }, headers: @headers
                json_response = JSON.parse(response.body)

                expect(json_response["total_price"]).to eq("The total amount to pay is 41€")
            end

            it "should apply a 'Buy one get one free discount' if the users buys 3 Lenovos" do
                post api_v1_checkouts_path, params: { ids: ["LN1", "LN1", "LN1"] }, headers: @headers
                json_response = JSON.parse(response.body)

                expect(json_response["total_price"]).to eq("The total amount to pay is 82€")
            end

            it "should apply a 'Buy one get one free discount' if the users buys 2 Lenovos and 1 Macbook" do
                post api_v1_checkouts_path, params: { ids: ["AP1", "LN1", "LN1"] }, headers: @headers
                json_response = JSON.parse(response.body)

                expect(json_response["total_price"]).to eq("The total amount to pay is 101€")
            end

            it "should apply a 'Buy one get one free discount' if the users buys 2 Lenovos, 1 Macbook and 1 HP 850 GP" do
                post api_v1_checkouts_path, params: { ids: ["AP1", "LN1", "LN1", "HP1"] }, headers: @headers
                json_response = JSON.parse(response.body)

                expect(json_response["total_price"]).to eq("The total amount to pay is 140€")
            end
        end

        describe '10% discount on 2 or more Lenovo Thinkpads' do
            it "should apply the 10% discount on 2 Macbooks" do
                post api_v1_checkouts_path, params: { ids: ["AP1", "AP1"] }, headers: @headers
                json_response = JSON.parse(response.body)
    
                expect(json_response["total_price"]).to eq("The total amount to pay is 108€")
            end 

            it 'should apply the 10% discount on 3 Macbooks' do
                post api_v1_checkouts_path, params: { ids: ["AP1", "AP1", "AP1"] }, headers: @headers
                json_response = JSON.parse(response.body)

                expect(json_response["total_price"]).to eq("The total amount to pay is 162€")
            end

            it "should apply the 10% discount on 2 Macbooks and 1 Lenovo Thinkpad" do
                post api_v1_checkouts_path, params: { ids: ["AP1", "AP1", "LN1"] }, headers: @headers
                json_response = JSON.parse(response.body)
    
                expect(json_response["total_price"]).to eq("The total amount to pay is 149€")
            end 

            it "should apply the 10% discount on 2 Macbooks 1 Lenovo and 1 HP 850 GP" do
                post api_v1_checkouts_path, params: { ids: ["AP1", "AP1", "LN1", "HP1"] }, headers: @headers
                json_response = JSON.parse(response.body)
    
                expect(json_response["total_price"]).to eq("The total amount to pay is 188€")
            end 
        end

        describe 'Alert messages' do
            it 'should display an error message when the array of ids is empty' do
                post api_v1_checkouts_path, params: { ids: [] }, headers: @headers
                json_response = JSON.parse(response.body)
    
                expect(json_response["message"]).to eq('Something went wrong!')
            end

            it "should display an error message when there the given code does not correspond with an existing Laptop" do
                post api_v1_checkouts_path, params: { ids: ["ap"] }, headers: @headers
                json_response = JSON.parse(response.body)
    
                expect(json_response["message"]).to eq('Something went wrong!')
            end
        end

    end
end
