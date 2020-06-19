require 'pry'
require 'json'
require 'rest_client'
require 'nokogiri'
require 'open-uri'

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
def pokemon_api_caller(url)
  # response = RestClient.get "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=807"
  response = RestClient.get url
  response_JSON = JSON.parse(response)
  response_JSON["results"]
end

### Calls a single pokemons url
# def ability_url_caller(url)
#   ability_data = JSON.parse(RestClient.get(url))
# end

### Calls a single pokemons url
def url_caller(url)
    poke_data = JSON.parse(RestClient.get(url))
end

### Pokemon General Stat Setter
def pokemon_stat_setter(pokemon,stat_data,is_alternate)
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
    if !is_alternate
      pokemon.pokedex_number = stat_data["id"]
    end
    #return pokemon model
    pokemon
    # binding.pry
end

### Create Pokemon_Region association
def pokemon_region_setter(pokemon, is_alternate)
  if pokemon.pokedex_number < 152
    region = Region.find_by(name:"kanto")
    if is_alternate
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  
  elsif pokemon.pokedex_number < 252
    region = Region.find_by(name:"johto")
    if is_alternate
      # binding.pry
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  elsif pokemon.pokedex_number < 387
    region = Region.find_by(name:"hoenn")
    if is_alternate
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
      # binding.pry
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  elsif pokemon.pokedex_number < 494
    region = Region.find_by(name:"sinnoh")
    if is_alternate
      # binding.pry
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  elsif pokemon.pokedex_number < 650 
    region = Region.find_by(name:"unova")
    if is_alternate
      # binding.pry
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  elsif pokemon.pokedex_number < 722
    region = Region.find_by(name:"kalos")
    if is_alternate
      # binding.pry
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  elsif pokemon.pokedex_number < 810
    region = Region.find_by(name:"alola")
    if is_alternate
      # binding.pry
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  elsif pokemon.pokedex_number < 891
    region = Region.find_by(name:"galar")
    if is_alternate
      # binding.pry  
      ar = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    else 
      pr = PokemonRegion.create(pokemon_id:pokemon.id, region_id:region.id)
    end
      # binding.pry
  end
  
  pokemon
end

### Create Alternate_Region Association
def alternate_region_setter(pokemon)
  # binding.pry
  if pokemon.name.include? "kanto"
    region = Region.find_by(name:"kanto")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry
  
  elsif pokemon.name.include? "johto"
    region = Region.find_by(name:"johto")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.name.include? "hoenn"
    region = Region.find_by(name:"hoenn")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.name.include? "sinnoh"
    region = Region.find_by(name:"sinnoh")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.name.include? "unova" 
    region = Region.find_by(name:"unova")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.name.include? "kalos"
    region = Region.find_by(name:"kalos")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.name.include? "alolan"
    region = Region.find_by(name:"alola")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry

  elsif pokemon.name.include? "galarian"
    region = Region.find_by(name:"galar")
    pr = AlternateRegion.create(alternate_form_id:pokemon.id, region_id:region.id)
    # binding.pry
  end
  
  pokemon
end

### Set pokemon type associations
def pokemon_type_setter(pokemon, stat_data, is_alternate)
    # binding.pry
    if stat_data["types"].length == 1
        type = stat_data["types"][0]["type"]["name"]
        type = Type.find_by(name:type)
        if is_alternate
          poke_type = AlternateFormType.create(alternate_form_id:pokemon.id, type_id:type.id)
        else
          poke_type = PokemonType.create(pokemon_id:pokemon.id, type_id:type.id)
          # binding.pry
        end
    else
        stat_data["types"].each_with_index do |types, idx|
            if idx == 0
              type1 = Type.find_by(name:types["type"]["name"])
              if is_alternate
                alternate_poke_type = AlternateFormType.create(alternate_form_id:pokemon.id, type_id:type1.id)
                # binding.pry
              else
                poke_type = PokemonType.create(pokemon_id:pokemon.id, type_id:type1.id)
                # binding.pry
              end
            end
            if idx == 1
              type2 = Type.find_by(name:types["type"]["name"])
              if is_alternate
                alternate_poke_type = AlternateFormType.create(alternate_form_id:pokemon.id, type_id:type2.id)
              else 
                poke_type = PokemonType.create(pokemon_id:pokemon.id, type_id:type2.id)
                # binding.pry
              end
            end
        end

    end
end

### Create Abilities
def create_abilities(ability_data)
  # puts ability_data["name"]
  if ability_data["id"] > 10000
    abil = Ability.create(name:ability_data["name"])
    puts abil.name
  else
    abil = Ability.new(name:ability_data["name"])
    ability_data["effect_entries"].each do |a|
      if a["language"]["name"] == "en"
        abil["description"] = a["effect"]
        abil["short_description"] = a["short_effect"]
        abil.save()
        # binding.pry
      end
    end
    puts abil.name
  end
end

### Set Pokemon type associations
def pokemon_ability_setter(pokemon, stat_data, is_alternate)
  stat_data["abilities"].each do |item| 
    ability = Ability.find_by(name:item["ability"]["name"])
    if is_alternate
      pa = AlternateFormAbility.create(alternate_form_id:pokemon.id, ability_id:ability.id, is_hidden:item["is_hidden"])
    else
      pa = PokemonAbility.create(pokemon_id:pokemon.id, ability_id:ability.id, is_hidden:item["is_hidden"])
      # binding.pry
    end
  end
  # binding.pry
end

### Set Pokemon sprite association
def pokemon_sprite_setter(pokemon, stat_data, is_alternate)
  if is_alternate
    ps = AlternateFormSprite.create(
      alternate_form_id:pokemon.id,
      back_default:stat_data["sprites"]["back_default"],
      back_female:stat_data["sprites"]["back_female"],
      back_shiny:stat_data["sprites"]["back_shiny"],
      back_shiny_female:stat_data["sprites"]["back_shiny_female"],
      front_default:stat_data["sprites"]["front_default"],
      front_female:stat_data["sprites"]["front_female"],
      front_shiny:stat_data["sprites"]["front_shiny"],
      front_shiny_female:stat_data["sprites"]["front_shiny_female"]
    )
  else
    ps = Sprite.create(
      pokemon_id:pokemon.id,
      back_default:stat_data["sprites"]["back_default"],
      back_female:stat_data["sprites"]["back_female"],
      back_shiny:stat_data["sprites"]["back_shiny"],
      back_shiny_female:stat_data["sprites"]["back_shiny_female"],
      front_default:stat_data["sprites"]["front_default"],
      front_female:stat_data["sprites"]["front_female"],
      front_shiny:stat_data["sprites"]["front_shiny"],
      front_shiny_female:stat_data["sprites"]["front_shiny_female"]
    )
  end
  # binding.pry
end

### Fixes Names From Poke API in regards to Alternate Form Pokemon
def alternate_form_name_fixer_upper(name)
  if !name.include? "pikachu"
    if name.include? "alola"
        name = name.split("-")
        name.pop
        if name.length >= 3
          formatted_name = "alolan " + name.join(" ")
        else
          formatted_name = "alolan " + name.join("")
        end
      # binding.pry
    elsif name.include? "galar"
      name = name.split("-")
      name.pop
      if name.length >= 3
        formatted_name = "galarian " + name.join(" ")
      else
        formatted_name = "galarian " + name.join("")
      end
      # binding.pry
    elsif name.include? "totem"
      if name.include? "mimikyu"
        formatted_name = "totem mimikyu " + name.split("-").pop
      else
        name = name.split("-")
        name.pop
        formatted_name = "totem " + name.join(" ")
        # binding.pry
      end
    elsif name.include? "mega"
      if name.split("-").length >= 3
        ending = name.split("-").pop
        name = name.split("-")
        name.pop
        formatted_name = name.reverse.join(" ") + " " + ending 
      else
        formatted_name = name.split("-").reverse.join(" ")
      end
      # binding.pry
    elsif name.include? "gigantimax"
      formatted_name = name.split("-").reverse.join(" ")
      binding.pry
    else 
      formatted_name = name.split("-").join(" ")
      # binding.pry
    end      
  else 
    formatted_name = name.split("-").join(" ")
    # binding.pry
  end

  formatted_name
end

### Create Pokemon
def create_pokemon(pokemon_data, is_alternate)

  if is_alternate 
    ## finds the original pokemons name from the alternate form name
    og_poke_name = pokemon_data["name"].split("-").first
    ## rejoins the name with spaces cause yolo
    name = alternate_form_name_fixer_upper(pokemon_data["name"])
    # binding.pry
    ## finds the orignal pokemon to create associations in AlternateForms
    original_pokemon = Pokemon.find_by(name:og_poke_name)
    if original_pokemon == nil 
      original_pokemon = Pokemon.all.find {|pokemon| pokemon.name.include? og_poke_name}
      original_pokemon.name = original_pokemon.name.split("-").first
      # binding.pry
    end
    # binding.pry
    new_pokemon = AlternateForm.new(name:name, pokemon_id:original_pokemon.id, pokedex_number:original_pokemon.pokedex_number)
    # binding.pry

    ## checks if a pokemon is mega or gigantimax 
    if name.include? "mega"
      new_pokemon.is_mega = true
    elsif name.include? "gigantimax"
      # new_pokemon.is_gigantimax = true
    end

    ## sets alternate pokemons stats
    pokemon_stat_setter(new_pokemon, pokemon_data, is_alternate)
    new_pokemon.save()
    ## sets alternate pokemon region association
    if new_pokemon.name.include? "galarian"
      alternate_region_setter(new_pokemon)
      # binding.pry
    elsif new_pokemon.name.include? "alolan"
      alternate_region_setter(new_pokemon)
      # binding.pry
    else 
      pokemon_region_setter(new_pokemon, true)
      # binding.pry
    end

    ##set pokemons type
    pokemon_type_setter(new_pokemon, pokemon_data, true)

    ##set pokemons abilities
    pokemon_ability_setter(new_pokemon, pokemon_data, true)

    ###set pokemons sprites
    pokemon_sprite_setter(new_pokemon,pokemon_data, true) 

    puts new_pokemon.name

    # binding.pry
  ### start looking at original poke
  else 
    new_pokemon = Pokemon.new(name:pokemon_data["name"])

    if new_pokemon.name.include? "wormadam"
      new_pokemon.name = "wormadam"
    end

    if new_pokemon.name.include? "shaymin"
      new_pokemon.name = "shaymin"
    end

    if new_pokemon.name.include? "giratina"
      new_pokemon.name = "giratina"
    end
    ##sets pokemon stats
    pokemon_stat_setter(new_pokemon, pokemon_data, is_alternate)
    new_pokemon.save()

    ##set pokemons debut region
    pokemon_region_setter(new_pokemon, is_alternate)
    
    ##set pokemons type
    pokemon_type_setter(new_pokemon, pokemon_data, false)

    ##set pokemons abilities
    pokemon_ability_setter(new_pokemon, pokemon_data, false)

    ###set pokemons sprites
    pokemon_sprite_setter(new_pokemon,pokemon_data, false) 

    puts new_pokemon.name
    # binding.pry
    # # Save Pokemon to database
    # new_pokemon.save()
  end
end

def new_create_pokemon(site_data)
  new_pokemon = Pokemon.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  name = first_dexTab.split(" ")[1].downcase
  
  ## serebii gen 8 sprites
  # ps = Sprite.new(
  #   front_default: ("https://serebii.net"+site_data.css(".pkmn").at_css("img").attributes["src"].value),
  #   front_shiny: ""
  # )

  binding.pry
end

def pokemon_database_runner
  ### call type creator
  type_list = ["grass","water","fire","normal","electric","ice","fighting","poison","ground","flying","psychic","bug","rock","ghost","dragon","dark","steel","fairy"]
  create_types(type_list)

  ### call region creator
  region_list = ["kanto","johto","hoenn","sinnoh","unova","kalos","alola","galar"]
  create_regions(region_list)

  ### call ability creator
  ability_results_arr = pokemon_api_caller("https://pokeapi.co/api/v2/ability/?offset=0&limit=293")
  ability_results_arr.each do |ability|
    abil = create_abilities(url_caller(ability["url"]))
  end

  # Grabs the first 7 generations of pokemon without alternate forms
  pokemon_results_arr = pokemon_api_caller("https://pokeapi.co/api/v2/pokemon/?offset=0&limit=807")
    
  pokemon_results_arr.each do |pokemon|
      poke = create_pokemon(url_caller(pokemon["url"]), false)
  end

  # Grabs the first 7 generations alternate forms: including Megas/Region Variant etc. 
  pokemon_results_arr = pokemon_api_caller("https://pokeapi.co/api/v2/pokemon/?offset=807&limit=500")
    
  pokemon_results_arr.each do |pokemon|
      poke = create_pokemon(url_caller(pokemon["url"]), true)
  end

  binding.pry
  ### serebii pokemon scraper test
  # pokedex_num = 1
  # def num_conversion(num)
  #   if(num < 100)
  #     num = "00#{num}"
  #   end
  #   num
  # end

  # while pokedex_num != 2
  #   ### create url for Nokogiri search
  #   puts base_url = "https://serebii.net/pokedex-sm/#{num_conversion(pokedex_num)}.shtml"
    
  #   ### search pokemon by number
  #   html = open(base_url)
  #   doc = Nokogiri::HTML(html)

  #   ### send serebii data to create Pokemon function
  #   new_create_pokemon(doc)    
  #   pokedex_num += 1
  # end
  
  # binding.pry
end

pokemon_database_runner