class Api::V1::PokemonsController < ApplicationController
    def index
        @all_poke = Pokemon.all + AlternateForm.all
        @pokemon = @all_poke.sort_by{|pokemon| pokemon.pokedex_number
        }

        render json: {
            results: @pokemon
        }
    end

    def show
        @pokemon = find_pokemon

        if @pokemon
          render json: {
              results: @pokemon, 
              status: :accepted} 
        else
          render json: { errors: "Invalid Pokemon" }, status: :unprocessible_entity
        end
    end

    private

    def find_pokemon
        @pokemon = Pokemon.find(params[:id])
    end
end
