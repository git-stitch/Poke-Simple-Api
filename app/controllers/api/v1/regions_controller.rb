class Api::V1::RegionsController < ApplicationController
    def index
			@regions = Rails.cache.fetch("regions", raw: true, expires_in: 1.minute) do 
				Region.all.map {|region| region = {name: region.name, url:"http://127.0.0.1:3000/api/v1/regions/#{region.name}"}}.to_json
			end
			render json: {
					results: JSON.parse(@regions)
			}
    end

		def show
			@region = find_region

				if @region
					# binding.pry
						@region_pokemon = Rails.cache.fetch("region_id_#{@region.id}_pokemon", raw: true, expires_in: 1.minute) do 
							@poke_list = @region.pokemon + @region.alternate_forms 

							@poke_list.sort_by{|pokemon| pokemon.pokedex_number}
							@poke_list.map! {|pokemon| 
									if Pokemon.find_by(name:pokemon.name)
											pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
									else
											pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
									end
								}.to_json
						end

            @region = no_more_created_or_updated_at(@region, false)
            @count = @region_pokemon.length

            render json:{
                count: @count,
                id: @region["id"],
                name: @region["name"],
                results: JSON.parse(@region_pokemon)
            }
        else 
            render json: {errors: "Invalid Region."}
        end
    end

    private

    def find_region
				if params[:id].to_i != 0
					binding.pry
            @region = Rails.cache.fetch("type_id_#{params[:id]}") do 
							Region.find(params[:id])
						end
        else 
            @region = Rails.cache.fetch("#{params[:id]}") do 
							Region.find_by(name:params[:id])
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
end
