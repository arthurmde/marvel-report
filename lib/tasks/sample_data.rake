require 'active_record'
require 'marvel'
require 'marvel_parameters'
require File.dirname(__FILE__) + '/../../config/environment'

namespace :data do
  desc "Import sample data to development environment"
  task :all do
    Rake::Task["data:characters"].invoke
    Rake::Task["data:comics"].invoke
  end

  desc "Import sample characters' data to development environment"
  task :characters do
    Rails.env = "development"
    
    @characters.each do |character|
      Marvel.import_character(character)
      puts "#{character[:name]} data saved!"
    end
  end

  desc "Import sample comics' data to development environment"
  task :comics do
    Rails.env = "development"
    
    Character.all.each do |character|
      puts "Importing #{character[:name]}'s comics..."
      Marvel.import_character_comics(character)
      puts "...Done!"
    end
  end
end


@characters = []

@characters << {:id => 1009146, :name => "Abomination", :type => "Villain"}

@characters << {:id => 1009169, :name => "Baron Strucker", :type => "Villain"}
@characters << {:id => 1009489, :name => "Ben Parker", :type => "Civilian"}
@characters << {:id => 1009548, :name => "Betty Ross", :type => "Civilian"}
@characters << {:id => 1009185, :name => "Black Cat", :type => "Antihero"}
@characters << {:id => 1009187, :name => "Black Panther", :type => "Hero"}
@characters << {:id => 1009167, :name => "Bruce Banner", :type => "Civilian"}
@characters << {:id => 1009211, :name => "Bucky", :type => "Hero"}

@characters << {:id => 1009220, :name => "Captain America", :type => "Hero"}
@characters << {:id => 1009225, :name => "Captain Stacy", :type => "Civilian"}
@characters << {:id => 1009227, :name => "Carnage", :type => "Villain"}
@characters << {:id => 1009234, :name => "Chameleon", :type => "Villain"}
@characters << {:id => 1009252, :name => "Crossbones", :type => "Villain"}

@characters << {:id => 1009262, :name => "Daredevil", :type => "Hero"}
@characters << {:id => 1009281, :name => "Doctor Doom", :type => "Villain"}
@characters << {:id => 1009276, :name => "Doctor Octopus", :type => "Villain"}

@characters << {:id => 1009287, :name => "Electro", :type => "Villain"}

@characters << {:id => 1009297, :name => "Falcon", :type => "Hero"}

@characters << {:id => 1010928, :name => "Green Goblin (Harry Osborn)", :type => "Villain"}
@characters << {:id => 1009619, :name => "Gwen Stacy", :type => "Civilian"}

@characters << {:id => 1009486, :name => "Harry Osborn", :type => "Civilian"}
@characters << {:id => 1011490, :name => "Hank Pym", :type => "Civilian"}
@characters << {:id => 1009338, :name => "Hawkeye", :type => "Hero"}
@characters << {:id => 1009351, :name => "Hulk", :type => "Hero"}

@characters << {:id => 1009372, :name => "J. Jonah Jameson", :type => "Civilian"}
@characters << {:id => 1009382, :name => "Juggernaut", :type => "Villain"}

@characters << {:id => 1010842, :name => "King Cobra", :type => "Villain"}
@characters << {:id => 1009391, :name => "Kraven the Hunter", :type => "Villain"}

@characters << {:id => 1009398, :name => "Leader", :type => "Villain"}
@characters << {:id => 1009404, :name => "Lizard", :type => "Villain"}
@characters << {:id => 1009215, :name => "Luke Cage", :type => "Hero"}

@characters << {:id => 1010726, :name => "M.O.D.O.K.", :type => "Villain"}
@characters << {:id => 1009490, :name => "May Parker", :type => "Civilian"}
@characters << {:id => 1009464, :name => "Mysterio", :type => "Villain"}

@characters << {:id => 1009471, :name => "Nick Fury", :type => "Civilian"}
@characters << {:id => 1009325, :name => "Norman Osborn", :type => "Civilian"}

@characters << {:id => 1009491, :name => "Peter Parker", :type => "Civilian"}
@characters << {:id => 1009515, :name => "Punisher", :type => "Antihero"}

@characters << {:id => 1011360, :name => "Red Hulk", :type => "Antihero"}
@characters << {:id => 1009535, :name => "Red Skull", :type => "Villain"}
@characters << {:id => 1009537, :name => "Rhino", :type => "Villain"}

@characters << {:id => 1011223, :name => "Skaar", :type => "Antihero"}
@characters << {:id => 1009610, :name => "Spider-Man", :type => "Hero"}
@characters << {:id => 1010326, :name => "Steve Rogers", :type => "Civilian"}

@characters << {:id => 1009648, :name => "Taskmaster", :type => "Villain"}
@characters << {:id => 1009652, :name => "Thanos", :type => "Villain"}

@characters << {:id => 1009685, :name => "Ultron", :type => "Villain"}

@characters << {:id => 1010740, :name => "Winter Soldier", :type => "Antihero"}

@characters
