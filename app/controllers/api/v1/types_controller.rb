class Api::V1::TypesController < ApplicationController
	def index
    @types = Rails.cache.fetch("types", raw: true, expires_in: 1.minute) do 
			Type.all.map { |type| 
				type = {
					id: type.id, name: type.name, url:"http://127.0.0.1:3000/api/v1/types/#{type.name}"
				}
			}.to_json
			end

    return render json: {
      			results: JSON.parse(@types)
    }
  end

  def show

		@type = find_type
		@count = 0

		if @type
			@type_pokemon = Rails.cache.fetch("type_id_#{@type.id}_pokemon", raw: true, expires_in: 1.minute) do 
				@poke_list = @type.pokemon + @type.alternate_forms
				@count = @poke_list.length

				@poke_list.sort_by{|pokemon| pokemon.pokedex_number}
				@poke_list.map! {|pokemon|
					if Pokemon.find_by(name:pokemon.name)
						pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
					else
						pokemon = {id: pokemon.id, name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
					end
				}.to_json
			end
			

			render json:{
				count: @count,
				id: @type.id,
				name: @type.name,
				results: JSON.parse(@type_pokemon)
			}
		else
			render json: {errors: "Invalid type."}
		end
  end

  private

  def find_type
		if params[:id].to_i != 0
			@type = Rails.cache.fetch("type_id_#{params[:id]}") do 
				Type.find(params[:id])
			end
		else
			@type = Rails.cache.fetch("#{params[:id]}") do 
				Type.find_by(name:params[:id])
			end
		end
	end

end
