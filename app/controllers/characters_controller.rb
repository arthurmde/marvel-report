class CharactersController < ApplicationController
  def index
  end

  def show
    @character = Character.where(character_id: params[:id]).first
  end
end
