Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :pokemons, only: [:index,:show]
      resources :alternate_forms, only: [:index,:show]
      resources :regions, only: [:index,:show]
      resources :types, only: [:index,:show]
      resources :abilities, only: [:index,:show]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
