require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get thank_you" do
    get messages_thank_you_url
    assert_response :success
  end
end
