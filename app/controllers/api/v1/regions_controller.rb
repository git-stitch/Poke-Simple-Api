class Api::V1::RegionsController < ApplicationController
    def index
        @regions = Region.all
        @regions = @regions.map {|region| region = {name: region.name, url:"http://127.0.0.1:3000/api/v1/regions/#{region.name}"}}

        render json: {
            results: @regions
        }
    end

    def show
        if @region
            @region = find_region
            @region_pokemon = @region.pokemon + @region.alternate_forms
            @region_pokemon.sort_by{|pokemon| pokemon.pokedex_number}
            @region_pokemon.map! {|pokemon| 
                if Pokemon.find_by(name:pokemon.name)
                    pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
                else
                    pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
                end
            }

            @region = no_more_created_or_updated_at(@region, false)
            @count = @region_pokemon.length

            render json:{
                count: @count,
                id: @region["id"],
                name: @region["name"],
                results: @region_pokemon
            }
        else 
            render json: {errors: "Invalid Region."}
        end
    end

    private

    def find_region
        if params[:id].to_i != 0
            @region = Region.find(params[:id])
        else 
            @region = Region.find_by(name:params[:id])
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
