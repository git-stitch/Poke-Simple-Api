class Api::V1::PokemonsController < ApplicationController
    def index
        @all_poke = AlternateForm.all + Pokemon.all
        @pokemon = @all_poke.sort_by{|pokemon| pokemon.pokedex_number
        }
        @pokemon.map! {|pokemon| 
            if Pokemon.find_by(name:pokemon.name)
                poke_type_arr = pokemon.types
                poke_type_arr = no_more_created_or_updated_at(poke_type_arr, true)

                poke_sprites_arr = pokemon.sprites
                poke_sprites_arr = no_more_created_or_updated_at(poke_sprites_arr, true)
                pokemon = {
                    name: pokemon.name, 
                    url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}",
                    type: poke_type_arr,
                    sprites: poke_sprites_arr 
                }
            else
                poke_type_arr = pokemon.alternate_form_types
                poke_type_arr = no_more_created_or_updated_at(poke_type_arr, true)

                poke_sprites_arr = pokemon.alternate_form_sprites
                poke_sprites_arr = no_more_created_or_updated_at(poke_sprites_arr, true)
                pokemon = {
                    name: pokemon.name, 
                    url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}",
                    types: poke_type_arr,
                    sprites: poke_sprites_arr
                }
            end
        }
        @count = @pokemon.length

        render json: {
            count: @count,
            results: @pokemon
        }
    end

    def show
        @pokemon = find_pokemon

        if @pokemon
          @pokemon = no_more_created_or_updated_at(@pokemon, false)
          render json: {
              results: @pokemon,
              status: :accepted} 
        else
          render json: { errors: "Invalid Pokemon" }
        end
    end

    private

    def find_pokemon
        # binding.pry
        if params[:id].to_i != 0
            @pokemon = Pokemon.find(params[:id])
        else 
            @pokemon = Pokemon.find_by(name:params[:id])
        end
    end

    def no_more_created_or_updated_at(data, is_arr)
        if is_arr
            data = data.map { |item| 
                item = item.attributes
                item = item.except("created_at","updated_at")
            }
            return data
        else 
            copy = data.attributes
            copy = copy.except("created_at", "updated_at")

            return copy
        end
    end
end