require_relative "../test_helper"

class CharacterTest < ActiveSupport::TestCase
  test "should not save a character without an Marvel ID" do
    character = Character.new
    assert_not character.save
  end

  test "should not save a character with an existing Marvel ID" do
    character = Character.new(:character_id => 1009227)
    assert_not character.save
  end

  test "should save a character with a properly Marvel ID" do
    character = Character.new(:name => "Bishop", :character_id => 1009182)
    assert character.save
  end

  test "should find existing character by his name" do
    character = Character["Black Cat"]
    assert character

    character = Character["Carnage"]
    assert character
  end

  test "should not find non existing character by name" do
    character = Character["Cable"]
    assert_nil character
  end

  test "should differentiate character's type" do
    villain = Character["Carnage"]
    hero = Character["Spider-Man"]

    assert villain.class != hero.class

    assert_equal "Hero", hero.type
    assert_equal "Villain", villain.type
  end
end