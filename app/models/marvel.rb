class Marvel
  include HTTParty

  base_uri 'gateway.marvel.com:80'

  def self.character(id)
    response =
        self.get("/v1/public/characters/#{id}?#{MarvelParameters.credentials}")
    response_body = JSON.parse(response.body)
    results = response_body['data']['results'][0]
  end

  def self.import_characters
    characters = Marvel.characters_list

    characters.each do |current_character|
      response = self.get("/v1/public/characters/#{current_character[:id].to_s}?&#{MarvelParameters.credentials}")
      response_body = JSON.parse(response.body)

      Marvel.create_character(current_character, response_body)
    end
  end

  def self.import_characters_events
    Character.all.each do |character|
      response = self.get("/v1/public/characters/#{character.character_id}/events?limit=100&#{MarvelParameters.credentials}")
      response_body = JSON.parse(response.body)
      results = response_body['data']['results']

      results.each do |result|
        event = Event.where(:event_id => result['id']).first
        if event.blank?
          event = Event.new

          thumbnail = result['thumbnail']
          event.thumbnail = thumbnail.blank? ? "" : thumbnail['path']
          event.event_id = result['id']
          event.name = result['title']
          event.description = result['description']

          event.save!
        end

        character.event_characters.create(event: event)
      end
    end
  end

  def self.all_characters
    response = self.get("/v1/public/characters?nameStartsWith=z&orderBy=name&limit=100&offset=0&#{MarvelParameters.credentials}")
    response_body = JSON.parse(response.body)
    results = response_body['data']['results']
  end

  def self.comic(id)
    response =
        self.get("/v1/public/comics/#{id}?#{MarvelParameters.credentials}")
    response_body = JSON.parse(response.body)
    puts "RESPONSE BODY: #{response_body}"
    results = response_body['data']['results'][0]
  end

  def self.all_comics
    response =
        self.get("/v1/public/comics?#{MarvelParameters.credentials}")
    response_body = JSON.parse(response.body)
    results = response_body['data']['results']
  end

  def self.write_characters_node
    file = File.new("characters.txt", "w")

    Character.all.each do |character|
      file.puts character.character_id.to_s
      file.puts character.name
    end

    file.close
  end

  def self.write_events
    file = File.new("events.txt", "w")

    Event.all.each do |event|
      file.puts event.event_id.to_s
      file.puts event.name
      file.puts event.characters.count.to_s
      event.characters.all.each do |character|
        file.puts character.character_id.to_s
      end
    end

    file.close
  end

  private

  def self.create_character(current_character, response_body)
    if !response_body.nil? && !response_body['data'].nil? && !response_body['data']['results'].nil?
      results = response_body['data']['results']

      results.each do |result|
        character = current_character[:type].constantize.new

        thumbnail = result['thumbnail']
        character.thumbnail = thumbnail.blank? ? "" : thumbnail['path']
        character.character_id = result['id']
        character.name = result['name']
        character.description = result['description']
        character.events_uri = result['events']['collectionURI']

        character.save!

        puts "="*100, Character.last.inspect, "="*100
      end
    end
  end

  def self.characters_list
    characters = []

    characters << {:id => 1017100, :name => "A-Bomb (HAS)", :type => "Hero"}
    characters << {:id => 1009146, :name => "Abomination", :type => "Villain"}
    characters << {:id => 1009148, :name => "Absorbing Man", :type => "Villain"}
    characters << {:id => 1010354, :name => "Adam Warlock", :type => "Hero"}
    characters << {:id => 1009497, :name => "Alexander Pierce", :type => "Civilian"}
    characters << {:id => 1010672, :name => "Amora", :type => "Villain"}
    characters << {:id => 1009152, :name => "Ancient One", :type => "Hero"}
    characters << {:id => 1011396, :name => "Angel", :type => "Hero"}
    characters << {:id => 1010802, :name => "Ant-Man (Eric O'Grady)", :type => "Hero"}
    characters << {:id => 1010801, :name => "Ant-Man (Scott Lang)", :type => "Hero"}
    characters << {:id => 1009156, :name => "Apocalypse", :type => "Villain"}
    characters << {:id => 1010773, :name => "Arachne", :type => "Hero"}
    characters << {:id => 1010784, :name => "Ares", :type => "Villain"}
    characters << {:id => 1009740, :name => "Arnim Zola", :type => "Villain"}
    characters << {:id => 1009164, :name => "Avalanche", :type => "Villain"}
    characters << {:id => 1011766, :name => "Azazel", :type => "Villain"}

    characters << {:id => 1009169, :name => "Baron Strucker", :type => "Villain"}
    characters << {:id => 1009170, :name => "Baron Zemo (Heinrich Zemo)", :type => "Villain"}
    characters << {:id => 1010906, :name => "Baron Zemo (Helmut Zemo)", :type => "Villain"}
    characters << {:id => 1009172, :name => "Batroc the Leaper", :type => "Villain"}
    characters << {:id => 1009175, :name => "Beast", :type => "Hero"}
    characters << {:id => 1009329, :name => "Ben Grimm", :type => "Civilian"}
    characters << {:id => 1009489, :name => "Ben Parker", :type => "Civilian"}
    characters << {:id => 1009180, :name => "Beta-Ray Bill", :type => "Hero"}
    characters << {:id => 1009548, :name => "Betty Ross", :type => "Civilian"}
    characters << {:id => 1009182, :name => "Bishop", :type => "Hero"}
    characters << {:id => 1009184, :name => "Black Bolt", :type => "Hero"}
    characters << {:id => 1009185, :name => "Black Cat", :type => "Antihero"}
    characters << {:id => 1009187, :name => "Black Panther", :type => "Hero"}
    characters << {:id => 1009189, :name => "Black Widow", :type => "Antihero"}
    characters << {:id => 1009190, :name => "Blackheart", :type => "Villain"}
    characters << {:id => 1009191, :name => "Blade", :type => "Hero"}
    characters << {:id => 1009195, :name => "Blastaar", :type => "Villain"}
    characters << {:id => 1010830, :name => "Blazing Skull", :type => "Hero"}
    characters << {:id => 1009199, :name => "Blob", :type => "Villain"}
    characters << {:id => 1010371, :name => "Boomerang", :type => "Villain"}
    characters << {:id => 1009167, :name => "Bruce Banner", :type => "Civilian"}
    characters << {:id => 1009211, :name => "Bucky", :type => "Hero"}
    characters << {:id => 1009212, :name => "Bullseye", :type => "Villain"}

    characters << {:id => 1009214, :name => "Cable", :type => "Hero"}
    characters << {:id => 1009220, :name => "Captain America", :type => "Hero"}
    characters << {:id => 1010338, :name => "Captain Marvel (Carol Danvers)", :type => "Hero"}
    characters << {:id => 1009224, :name => "Captain Marvel (Mar-Vell)", :type => "Hero"}
    characters << {:id => 1009225, :name => "Captain Stacy", :type => "Civilian"}
    characters << {:id => 1011027, :name => "Captain Universe", :type => "Hero"}
    characters << {:id => 1009227, :name => "Carnage", :type => "Villain"}
    characters << {:id => 1009234, :name => "Chameleon", :type => "Villain"}
    characters << {:id => 1009733, :name => "Charles Xavier", :type => "Hero"}
    characters << {:id => 1009241, :name => "Cloak", :type => "Hero"}
    characters << {:id => 1009243, :name => "Colossus", :type => "Hero"}
    characters << {:id => 1011362, :name => "Cottonmouth", :type => "Villain"}
    characters << {:id => 1009252, :name => "Crossbones", :type => "Villain"}
    characters << {:id => 1009244, :name => "Curt Conners", :type => "Civilian"}
    characters << {:id => 1009257, :name => "Cyclops", :type => "Hero"}

    characters << {:id => 1010776, :name => "Danny Rand", :type => "Hero"}
    characters << {:id => 1009262, :name => "Daredevil", :type => "Hero"}
    characters << {:id => 1009265, :name => "Dark Phoenix", :type => "Villain"}
    characters << {:id => 1009268, :name => "Deadpool", :type => "Antihero"}
    characters << {:id => 1009269, :name => "Death", :type => "Villain"}
    characters << {:id => 1010890, :name => "Deathlok", :type => "Antihero"}
    characters << {:id => 1009275, :name => "Doc Samson", :type => "Villain"}
    characters << {:id => 1009281, :name => "Doctor Doom", :type => "Villain"}
    characters << {:id => 1009276, :name => "Doctor Octopus", :type => "Villain"}
    characters << {:id => 1009282, :name => "Doctor Strange", :type => "Hero"}
    characters << {:id => 1009280, :name => "Dormammu", :type => "Villain"}
    characters << {:id => 1010677, :name => "Dracula", :type => "Villain"}
    characters << {:id => 1010735, :name => "Drax", :type => "Hero"}
    characters << {:id => 1009284, :name => "Dum Dum Dugan", :type => "Civilian"}

    characters << {:id => 1009287, :name => "Electro", :type => "Villain"}
    characters << {:id => 1009288, :name => "Elektra", :type => "Antihero"}
    characters << {:id => 1009310, :name => "Emma Frost", :type => "Villain"}
    characters << {:id => 1010671, :name => "Enchantress (Amora)", :type => "Villain"}

    characters << {:id => 1009297, :name => "Falcon", :type => "Hero"}
    characters << {:id => 1009335, :name => "Felicia Hardy", :type => "Civilian"}

    characters << {:id => 1009377, :name => "Gabe Jones", :type => "Civilian"}
    characters << {:id => 1009312, :name => "Galactus", :type => "Villain"}
    characters << {:id => 1009313, :name => "Gambit", :type => "Antihero"}
    characters << {:id => 1010763, :name => "Gamora", :type => "Hero"}
    characters << {:id => 1010925, :name => "Ghost Rider (Daniel Ketch)", :type => "Antihero"}
    characters << {:id => 1009318, :name => "Ghost Rider (Johnny Blaze)", :type => "Antihero"}
    characters << {:id => 1009320, :name => "Giant Man", :type => "Hero"}
    characters << {:id => 1009321, :name => "Gladiator (Kallark)", :type => "Villain"}
    characters << {:id => 1011256, :name => "Gladiator (Melvin Potter)", :type => "Villain"}
    characters << {:id => 1009645, :name => "Glenn Talbot", :type => "Civilian"}
    characters << {:id => 1011144, :name => "Glorian", :type => "Villain"}
    characters << {:id => 1014985, :name => "Green Goblin (Barry Norman Osborn)", :type => "Villain"}
    characters << {:id => 1010928, :name => "Green Goblin (Harry Osborn)", :type => "Villain"}
    characters << {:id => 1009326, :name => "Gressill", :type => "Villain"}
    characters << {:id => 1009328, :name => "Grim Reaper", :type => "Villain"}
    characters << {:id => 1010743, :name => "Groot", :type => "Hero"}
    characters << {:id => 1009619, :name => "Gwen Stacy", :type => "Civilian"}

    characters << {:id => 1009334, :name => "Hammerhead", :type => "Villain"}
    characters << {:id => 1009348, :name => "Happy Hogan", :type => "Civilian"}
    characters << {:id => 1009486, :name => "Harry Osborn", :type => "Civilian"}
    characters << {:id => 1009337, :name => "Havok", :type => "Hero"}
    characters << {:id => 1011490, :name => "Hank Pym", :type => "Civilian"}
    characters << {:id => 1009338, :name => "Hawkeye", :type => "Hero"}
    characters << {:id => 1009343, :name => "Hercules", :type => "Hero"}
    characters << {:id => 1010930, :name => "Hobgoblin (Jason Macendale)", :type => "Villain"}
    characters << {:id => 1009347, :name => "Hobgoblin (Robin Borne)", :type => "Villain"}
    characters << {:id => 1010931, :name => "Hobgoblin (Roderick Kingsley)", :type => "Villain"}
    characters << {:id => 1010373, :name => "Howard The Duck", :type => "Civilian"}
    characters << {:id => 1009351, :name => "Hulk", :type => "Hero"}
    characters << {:id => 1009356, :name => "Human Torch", :type => "Hero"}

    characters << {:id => 1009362, :name => "Iceman", :type => "Hero"}
    characters << {:id => 1009366, :name => "Invisible Woman", :type => "Hero"}
    characters << {:id => 1010888, :name => "Iron Fist (Orson Randall)", :type => "Hero"}
    characters << {:id => 1009368, :name => "Iron Man", :type => "Hero"}
    characters << {:id => 1009371, :name => "Iron Monger", :type => "Villain"}
    characters << {:id => 1009487, :name => "Iron Patriot", :type => "Hero"}

    characters << {:id => 1009372, :name => "J. Jonah Jameson", :type => "Civilian"}
    characters << {:id => 1010766, :name => "Jack O' Lantern", :type => "Villain"}
    characters << {:id => 1011288, :name => "Jackal", :type => "Villain"}
    characters << {:id => 1010329, :name => "Jane Foster", :type => "Civilian"}
    characters << {:id => 1009496, :name => "Jean Grey", :type => "Hero"}
    characters << {:id => 1009378, :name => "Jessica Jones", :type => "Hero"}
    characters << {:id => 1009374, :name => "Jigsaw", :type => "Villain"}
    characters << {:id => 1009196, :name => "Johnny Blaze", :type => "Civilian"}
    characters << {:id => 1009630, :name => "Johnny Storm", :type => "Civilian"}
    characters << {:id => 1009382, :name => "Juggernaut", :type => "Villain"}
    characters << {:id => 1011310, :name => "Justin Hammer", :type => "Villain"}

    characters << {:id => 1009384, :name => "Kang", :type => "Villain"}
    characters << {:id => 1011357, :name => "Karen Page", :type => "Civilian"}
    characters << {:id => 1011289, :name => "Killmonger", :type => "Villain"}
    characters << {:id => 1009389, :name => "Kingpin", :type => "Villain"}
    characters << {:id => 1010842, :name => "King Cobra", :type => "Villain"}
    characters << {:id => 1009390, :name => "Klaw", :type => "Villain"}
    characters << {:id => 1011147, :name => "Korath", :type => "Villain"}
    characters << {:id => 1011080, :name => "Korg", :type => "Hero"}
    characters << {:id => 1011312, :name => "Korvac", :type => "Villain"}
    characters << {:id => 1009391, :name => "Kraven the Hunter", :type => "Villain"}

    characters << {:id => 1009398, :name => "Leader", :type => "Villain"}
    characters << {:id => 1011074, :name => "Lilith", :type => "Villain"}
    characters << {:id => 1009404, :name => "Lizard", :type => "Villain"}
    characters << {:id => 1010363, :name => "Logan", :type => "Antihero"}
    characters << {:id => 1009407, :name => "Loki", :type => "Villain"}
    characters << {:id => 1009215, :name => "Luke Cage", :type => "Hero"}

    characters << {:id => 1010726, :name => "M.O.D.O.K.", :type => "Villain"}
    characters << {:id => 1009412, :name => "Madame Hydra", :type => "Villain"}
    characters << {:id => 1010796, :name => "Madame Web (Julia Carpenter)", :type => "Hero"}
    characters << {:id => 1009413, :name => "Madrox", :type => "Villain"}
    characters << {:id => 1011328, :name => "Maestro", :type => "Villain"}
    characters << {:id => 1009417, :name => "Magneto", :type => "Villain"}
    characters << {:id => 1009420, :name => "Man-Thing", :type => "Villain"}
    characters << {:id => 1009421, :name => "Mandarin", :type => "Villain"}
    characters << {:id => 1011335, :name => "Maria Hill", :type => "Civilian"}
    characters << {:id => 1009708, :name => "Mary Jane Watson", :type => "Civilian"}
    characters << {:id => 1010732, :name => "Master Chief", :type => "Hero"}
    characters << {:id => 1009463, :name => "Matthew Murdock", :type => "Civilian"}
    characters << {:id => 1009490, :name => "May Parker", :type => "Civilian"}
    characters << {:id => 1009440, :name => "Mephisto", :type => "Villain"}
    characters << {:id => 1009447, :name => "Mister Sinister", :type => "Villain"}
    characters << {:id => 1011019, :name => "Molecule Man", :type => "Villain"}
    characters << {:id => 1009448, :name => "Mojo", :type => "Villain"}
    characters << {:id => 1009452, :name => "Moon Knight", :type => "Antihero"}
    characters << {:id => 1009454, :name => "Morbius", :type => "Villain"}
    characters << {:id => 1009459, :name => "Mr. Fantastic", :type => "Hero"}
    characters << {:id => 1009464, :name => "Mysterio", :type => "Villain"}
    characters << {:id => 1009465, :name => "Mystique", :type => "Villain"}

    characters << {:id => 1009466, :name => "Namor", :type => "Antihero"}
    characters << {:id => 1010365, :name => "Nebula", :type => "Villain"}
    characters << {:id => 1009471, :name => "Nick Fury", :type => "Civilian"}
    characters << {:id => 1009472, :name => "Nightcrawler", :type => "Hero"}
    characters << {:id => 1009325, :name => "Norman Osborn", :type => "Civilian"}
    characters << {:id => 1010063, :name => "Norrin Radd", :type => "Civilian"}
    characters << {:id => 1009477, :name => "Nova", :type => "Hero"}

    characters << {:id => 1009620, :name => "Obadiah Stane", :type => "Civilian"}
    characters << {:id => 1009480, :name => "Odin", :type => "Hero"}
    characters << {:id => 1009482, :name => "Omega Red", :type => "Villain"}
    characters << {:id => 1009483, :name => "Onslaught", :type => "Villain"}
    characters << {:id => 1009479, :name => "Otto Octavius", :type => "Civilian"}

    characters << {:id => 1009494, :name => "Pepper Potts", :type => "Civilian"}
    characters << {:id => 1009491, :name => "Peter Parker", :type => "Civilian"}
    characters << {:id => 1010734, :name => "Peter Quill", :type => "Civilian"}
    characters << {:id => 1009504, :name => "Professor X", :type => "Hero"}
    characters << {:id => 1009505, :name => "Proteus", :type => "Villain"}
    characters << {:id => 1010865, :name => "Puff Adder", :type => "Villain"}
    characters << {:id => 1009515, :name => "Punisher", :type => "Antihero"}
    characters << {:id => 1009522, :name => "Pyro", :type => "Villain"}

    characters << {:id => 1009524, :name => "Quicksilver", :type => "Hero"}

    characters << {:id => 1009532, :name => "Reaper", :type => "Villain"}
    characters << {:id => 1011360, :name => "Red Hulk", :type => "Antihero"}
    characters << {:id => 1011436, :name => "Red She-Hulk", :type => "Villain"}
    characters << {:id => 1009535, :name => "Red Skull", :type => "Villain"}
    characters << {:id => 1009537, :name => "Rhino", :type => "Villain"}
    characters << {:id => 1009702, :name => "Rhodey", :type => "Civilian"}
    characters << {:id => 1010744, :name => "Rocket Raccoon", :type => "Hero"}
    characters << {:id => 1009546, :name => "Rogue", :type => "Hero"}
    characters << {:id => 1010344, :name => "Ronan", :type => "Villain"}
    characters << {:id => 1009551, :name => "Russian", :type => "Villain"}

    characters << {:id => 1009554, :name => "Sabretooth", :type => "Villain"}
    characters << {:id => 1009558, :name => "Sandman", :type => "Villain"}
    characters << {:id => 1009561, :name => "Sauron", :type => "Villain"}
    characters << {:id => 1009562, :name => "Scarlet Witch", :type => "Hero"}
    characters << {:id => 1009568, :name => "Selene", :type => "Villain"}
    characters << {:id => 1009570, :name => "Sentinel", :type => "Villain"}
    characters << {:id => 1009574, :name => "Shadowcat", :type => "Hero"}
    characters << {:id => 1009228, :name => "Sharon Carter", :type => "Civilian"}
    characters << {:id => 1009583, :name => "She-Hulk (Jennifer Walters)", :type => "Hero"}
    characters << {:id => 1011392, :name => "She-Hulk (Lyra)", :type => "Hero"}
    characters << {:id => 1009585, :name => "Shocker (Herman Schultz)", :type => "Villain"}
    characters << {:id => 1009588, :name => "Sif", :type => "Hero"}
    characters << {:id => 1009591, :name => "Silver Samurai", :type => "Villain"}
    characters << {:id => 1009592, :name => "Silver Surfer", :type => "Hero"}
    characters << {:id => 1011223, :name => "Skaar", :type => "Antihero"}
    characters << {:id => 1009610, :name => "Spider-Man", :type => "Hero"}
    characters << {:id => 1010733, :name => "Star-Lord (Peter Quill)", :type => "Hero"}
    characters << {:id => 1010326, :name => "Steve Rogers", :type => "Civilian"}
    characters << {:id => 1009629, :name => "Storm", :type => "Hero"}

    characters << {:id => 1009644, :name => "T'Challa", :type => "Civilian"}
    characters << {:id => 1009648, :name => "Taskmaster", :type => "Villain"}
    characters << {:id => 1009651, :name => "Terrax", :type => "Villain"}
    characters << {:id => 1011003, :name => "Thaddeus Ross", :type => "Civilian"}
    characters << {:id => 1009652, :name => "Thanos", :type => "Villain"}
    characters << {:id => 1010728, :name => "The Executioner", :type => "Villain"}
    characters << {:id => 1009656, :name => "The Phantom", :type => "Hero"}
    characters << {:id => 1009662, :name => "Thing", :type => "Hero"}
    characters << {:id => 1009664, :name => "Thor", :type => "Hero"}
    characters << {:id => 1010885, :name => "Thunderball", :type => "Villain"}
    characters << {:id => 1014812, :name => "Thunderbolt Ross", :type => "Civilian"}
    characters << {:id => 1009624, :name => "Tony Stark", :type => "Civilian"}

    characters << {:id => 1009683, :name => "Uatu The Watcher", :type => "Hero"}
    characters << {:id => 1010358, :name => "Ulik", :type => "Villain"}
    characters << {:id => 1009685, :name => "Ultron", :type => "Villain"}

    characters << {:id => 1009663, :name => "Venom (Flash Thompson)", :type => "Hero"}
    characters << {:id => 1010788, :name => "Venom (Mac Gargan)", :type => "Villain"}
    characters << {:id => 1010324, :name => "Victor Von Doom", :type => "Civilian"}
    characters << {:id => 1009696, :name => "Viper", :type => "Villain"}
    characters << {:id => 1009697, :name => "Vision", :type => "Hero"}
    characters << {:id => 1009699, :name => "Vulture (Adrian Toomes)", :type => "Villain"}
    characters << {:id => 1010990, :name => "Vulture (Blackie Drago)", :type => "Villain"}

    characters << {:id => 1010991, :name => "War Machine (Parnell Jacobs)", :type => "Hero"}
    characters << {:id => 1009707, :name => "Wasp", :type => "Hero"}
    characters << {:id => 1009711, :name => "Whiplash (Mark Scarlotti)", :type => "Villain"}
    characters << {:id => 1010740, :name => "Winter Soldier", :type => "Antihero"}
    characters << {:id => 1010853, :name => "White Tiger (Angela Del Toro)", :type => "Villain"}
    characters << {:id => 1009718, :name => "Wolverine", :type => "Antihero"}
    characters << {:id => 1010737, :name => "Wraith", :type => "Villain"}
    characters << {:id => 1010884, :name => "Wrecker", :type => "Villain"}

    characters << {:id => 1010780, :name => "Zemo", :type => "Villain"}
    characters << {:id => 1009742, :name => "Zzzax", :type => "Villain"}

    characters
  end
end
