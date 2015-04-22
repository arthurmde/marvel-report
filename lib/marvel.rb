module Marvel
  include HTTParty

  base_uri 'gateway.marvel.com:80'

  def self.import_all_characters(characters = MarvelParameters.characters_list)
    characters.each do |current_character|
      Marvel.import_character(current_character)
    end
  end

  def self.import_character(current_character)
    response = self.get("/v1/public/characters/#{current_character[:id].to_s}?&#{MarvelParameters.credentials}")
    response_body = JSON.parse(response.body)

    if request_ok?(response_body)
      Marvel.create_character(current_character, response_body)
    else
      Marvel.raise_erros(response_body)
    end
  end

  def self.import_all_comics(limit = 100)
    Character.all.each do |character|
      Marvel.import_character_comics(character, limit)
    end
  end

  def self.import_character_comics(character, limit = 100)
    begin
      offset = 0
      imported_comics = 0

      begin
        begin
          response = self.get("/v1/public/characters/#{character.character_id.to_s}/comics?limit=#{limit}&offset=#{offset}&#{MarvelParameters.credentials}", :read_timeout => 5000, :use_ssl => true)
          response_body = JSON.parse(response.body)

          Marvel.raise_erros(response_body) unless request_ok?(response_body)

          imported_comics = response_body["data"].nil? ? 0 : response_body["data"]["count"]
          offset = offset + imported_comics

          Marvel.create_comic(character, response_body, imported_comics)
        rescue
          imported_comics = 100
        end
      end while imported_comics >= limit

      puts "="*100, "#{offset} comics imported for #{character.name}", "="*100
    rescue
      puts "="*100, "Problems to import #{character.name}'s comics", "="*100
    end
  end

  private

  def self.create_character(current_character, response_body)
    unless response_body.nil?
      character_data = response_body['data']

      unless character_data.nil?
        result = character_data['results'][0]
        urls = result['urls']

        return unless Character.where(:character_id => result['id']).empty?

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

  def self.create_comic(character, response_body, imported_comics = 0)
    comic_data = response_body['data']

    unless comic_data.nil?
      results = comic_data['results']

      results.each do |result|
        begin
          comic = Comic.where(:comic_id => result['id']).first

          if comic
            comic.characters << character
            next
          end

          comic = Comic.new

          urls = result['urls']
          thumbnail = result['thumbnail']
          comic.thumbnail = thumbnail.blank? ? "" : thumbnail['path'] + '.' + thumbnail['extension']
          comic.comic_id = result['id']
          comic.title = result['title']
          comic.issue = result['issueNumber']
          comic.description = result['description']
          comic.isbn = result['isbn']
          comic.pages = result['pageCount']

          unless urls.nil?
            urls.each do |url|
              type = url["type"].to_s + '_url'
              comic.send(type + '=', url["url"]) if comic.respond_to? type
            end
          end

          comic.characters << character

          comic.save!
        rescue
          next
        end
      end
    end
  end

  def self.request_ok?(response_body)
    !response_body.nil? && response_body["code"] == 200 && response_body["status"] == "Ok"
  end

  def self.raise_erros(response_body)
    puts "Error importing Marvel's data"
    puts "Code: #{response_body['code']}"
    puts "Status: #{response_body['status']}"
    puts "Message: #{response_body['message']}"
    raise RuntimeError
  end

end
