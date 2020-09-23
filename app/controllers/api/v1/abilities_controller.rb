class Api::V1::AbilitiesController < ApplicationController
    def index
        @count = 0

        @abilities = Rails.cache.fetch("abilities_#{params[:limit]}_#{:offset}}", raw: true, expires_in: 30.seconds) do 

            if params[:limit] == nil
                params[:limit] == 50
            end

            if params[:offset] == nil
                params[:offset] == 0
            end
            
            @abil_list = Ability.all
            ### Do we offset or limit?
            if params[:limit] && params[:offset]
                @abil_list = @abil_list[params[:offset].to_i..(params[:offset].to_i + params[:limit].to_i - 1)]
            elsif params[:limit]
                @abil_list = @abil_list[0...params[:limit].to_i]
            elsif params[:offset]
                @abil_list = @abil_list[params[:offset].to_i..-1]
            end
            
            @abil_list = no_more_created_or_updated_at(@abil_list, true)
            @abil_list = non_pokemon_data_shortener(@abil_list, "http://127.0.0.1:3000/api/v1/abilities/",true)
            @count = @abil_list.length

            @abil_list = [{
                count: @count,
                results: @abil_list
            }]

            @abil_list.to_json
        end
        
        @abilities = JSON.parse(@abilities)

        render json: {
            count: @abilities[0]["count"],
            results: @abilities[0]["results"],
            status: :accepted
        }
    end

    def show
        @ability = find_ability

        if @ability
            @ability_pokemon = Rails.cache.fetch("ability_id_#{@ability.id}_pokemon", raw: true, expires_in: 30.seconds) do 
                @abil_list = @ability.pokemon + @ability.alternate_forms
                @abil_list.sort_by{|pokemon| pokemon.pokedex_number}
                @abil_list.map! {|pokemon| 
                    if Pokemon.find_by(name:pokemon.name)
                        pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
                    else
                        pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
                    end
                }
                
                @abil_list.to_json
            end
            @ability = no_more_created_or_updated_at(@ability, false)
            
            render json: {
                results: @ability,
                pokemon: JSON.parse(@ability_pokemon),
                status: :accepted
            }
        else 
            render json: { errors: "Invalid Ability." }
        end

    end

    private
    def find_ability
		if params[:id].to_i != 0
			@ability = Rails.cache.fetch("ability_id_#{params[:id]}") do 
				Ability.find(params[:id])
			end
		else
			@ability = Rails.cache.fetch("#{params[:id]}") do 
				Ability.find_by(name:params[:id])
			end
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
