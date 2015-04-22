require_relative "../test_helper"

class CharactersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show Spider-Man page" do
    character = characters(:spider_man)

    get :show, :id => character.id

    assert_response :success
    assert_template :show

    assert_select "div.panel-heading" do
      assert_select "h3", character.name
    end
  end
end