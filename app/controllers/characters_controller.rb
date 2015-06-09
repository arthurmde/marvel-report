class CharactersController < ApplicationController
  def index
  end

  def show
    @character = Character.find_by_character_id(params[:id])
  end
end
