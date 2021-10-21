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
            post '/api/v1/checkouts', params: { ids: ["AP1", "AP1"] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["total_price"]).to eq("The total amount to pay is 108€")
        end
    
        it 'should display an error message when the array of ids is empty' do
            post '/api/v1/checkouts', params: { ids: [] }, headers: @headers
            json_response = JSON.parse(response.body)

            expect(json_response["message"]).to eq('Your cart is empty!')
        end
    end
end
