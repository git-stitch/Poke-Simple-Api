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
      puts test_type.name
      # binding.pry
  end
end

###Create Pokemon Region Models
def create_regions(region_list)
  region_list.each do |region|
    test_region = Region.create(name:region)
    puts test_region.name
    # binding.pry
  end
end

### Gets the list of all pokemon data URLs from poke/api
def pokemon_api_caller
  response = RestClient.get "https://pokeapi.co/api/v2/pokemon/?offset=24&limit=1"
  response_JSON = JSON.parse(response)
  response_JSON["results"]
end

### Gets the list of all pokemon abilities from Urls
def pokemon_api_ability_caller
  response = RestClient.get "https://pokeapi.co/api/v2/ability/?offset=0&limit=293"
  response_JSON = JSON.parse(response)
  response_JSON["results"]
end

### Calls a single pokemons url
def ability_url_caller(url)
  ability_data = JSON.parse(RestClient.get(url))
end

### Calls a single pokemons url
def pokemon_url_caller(url)
    poke_data = JSON.parse(RestClient.get(url))
end

### Pokemon General Stat Setter
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
    # binding.pry
end

### Create Pokemon_Region association
def pokemon_region_setter(pokemon)
  if pokemon.pokedex_number < 152
    region = Region.find_by(name:"kanto")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry
  
  elsif pokemon.pokedex_number < 252
    region = Region.find_by(name:"johto")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.pokedex_number < 387
    region = Region.find_by(name:"hoenn")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.pokedex_number < 494
    region = Region.find_by(name:"sinnoh")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.pokedex_number < 650 
    region = Region.find_by(name:"unova")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.pokedex_number < 722
    region = Region.find_by(name:"kalos")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.pokedex_number < 810
    region = Region.find_by(name:"alola")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.pokedex_number < 891
    region = Region.find_by(name:"galar")
    pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    # binding.pry
  end
  
  pokemon
end

### Set pokemon type associations
def pokemon_type_setter(pokemon, stat_data)
    binding.pry
    if stat_data["types"].length == 1
        type = stat_data["types"][0]["type"]["name"]
        type = Type.find_by(name:type)
        poke_type = PokemonType.new(pokemon_id:pokemon.id, type_id:type.id)
        binding.pry
    else
        stat_data["types"].each_with_index do |types, idx|
            if idx == 0
              type1 = Type.find_by(name:types["type"]["name"])
              poke_type = PokemonType.new(pokemon_id:pokemon.id, type_id:type1.id)
              binding.pry
            end
            if idx == 1
              type2 = Type.find_by(name:types["type"]["name"])
              poke_type = PokemonType.new(pokemon_id:pokemon.id, type_id:type2.id)
              binding.pry
            end
        end

    end
end

### Create Abilities
def create_abilities(ability_data)
  # puts ability_data["name"]
  if ability_data["id"] > 10000
    abil = Ability.create(name:ability_data["name"])
    puts abil
  else
    abil = Ability.create(name:ability_data["name"], description:ability_data["effect_entries"][0]["effect"])
    puts abil
  end
end

### Set Pokemon type associations
def pokemon_ability_setter(pokemon, stat_data)
  binding.pry
end


### Create Pokemon
def create_pokemon(pokemon_data)
    new_pokemon = Pokemon.new(name:pokemon_data["name"])
    ##sets pokemon stats
    pokemon_stat_setter(new_pokemon, pokemon_data)
    # new_pokemon.save()

    ##set pokemons debut region
    # pokemon_region_setter(new_pokemon)
    
    ##set pokemons type
    # pokemon_type_setter(new_pokemon, pokemon_data)

    ##set pokemons abilities
    pokemon_ability_setter(new_pokemon, pokemon_data)

    # binding.pry
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

  ### call ability creator
  # ability_results_arr = pokemon_api_ability_caller
  # ability_results_arr.each do |ability|
  #   abil = create_abilities(ability_url_caller(ability["url"]))
  # end

  pokemon_results_arr = pokemon_api_caller
    
  pokemon_results_arr.each do |pokemon|
      poke = create_pokemon(pokemon_url_caller(pokemon["url"]))
  end
end

pokemon_database_runner