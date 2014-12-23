module MarvelApiHelper
  def marvel_public_key
    ENV['MARVEL_PUBLIC_KEY']
  end
end