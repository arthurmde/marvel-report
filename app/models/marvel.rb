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
    characters = MarvelParameters.characters_list

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
          event.thumbnail = thumbnail.blank? ? "" : thumbnail['path'] + '.' + thumbnail['extension']
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
    response = self.get("/v1/public/characters?nameStartsWith=a&orderBy=name&limit=100&offset=0&#{MarvelParameters.credentials}")
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
    unless response_body.nil?
      character_data = response_body['data']
      unless character_data.nil?
        result = character_data['results'][0]
        urls = result['urls']

        character = current_character[:type].constantize.new

        thumbnail = result['thumbnail']
        character.thumbnail = thumbnail.blank? ? "" : thumbnail['path'] + '.' + thumbnail['extension']
        character.character_id = result['id']
        character.name = result['name']
        character.description = result['description']
        character.events_uri = result['events']['collectionURI']

        unless urls.nil?
          urls.each do |url|
            type = url["type"].to_s + '_url'
            character.send(type + '=', url["url"]) if character.respond_to? type
          end
        end

        character.save!
      end
    end
  end


end
