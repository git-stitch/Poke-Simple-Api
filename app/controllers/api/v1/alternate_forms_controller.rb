class Api::V1::AlternateFormsController < ApplicationController
		def index
			@alternate_forms_list = Rails.cache.fetch("alternate_forms_#{params[:limit]}_#{:offset}}", raw: true, expires_in: 30.seconds) do 

				@alternate_forms = AlternateForm.all
	
				if params[:limit] == nil
					params[:limit] = 50
				end

				if params[:offset] == nil
					params[:offset] = 0
				end

				### Do we offset or limit?
				if params[:limit] && params[:offset]
						@alternate_forms = @alternate_forms[params[:offset].to_i..(params[:offset].to_i + params[:limit].to_i - 1)]
				elsif params[:limit]
						@alternate_forms = @alternate_forms[0...params[:limit].to_i]
				elsif params[:offset]
						@alternate_forms = @alternate_forms[params[:offset].to_i..-1]
				end
	
				@alternate_forms = @alternate_forms.map { |pokemon|
	
					front_default = pokemon.alternate_form_sprites[0][:front_default]
					gen_eight_front_default = pokemon.alternate_form_sprites[0][:gen_eight_front_default]
					pokemon = {
							id: pokemon.id,
							name: pokemon.name, 
							url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}",
							sprites: [
								front_default,
								gen_eight_front_default
							]
					}
				}
	
				@alternate_forms.to_json
			end

			@count = JSON.parse(@alternate_forms_list).length
			
			render json: {
				count: @count, 
				url: 'http://127.0.0.1:3000/api/v1/alternate_forms?offset=0&limit=50',
				results: JSON.parse(@alternate_forms_list)
			}
    end
    
		def show
			@alternate_form = find_alternate_forms

			if @alternate_form

				@alternate_form_data = Rails.cache.fetch("alternate_form_data",  raw: true, expires_in: 30.seconds) do

					poke_type_arr = @alternate_form.types
					poke_type_arr = no_more_created_or_updated_at(poke_type_arr, true)
					poke_type_arr = non_pokemon_data_shortener(poke_type_arr, "http://127.0.0.1:3000/api/v1/types/", true)
	
					### find sprites
					poke_sprites_arr = @alternate_form.alternate_form_sprites
					poke_sprites_arr = no_more_created_or_updated_at(poke_sprites_arr, true)
	
					### find alternate_forms
					poke_alternate_forms_arr = @alternate_form.pokemon
					poke_alternate_forms_arr = no_more_created_or_updated_at(poke_alternate_forms_arr, false)
					poke_alternate_forms_arr = pokemon_data_shortener(poke_alternate_forms_arr, false)
	
					### find debut region
					poke_region_arr = @alternate_form.regions
					poke_region_arr = no_more_created_or_updated_at(poke_region_arr, true)
					poke_region_arr = non_pokemon_data_shortener(poke_region_arr, "http://127.0.0.1:3000/api/v1/regions/", true)
	
					### find abilities
					poke_abilities_arr = @alternate_form.abilities
					poke_abilities_arr = no_more_created_or_updated_at(poke_abilities_arr, true)
					poke_abilities_arr = non_pokemon_data_shortener(poke_abilities_arr, "http://127.0.0.1:3000/api/v1/abilities/", true)
	
					original_form = {
						name: @alternate_form.pokemon.name,
						url: "http://127.0.0.1:3000/api/v1/pokemon/#{@alternate_form.pokemon.name}"
					}

					@alternate_form = no_more_created_or_updated_at(@alternate_form, false)
					
					@alternate_form_data = [
						{
							results: @alternate_form,
							types: poke_type_arr,
							sprites: poke_sprites_arr,
							debut_region: poke_region_arr,
							abilities: poke_abilities_arr,
							original_form: original_form
						}
					]

					@alternate_form_data.to_json
				end

				@alternate_form_data = JSON.parse(@alternate_form_data)

				render json: {
					results: @alternate_form_data[0]["results"], 
					types: @alternate_form_data[0]["types"],
					sprites: @alternate_form_data[0]["sprites"],
					debut_region: @alternate_form_data[0]["debut_region"],
					abilities: @alternate_form_data[0]["abilities"],
					original_form: @alternate_form_data[0]["original_form"],
					status: :accepted
				} 
			else
				render json: { errors: "Invalid Alternate Form." }
			end
    end

    private

    def find_alternate_forms
			if params[:id].to_i != 0
				@alternate_forms = AlternateForm.find(params[:id])
			else 
				@alternate_forms = AlternateForm.find_by(name:params[:id])
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

    def pokemon_data_shortener(data, is_arr)
			if is_arr 
				data = data.map { |pokemon|
					if Pokemon.find_by(name:pokemon["name"])
						pokemon = {
							id: pokemon["id"],
							name: pokemon["name"],
							url: "http://127.0.0.1:3000/api/v1/pokemons/#{pokemon["id"]}"
						}
					else
						pokemon = {
							id: pokemon["id"],
							name: pokemon["name"],
							url: "http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon["id"]}"
						}
					end
				}	
				return data
      else 
				if Pokemon.find(data["id"])
					pokemon = {
						id: data["id"],
						name: data["name"],
						url: "http://127.0.0.1:3000/api/v1/pokemons/#{data["id"]}"
					}
				else
					pokemon = {
						id: data["id"],
						name: data["name"],
						url: "http://127.0.0.1:3000/api/v1/alternate_forms/#{data["id"]}"
					}
				end

				return pokemon
			end
    end
end
