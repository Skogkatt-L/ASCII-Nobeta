require "test_helper"

class NobetaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get nobeta_index_url
    assert_response :success
  end

  test "should get nobeta" do
    get nobeta_nobeta_url
    assert_response :success
  end
end
