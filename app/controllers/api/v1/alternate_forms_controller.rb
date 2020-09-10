class Api::V1::AlternateFormsController < ApplicationController
    def index
			@alternate_forms = AlternateForm.all

			### Do we offset or limit?
			if params[:limit] && params[:offset]
					@alternate_forms = @alternate_forms[params[:offset].to_i..(params[:offset].to_i + params[:limit].to_i - 1)]
			elsif params[:limit]
					@alternate_forms = @alternate_forms[0...params[:limit].to_i]
			elsif params[:offset]
					@alternate_forms = @alternate_forms[params[:offset].to_i..-1]
			end

			@alternate_forms = @alternate_forms.map { |pokemon|
				poke_type_arr = pokemon.types
				poke_type_arr = no_more_created_or_updated_at(poke_type_arr, true)

				poke_sprites_arr = pokemon.alternate_form_sprites
				poke_sprites_arr = no_more_created_or_updated_at(poke_sprites_arr, true)
				pokemon = {
						id: pokemon.id,
						name: pokemon.name, 
						url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}",
						types: poke_type_arr,
						sprites: poke_sprites_arr
				}
			}

			@count = @alternate_forms.length

			render json: {
				count: @count, 
				results: @alternate_forms
			}
    end
    
    def show
			if @alternate_forms
				@alternate_forms = find_alternate_forms

				poke_type_arr = @alternate_forms.types
				poke_type_arr = no_more_created_or_updated_at(poke_type_arr, true)
				poke_type_arr = non_pokemon_data_shortener(poke_type_arr, "http://127.0.0.1:3000/api/v1/types/", true)

				### find sprites
				poke_sprites_arr = @alternate_forms.alternate_form_sprites
				poke_sprites_arr = no_more_created_or_updated_at(poke_sprites_arr, true)

				### find alternate_forms
				poke_alternate_forms_arr = @alternate_forms.pokemon
				poke_alternate_forms_arr = no_more_created_or_updated_at(poke_alternate_forms_arr, false)
				poke_alternate_forms_arr = pokemon_data_shortener(poke_alternate_forms_arr, false)

				### find debut region
				poke_region_arr = @alternate_forms.regions
				poke_region_arr = no_more_created_or_updated_at(poke_region_arr, true)
				poke_region_arr = non_pokemon_data_shortener(poke_region_arr, "http://127.0.0.1:3000/api/v1/regions/", true)

				### find abilities
				poke_abilities_arr = @alternate_forms.abilities
				poke_abilities_arr = no_more_created_or_updated_at(poke_abilities_arr, true)
				poke_abilities_arr = non_pokemon_data_shortener(poke_abilities_arr, "http://127.0.0.1:3000/api/v1/abilities/", true)

				@alternate_forms = no_more_created_or_updated_at(@alternate_forms, false)
				render json: {
					results: @alternate_forms, 
					types: poke_type_arr,
					sprites: poke_sprites_arr,
					debut_region: poke_region_arr,
					abilities: poke_abilities_arr,
					original_form: poke_alternate_forms_arr,
					status: :accepted} 
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
