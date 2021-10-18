require 'test_helper'

class Api::V1::CheckoutsControllerTest < ActionDispatch::IntegrationTest

  test "should get create" do
    post '/api/v1/checkouts', params: { ids: ["AP1", "AP1", "MA1"] } 
    assert_response :success
  end

end
