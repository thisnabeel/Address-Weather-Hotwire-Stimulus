require 'test_helper'

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get forecast data" do
    place_id = "ChIJ674hC6Y_WBQRujtC6Jay33k"
    post "/weather/forecast" , params: { place_id: place_id }

    assert_response :success
  end
end