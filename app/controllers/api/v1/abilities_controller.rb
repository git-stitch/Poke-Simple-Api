class Api::V1::AbilitiesController < ApplicationController
    def index
        @abilities = Ability.all

        ### Do we offset or limit?
        if params[:limit] && params[:offset]
            @abilities = @abilities[params[:offset].to_i..(params[:offset].to_i + params[:limit].to_i - 1)]
        elsif params[:limit]
            @abilities = @abilities[0...params[:limit].to_i]
        elsif params[:offset]
            @abilities = @abilities[params[:offset].to_i..-1]
        end

        @abilities = no_more_created_or_updated_at(@abilities, true)
        @abilities = non_pokemon_data_shortener(@abilities, "http://127.0.0.1:3000/api/v1/abilities/",true)
        @count = @abilities.length

        render json: {
            count: @count,
            results: @abilities,
            status: :accepted
        }
    end

    def show
        if @ability
            @ability = find_ability
            @ability_pokemon = @ability.pokemon + @ability.alternate_forms
            @ability_pokemon.sort_by{|pokemon| pokemon.pokedex_number}
            @ability_pokemon.map! {|pokemon| 
                if Pokemon.find_by(name:pokemon.name)
                    pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
                else
                    pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
                end
            }
            
            @ability = no_more_created_or_updated_at(@ability, false)
            @count = @ability_pokemon.length

            render json: {
                results: @ability,
                pokemon: @ability_pokemon,
                status: :accepted
            }
        else 
            render json: { errors: "Invalid Ability." }
        end

    end

    private
    def find_ability
        if params[:id].to_i != 0
            @ability = Ability.find(params[:id])
        else 
            @ability = Ability.find_by(name:params[:id])
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

    def non_pokemon_data_shortener(data, url, is_arr)
        if is_arr
            data = data.map { |item| 
                # binding.pry
                item = {
                    id: item["id"],
                    name: item["name"],
                    url: url+"#{item["id"]}"
                }
            }
            return data
        else 
            copy = {
                id: data["id"],
                name: data["name"],
                url: url+"#{data["name"]}"
            }
            return copy
        end
    end
end
