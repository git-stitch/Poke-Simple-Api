require 'pry'
require 'json'
require 'rest_client'

#Opens API call to pokeapi and returns all Pokemon From 1 - 807
#Parses that value using Rest-client
#Pokemon name followed by url of pokemon data

###Create Pokemon Type Models
def create_types(type_list)
  type_list.each do |type|
      test_type = Type.create(name:type)
      # binding.pry
  end
end

###Create Pokemon Region Models
def create_regions(region_list)
  region_list.each do |region|
    test_region = Region.create(name:region)
    # binding.pry
  end
end

###Gets the list of all pokemon data URLs from poke/api
def pokemon_api_caller
  response = RestClient.get "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=2"
  response_JSON = JSON.parse(response)
  response_JSON["results"]
end

#Calls a single pokemons url
def pokemon_url_caller(url)
    poke_data = JSON.parse(RestClient.get(url))
end

def pokemon_stat_setter(pokemon,stat_data)
    stat_data["stats"].each do |stats|
        hp,speed,attack,defense = 0

        if stats["stat"]["name"] == "hp"
            pokemon.hp = stats["base_stat"]

        elsif stats["stat"]["name"] == "attack"
            pokemon.attack = stats["base_stat"]

        elsif stats["stat"]["name"] == "special-attack"
            pokemon.special_attack = stats["base_stat"]

        elsif stats["stat"]["name"] == "defense"
            pokemon.defense = stats["base_stat"]

        elsif stats["stat"]["name"] == "special-defense"
            pokemon.special_defense = stats["base_stat"]

        else stats["stat"]["name"] == "speed"
            pokemon.speed = stats["base_stat"]
        end
    end

    #sets pokemon height, weight and pokedex number
    pokemon.height = stat_data["height"]
    pokemon.weight = stat_data["weight"]
    pokemon.pokedex_number = stat_data["id"]

    #return pokemon model
    pokemon
    binding.pry
end

#Set pokemon type associations
def pokemon_type_setter(pokemon, stat_data)
    if stat_data["types"].length == 1
        pokemon.element = stat_data["types"][0]["type"]["name"]
    else
        stat_data["types"].each_with_index do |types, idx|
            if idx == 0
                pokemon.element = types["type"]["name"]
            end
            if idx == 1
                pokemon.element += "/" + types["type"]["name"]
            end
        end

    end
end

def create_pokemon(pokemon_data)
    new_pokemon = Pokemon.new(name:pokemon_data["name"])
    #sets pokemon stats
    pokemon_stat_setter(new_pokemon, pokemon_data)
    #totals stats for total power of pokemon
    # new_pokemon.total = new_pokemon.hp + new_pokemon.attack + new_pokemon.defense + new_pokemon.speed
    # ##sets pokemon type
    # pokemon_type_setter(new_pokemon, pokemon_data)
    # # Save Pokemon to database
    # new_pokemon.save()
end

def pokemon_database_runner
  ### call type creator
  type_list = ["grass","water","fire","normal","electric","ice","fighting","poison","ground","flying","psychic","bug","rock","ghost","dragon","dark","steel","fairy"]
  # create_types(type_list)

  ### call region creator
  region_list = ["kanto","johto","hoenn","sinnoh","unova","kalos","alola","galar"]
  # create_regions(region_list)

  # pokemon_results_arr = pokemon_api_caller
    
    # pokemon_results_arr.each do |pokemon|
        # poke = create_pokemon(pokemon_url_caller(pokemon["url"]))
    # end
end

pokemon_database_runner