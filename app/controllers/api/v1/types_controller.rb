class Api::V1::TypesController < ApplicationController
    def index
        @types = Type.all

        render json: {
            results: @types
        }
    end

    def show
        @type = find_type
        @type_pokemon = @type.pokemon + @type.alternate_forms
        @type_pokemon.sort_by{|pokemon| pokemon.pokedex_number}
        @type_pokemon.map! {|pokemon| 
            if Pokemon.find_by(name:pokemon.name)
                pokemon = {name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
            else
                pokemon = {name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
            end
        }

        @count = @type_pokemon.length

        # binding.pry
        render json:{
            count: @count,
            name: @type.name,
            results: @type_pokemon
        }
    end

    private

    def find_type
        if params[:id].to_i != 0
            @type = Type.find(params[:id])
        else 
            @type = Type.find_by(name:params[:id])
        end
    end
end
