require 'test_helper'

class Customers::DeliveriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_deliveries_index_url
    assert_response :success
  end

  test "should get edit" do
    get customers_deliveries_edit_url
    assert_response :success
  end

end
