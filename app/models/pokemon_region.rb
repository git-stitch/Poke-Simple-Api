class PokemonRegion < ApplicationRecord
  belongs_to :region
  belongs_to :pokemon_
end
