require_relative "../test_helper"

class ComicTest < ActiveSupport::TestCase
  test "should not save a comic without an Marvel ID" do
    comic = Comic.new
    assert_not comic.save
  end

  test "should not save a comic with an existing Marvel ID" do
    comic = Comic.new(:comic_id => 6587)
    assert_not comic.save
  end

  test "should save a comic with a properly Marvel ID" do
    comic = Comic.new(:title => "Incredible Hulks (2009) #619", :comic_id => 34050, :issue => 619)
    assert comic.save
  end
end