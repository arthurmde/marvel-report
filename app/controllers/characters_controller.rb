class CharactersController < ApplicationController
  def index
  end

  def show
    @character = Character.find(params[:id])
  end
end
