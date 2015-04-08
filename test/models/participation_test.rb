require_relative "../test_helper"

class ParticipationTest < ActiveSupport::TestCase
  test "should associate a new comic to a character" do
    comic = Comic.create!(:title => "Incredible Hulks (2009) #619", :comic_id => 34050, :issue => 619)

    character = characters(:spider_man)
    assert_difference 'character.comics.count' do
      character.comics << comic
    end
  end

  test "should associate a new character to a comic" do
    character = Character.create!(:name => "Bishop", :character_id => 1009182)

    comic = comics(:spider_man_2)
    assert_difference 'comic.characters.count' do
      comic.characters << character
    end
  end

  test "should not associate an character to an already related comic" do
    comic = comics(:spider_man_2)
    character = characters(:spider_man)

    assert_raises(ActiveRecord::RecordInvalid){ character.comics << comic }
  end

  test "should Carnage and Spider Man have comics in common" do
    spider_man = characters(:spider_man)
    carnage = characters(:carnage)

    common_comics = carnage.comics & spider_man.comics

    assert_equal common_comics.count, 1
  end

  test "should Carnage and Ben Parker have no comics in common" do
    ben = characters(:uncle_ben)
    carnage = characters(:carnage)

    common_comics = carnage.comics & ben.comics

    assert_equal common_comics.count, 0
  end
end