require 'rails_helper'

RSpec.describe Api::V1::CheckoutsController do
    describe 'POST #checkout', type: :request do
        before do
            @headers = { content_type: "application/json" }
        end

        it 'should returns a cart' do
            post '/api/v1/checkouts', params: { ids: ["AP1", "AP1", "MA1"] }, headers: @headers
            json_response = JSON.parse(response.body)   

            expect(response).to have_http_status(:success)
        end

        it "should display a greeting message" do
            post '/api/v1/checkouts', params: { ids: ["AP1", "AP1", "MA1"] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["message"]).to eq("This is your bill. Come back soon!")
        end

        it "should display the total amount to pay" do
            post '/api/v1/checkouts', params: { ids: ["AP1", "LN1", "HP1", "HP1"] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["total_price"]).to eq("The total amount to pay is 179€")
        end

        it "should apply the 10% discount on two or more Macbooks" do
            post '/api/v1/checkouts', params: { ids: ["AP1", "AP1"] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["total_price"]).to eq("The total amount to pay is 108€")
        end

        it "should apply a 'Buy one get one free discount' if the users buys 2 or more Lenovos" do
            post "/ap1/v1/checkouts", params: { ids: ["AP1", "LN1", "LN1"] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["total_price"])to eq("The total amount to pay is 101€")
        end
    
        it 'should display an error message when the array of ids is empty' do
            post '/api/v1/checkouts', params: { ids: [] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["message"]).to eq('Your cart is empty!')
        end
    end
end
