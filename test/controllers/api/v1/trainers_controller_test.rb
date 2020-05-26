require 'test_helper'

class Api::V1::TrainersControllerTest < ActionDispatch::IntegrationTest
  test "should get name:string" do
    get api_v1_trainers_name:string_url
    assert_response :success
  end

end
