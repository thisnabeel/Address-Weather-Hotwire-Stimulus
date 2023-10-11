require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home page with content" do
    get "/"
    assert_response :success

    assert_select 'h1'
    assert_select 'input'
  end
end
