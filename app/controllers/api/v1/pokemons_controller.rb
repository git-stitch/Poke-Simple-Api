class Api::V1::PokemonsController < ApplicationController
    def index
        @all_poke = Pokemon.all + AlternateForm.all
        @pokemon = @all_poke.sort_by{|pokemon| pokemon.pokedex_number
        }
        @pokemon.map! {|pokemon| 
            if Pokemon.find_by(name:pokemon.name)
                pokemon = {name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/pokemons/#{pokemon.name}"}
            else
                pokemon = {name: pokemon.name, url:"http://127.0.0.1:3000/api/v1/alternate_forms/#{pokemon.name}"}
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
end

##Pokemon with "-" 
##zamazenta-crowned-sword zacian-crowned-sword 
##galarian mr-mime 
##urshifu line = urshifu-single-strike-style -rapid-strike-style and gigantamax urshifu line 
##mr-mime
##mime-jr
##meloetta-aria
##meowstic-male
##lycanroc-midday
##minior-red-meteor
##basculin-red-striped
##type-null
##aegislash-shield
##wishiwashi-solo
##nidoran-f 
##nidoran-m
##porigon-z
##darmanitan-standard
##ho-oh
##keldeo-ordinary
##pumpkaboo-average
##oricorio-baile
##jangmo-o
##hakamo-o
##kommo-o
##landorus-incarnate
##tornadus-incarnate
##thundurus-incarnate
##deoxys-normal
##gourgeist-average
##mimikyu-disguised
##tapu-koko
##tapu-lele
##tapu-bulu
##tapu-fini