require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get user_search" do
    get searches_user_search_url
    assert_response :success
  end

  test "should get tag_search" do
    get searches_tag_search_url
    assert_response :success
  end
end
