require 'test_helper'

class CitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get cities_show_url
    assert_response :success
  end

  test "should get destroy" do
    get cities_destroy_url
    assert_response :success
  end

end
