require "test_helper"

class Api::SetlistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setlist = create :setlist
  end

  test "index" do
    get api_setlists_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "show" do
    get api_setlist_url(@setlist, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @setlist.title, body["title"]
  end

  test "add" do
    songsheet = create :songsheet

    put add_api_setlist_url(@setlist), params: {songsheet: {id: songsheet.id}}
    assert_response :success

    assert_includes @setlist.reload.songsheets, songsheet
  end
end
