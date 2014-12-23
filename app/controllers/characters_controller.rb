class CharactersController < ApplicationController
  def index
    @characters = Character.find_all
  end

  def show
    @character = Character.where(character_id: params[:id]).first
  end
end
