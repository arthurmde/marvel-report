MarvelReport::Application.routes.draw do
  resources :comics

  resources :characters, only: [:index, :show]
  resources :comics, only: [:index, :show]
end
