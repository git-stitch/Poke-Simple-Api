class Api::V1::RegionsController < ApplicationController
    def index
        @regions = Region.all
        @regions = @regions.map {|region| region = {name: region.name, url:"http://127.0.0.1:3000/api/v1/regions/#{region.name}"}}

        render json: {
            results: @regions
        }
    end

    def show
        @region = find_region
        @region_pokemon = @region.pokemon + @region.alternate_forms
        @region_pokemon.sort_by{|pokemon| pokemon.pokedex_number}
        @region_pokemon.map! {|pokemon| 
            if Pokemon.find_by(name:pokemon.name)
                pokemon = {name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
            else
                pokemon = {name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
            end
        }

        @count = @region_pokemon.length

        # binding.pry
        render json:{
            count: @count,
            name: @region.name,
            results: @region_pokemon
        }
    end

    private

    def find_region
        if params[:id].to_i != 0
            @region = Region.find(params[:id])
        else 
            @region = Region.find_by(name:params[:id])
        end
    end
end
