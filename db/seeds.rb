require 'pry'
require 'json'
require 'rest_client'
require 'nokogiri'
require 'open-uri'

#Opens API call to pokeapi and returns all Pokemon From 1 - 807
#Parses that value using Rest-client
#Pokemon name followed by url of pokemon data

## weight is in kilograms. Divide  by 10 to get actual weight in 'kg'.
## height is in meters. Divide by 10 to get actual weight in 'm' 

### Pokemon for Manual Import
# alternate: {
#     name:nil,
#     pokemon_entry: nil,
#     pokedex_number: nil,
#     hp: nil,
#     attack: nil,
#     defense: nil,
#     special_attack: nil,
#     special_defense: nil,
#     speed: nil,
#     height: nil,
#     weight: nil,
#     sprites: {
#       alternate_form_id: nil,
#       front_default: nil,
#       front_shiny: nil
#     },
#     region: {
#       region_id: 8,
#       alternate_form_id: nil
#     },
#     type: {
#       type_id: nil,
#       alternate_form_id: nil
#     },
#     abilities: {
#       ability_id: nil,
#       alternate_form_id: nil
#     }
#   }

# standard:{
#     name:nil,
#     pokemon_entry: nil,
#     pokedex_number: nil,
#     hp: nil,
#     attack: nil,
#     defense: nil,
#     special_attack: nil,
#     special_defense: nil,
#     speed: nil,
#     height: nil,
#     weight: nil,
#     sprites: {
#       pokemon_id: nil,
#       front_default: nil,
#       front_shiny: nil
#     },
#     region: {
#       region_id: 8,
#       pokemon_id: nil
#     },
#     type: {
#       type_id: nil,
#       pokemon_id: nil
#     },
#     abilities: {
#       ability_id: nil,
#       pokemon_id: nil
#     }
#   }


melMetalArr = [
  {
    stats: {
    name:"meltan",
    pokemon_entry: "It melts particles of iron and other metals found in the subsoil, so it can absorb them into its body of molten steel.",
    pokedex_number: 808,
    hp: 46,
    attack: 65,
    defense: 65,
    special_attack: 55,
    special_defense: 35,
    speed: 34,
    height: 2,
    weight: 80
    },
    sprites: {
      pokemon_id: 808,
      front_default: "https://serebii.net/sunmoon/pokemon/808.png",
      front_shiny: "https://serebii.net/Shiny/SM/808.png"
    },
    region: {
      region_id: 7,
      pokemon_id: 808
    },
    type: {
      type_id: nil,
      pokemon_id: 808
    },
    abilities: {
      ability_id: 42,
      pokemon_id: 808
    }
  },
  {
    stats: {
    name:"melmetal",
    pokemon_entry: "Revered long ago for its capacity to create iron from nothing, for some reason it has come back to life after 3,000 years.",
    pokedex_number: 809,
    hp: 135,
    attack: 143,
    defense: 143,
    special_attack: 80,
    special_defense: 65,
    speed: 34,
    height: 25,
    weight: 8000
    },
    sprites: {
      pokemon_id: 809,
      front_default: "https://serebii.net/sunmoon/pokemon/809.png",
      front_shiny: "https://serebii.net/Shiny/SM/809.png"
    },
    region: {
      region_id: 7,
      pokemon_id: 809
    },
    type:
      {
      type_id: 17,
      pokemon_id: 809
      },
    abilities:
      {
      ability_id: 89,
      pokemon_id: 809
      }
  }
]

def num_conversion(num)
    if(num < 10)
      num = "00#{num}"
    elsif num < 100
      num = "0#{num}"
    end
    num
end

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

  elsif pokemon.name.include? "gigantamax"
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
    abil_name = ability_data["name"].split("-").join("_")
    # binding.pry
    abil = Ability.create(name:abil_name)
    puts abil.name
  else
    abil_name = ability_data["name"].split("-").join("_")
    # binding.pry
    abil = Ability.new(name:abil_name)
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

def createNewAbil(ability_url, name)
  html = open("https://www.serebii.net/"+ability_url)
  doc = Nokogiri::HTML(html)

  description = doc.css(".fooinfo")[0].text

  ability = Ability.create(name:name, description:description)

  ability
  # binding.pry
end

### Set Pokemon type associations
def pokemon_ability_setter(pokemon, stat_data, is_alternate)
  stat_data["abilities"].each do |item| 
    poke_abil = item["ability"]["name"].split("-").join("_")
    ability = Ability.find_by(name:poke_abil)
    if is_alternate
      pa = AlternateFormAbility.create(alternate_form_id:pokemon.id, ability_id:ability.id, is_hidden:item["is_hidden"])
    else
      # binding.pry
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
      front_shiny_female:stat_data["sprites"]["front_shiny_female"],
      gen_eight_front_default:"https://www.serebii.net/swordshield/pokemon/#{num_conversion(pokemon.pokedex_number)}.png",
      gen_eight_front_shiny: "https://www.serebii.net/Shiny/SWSH/#{num_conversion(pokemon.pokedex_number)}.png"
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
      front_shiny_female:stat_data["sprites"]["front_shiny_female"],
      gen_eight_front_default:"https://www.serebii.net/swordshield/pokemon/#{num_conversion(pokemon.pokedex_number)}.png",
      gen_eight_front_shiny: "https://www.serebii.net/Shiny/SWSH/#{num_conversion(pokemon.pokedex_number)}.png"
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
          formatted_name = "alolan_" + name.join("_")
        else
          formatted_name = "alolan_" + name.join("_")
        end
      # binding.pry
    elsif name.include? "galar"
      name = name.split("-")
      name.pop
      if name.length >= 3
        formatted_name = "galarian_" + name.join("_")
      else
        formatted_name = "galarian_" + name.join("_")
      end
      # binding.pry
    elsif name.include? "totem"
      if name.include? "mimikyu"
        formatted_name = "totem_mimikyu_" + name.split("-").pop
      else
        name = name.split("-")
        name.pop
        formatted_name = "totem_" + name.join("_")
        # binding.pry
      end
    elsif name.include? "mega"
      if name.split("-").length >= 3
        ending = name.split("-").pop
        name = name.split("-")
        name.pop
        formatted_name = name.reverse.join("_") + "_" + ending 
      else
        formatted_name = name.split("-").reverse.join("_")
      end
      # binding.pry
    elsif name.include? "gigantamax"
      formatted_name = name.split("-").reverse.join("_")
      # binding.pry
    else 
      formatted_name = name.split("-").join("_")
      # binding.pry
    end      
  else 
    formatted_name = name.split("-").join("_")
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
    # binding.pry
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
    poke_name = pokemon_data["name"].split("-").join("_")
    new_pokemon = Pokemon.new(name:poke_name)
    # binding.pry

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
    new_pokemon.save()
  end
end

def create_zac_zam(site_data)
  new_pokemon = Pokemon.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #name
  name = first_dexTab.split(" ")[1].split(" ").join("_").downcase
  new_pokemon.name = name

  #height
  height = site_data.css(".fooinfo")[6].text.split(" ").last.split("")
  height.pop
  height = (height.join.to_f * 10).to_i 
  new_pokemon.height = height

  #weight
  weight = site_data.css(".fooinfo")[7].text.split(" ").last.split("")
  ##pop pop lol
  weight.pop
  weight.pop
  weight = (weight.join.to_f * 10).to_i 
  new_pokemon.weight = weight

  #base stats
  len = site_data.css(".dextable").length - 2
  statArr = site_data.css(".dextable")[len].css("tr")[2].text.split(" ")
  statArr = statArr[5..-1]
  # binding.pry

  # binding.pry
  new_pokemon.hp = statArr[0]
  new_pokemon.attack = statArr[1]
  new_pokemon.defense = statArr[2]
  new_pokemon.special_attack = statArr[3]
  new_pokemon.special_defense = statArr[4]
  new_pokemon.speed = statArr[5]

  #pokedex entry
  entry = site_data.css(".dextable")[8].css(".fooinfo")[0].text
  new_pokemon.pokemon_entry = entry
  new_pokemon.save
  # binding.pry

  ## serebii gen 8 sprites
  ps = Sprite.create(
    pokemon_id: new_pokemon.id,
    front_default: "https://serebii.net/swordshield/pokemon/#{num_conversion(pokedex_number)}.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{num_conversion(pokedex_number)}.png"
  )

  # binding.pry
  pt = PokemonType.create(
    pokemon_id: new_pokemon.id,
    type_id: 18
  )

  # binding.pry

  ## pokemon ability
  abilitiesArr = []
  stop = (site_data.css(".dextable")[2].css("a").length/2) - 1
  count = 0

  loop do 
    elem = site_data.css(".dextable")[2].css("a")[count]

    abilName = elem.values.pop
    abilName = abilName.split("/abilitydex/")[-1].split(".shtml")[0].split("-").join("_")
    abil = Ability.find_by(name:abilName)

    puts abilName
    # binding.pry
    if abil == nil
      abil = createNewAbil(elem.values.pop, abilName)
      # binding.pry
    end

    pa = PokemonAbility.create(pokemon_id:new_pokemon.id, ability_id:abil.id)
    # puts pa.ability.name

    #break search
    if count == stop
      pa.is_hidden = true
      pa.save
      # binding.pry
      break
    end
    count = count + 1
  end

  ## pokemon region
  pr = PokemonRegion.create(pokemon_id:new_pokemon.id, region_id:8)

  # binding.pry
  puts new_pokemon.pokedex_number
  puts new_pokemon.name
end

def create_urshifu_single(site_data)
  new_pokemon = Pokemon.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #name
  name = first_dexTab.split(" ")[1].downcase
  new_pokemon.name = name + "_single_strike_style"

  #height
  height = site_data.css(".fooinfo")[6].text.split(" ").last.split("")
  height.pop
  height = (height.join.to_f * 10).to_i 
  new_pokemon.height = height

  #weight
  weight = site_data.css(".fooinfo")[7].text.split(" ").last.split("")
  ##pop pop lol
  weight.pop
  weight.pop
  weight = (weight.join.to_f * 10).to_i 
  new_pokemon.weight = weight

  #base stats
  len = site_data.css(".dextable").length - 4
  statArr = site_data.css(".dextable")[len].css("tr")[2].text.split(" ")
  statArr = statArr[5..-1]
  # binding.pry

  # binding.pry
  new_pokemon.hp = statArr[0]
  new_pokemon.attack = statArr[1]
  new_pokemon.defense = statArr[2]
  new_pokemon.special_attack = statArr[3]
  new_pokemon.special_defense = statArr[4]
  new_pokemon.speed = statArr[5]

  #pokedex entry
  entry = site_data.css(".dextable")[8].css(".fooinfo")[0].text
  new_pokemon.pokemon_entry = entry
  new_pokemon.save
  # binding.pry

  ## serebii gen 8 sprites
  ps = Sprite.create(
    pokemon_id: new_pokemon.id,
    front_default: "https://serebii.net/swordshield/pokemon/#{num_conversion(pokedex_number)}.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{num_conversion(pokedex_number)}.png"
  )

  # binding.pry
  pt = PokemonType.create(
    pokemon_id: new_pokemon.id,
    type_id: 7
  )

  pt2 = PokemonType.create(
    pokemon_id: new_pokemon.id,
    type_id: 16
  )

  # binding.pry

  ## pokemon ability
  abilitiesArr = []
  stop = (site_data.css(".dextable")[2].css("a").length/2) - 1
  count = 0

  loop do 
    elem = site_data.css(".dextable")[2].css("a")[count]

    abilName = elem.values.pop
    abilName = abilName.split("/abilitydex/")[-1].split(".shtml")[0]
    abil = Ability.find_by(name:abilName)

    # binding.pry
    if abil == nil
      abil = createNewAbil(elem.values.pop, abilName)
      # binding.pry
    end

    pa = PokemonAbility.create(pokemon_id:new_pokemon.id, ability_id:abil.id)
    # puts pa.ability.name

    #break search
    if count == stop
      pa.save
      # binding.pry
      break
    end
    count = count + 1
  end

  ## pokemon region
  pr = PokemonRegion.create(pokemon_id:new_pokemon.id, region_id:8)

  # binding.pry
  puts new_pokemon.pokedex_number
  puts new_pokemon.name
end

def create_urshifu_rapid(site_data)
  new_pokemon = Pokemon.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #name
  name = first_dexTab.split(" ")[1].downcase
  new_pokemon.name = name + "_rapid_strike_style"

  #height
  height = site_data.css(".fooinfo")[6].text.split(" ").last.split("")
  height.pop
  height = (height.join.to_f * 10).to_i 
  new_pokemon.height = height

  #weight
  weight = site_data.css(".fooinfo")[7].text.split(" ").last.split("")
  ##pop pop lol
  weight.pop
  weight.pop
  weight = (weight.join.to_f * 10).to_i 
  new_pokemon.weight = weight

  #base stats
  len = site_data.css(".dextable").length - 3
  statArr = site_data.css(".dextable")[len].css("tr")[2].text.split(" ")
  statArr = statArr[5..-1]
  # binding.pry

  # binding.pry
  new_pokemon.hp = statArr[0]
  new_pokemon.attack = statArr[1]
  new_pokemon.defense = statArr[2]
  new_pokemon.special_attack = statArr[3]
  new_pokemon.special_defense = statArr[4]
  new_pokemon.speed = statArr[5]

  #pokedex entry
  entry = site_data.css(".dextable")[8].css(".fooinfo")[2].text
  new_pokemon.pokemon_entry = entry
  new_pokemon.save
  # binding.pry

  ## serebii gen 8 sprites
  ps = Sprite.create(
    pokemon_id: new_pokemon.id,
    front_default: "https://serebii.net/swordshield/pokemon/#{num_conversion(pokedex_number)}-r.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{num_conversion(pokedex_number)}-r.png"
  )

  # binding.pry
  pt = PokemonType.create(
    pokemon_id: new_pokemon.id,
    type_id: 7
  )

  pt2 = PokemonType.create(
    pokemon_id: new_pokemon.id,
    type_id: 2
  )

  # binding.pry

  ## pokemon ability
  abilitiesArr = []
  stop = (site_data.css(".dextable")[2].css("a").length/2) - 1
  count = 0

  loop do 
    elem = site_data.css(".dextable")[2].css("a")[count]

    abilName = elem.values.pop
    abilName = abilName.split("/abilitydex/")[-1].split(".shtml")[0]
    abil = Ability.find_by(name:abilName)

    # binding.pry
    if abil == nil
      abil = createNewAbil(elem.values.pop, abilName)
      # binding.pry
    end

    pa = PokemonAbility.create(pokemon_id:new_pokemon.id, ability_id:abil.id)
    # puts pa.ability.name

    #break search
    if count == stop
      pa.save
      # binding.pry
      break
    end
    count = count + 1
  end

  ## pokemon region
  pr = PokemonRegion.create(pokemon_id:new_pokemon.id, region_id:8)

  # binding.pry
  puts new_pokemon.pokedex_number
  puts new_pokemon.name
end

def new_create_pokemon(site_data)
  new_pokemon = Pokemon.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #name
  name = first_dexTab.split(" ")[1].split(" ").join("_").downcase
  new_pokemon.name = name

  if name.include? "mr"
    new_pokemon.name = "mr_rime"
  end

  if name.include? "far"
    new_pokemon.name = "sirfetchd"
  end

  #height
  height = site_data.css(".fooinfo")[6].text.split(" ").last.split("")
  height.pop
  height = (height.join.to_f * 10).to_i 
  new_pokemon.height = height

  #weight
  weight = site_data.css(".fooinfo")[7].text.split(" ").last.split("")
  ##pop pop lol
  weight.pop
  weight.pop
  weight = (weight.join.to_f * 10).to_i 
  new_pokemon.weight = weight

  #base stats
  statArr = site_data.css(".dextable").last.css("tr")[2].text.split(" ")
  statArr = statArr[5..-1]

  if statArr == nil
    len = site_data.css(".dextable").length - 2
    statArr = site_data.css(".dextable")[len].css("tr")[2].text.split(" ")
    statArr = statArr[5..-1]
  end

  # binding.pry
  new_pokemon.hp = statArr[0]
  new_pokemon.attack = statArr[1]
  new_pokemon.defense = statArr[2]
  new_pokemon.special_attack = statArr[3]
  new_pokemon.special_defense = statArr[4]
  new_pokemon.speed = statArr[5]

  #pokedex entry
  entry = site_data.css(".dextable")[7].css(".fooinfo")[0].text
  new_pokemon.pokemon_entry = entry
  new_pokemon.save
  # binding.pry

  ## serebii gen 8 sprites
  ps = Sprite.create(
    pokemon_id: new_pokemon.id,
    gen_eight_front_default: "https://serebii.net/swordshield/pokemon/#{num_conversion(pokedex_number)}.png",
    gen_eight_front_shiny: "https://serebii.net/Shiny/SWSH/#{num_conversion(pokedex_number)}.png"
  )

  ## Find first type on Serebii
  type1 = site_data.css("td").at_css(".cen").children[0].values[0].split("/pokedex-swsh/")[-1].split(".")[0]

  type1 = Type.find_by(name:type1)

  # binding.pry
  pt = PokemonType.create(
    pokemon_id: new_pokemon.id,
    type_id: type1.id
  )

  # binding.pry
  ## if Dual Type Poke Add Second Type
  if site_data.css("td").at_css(".cen").children[1] != nil

    type2 = site_data.css("td").at_css(".cen").children[2].values[0].split("/pokedex-swsh/")[-1].split(".")[0]

    type2 = Type.find_by(name:type2)

    pt2 = PokemonType.create(
    pokemon_id: new_pokemon.id,
    type_id: type2.id
    )
  end

  ## pokemon ability
  abilitiesArr = []
  stop = (site_data.css(".dextable")[2].css("a").length/2) - 1
  count = 0

  loop do 
    elem = site_data.css(".dextable")[2].css("a")[count]

    abilName = elem.values.pop
    abilName = abilName.split("/abilitydex/")[-1].split(".shtml")[0]
    abil = Ability.find_by(name:abilName)

    # binding.pry
    if abil == nil
      abil = createNewAbil(elem.values.pop, abilName)
      # binding.pry
    end

    pa = PokemonAbility.create(pokemon_id:new_pokemon.id, ability_id:abil.id)
    # puts pa.ability.name

    #break search
    if count == stop
      pa.is_hidden = true
      pa.save
      # binding.pry
      break
    end
    count = count + 1
  end

  ## pokemon region
  pr = PokemonRegion.create(pokemon_id:new_pokemon.id, region_id:8)

  # binding.pry
  puts new_pokemon.pokedex_number
  puts new_pokemon.name
end

def new_create_alternate_form(site_data, ability_data, fix_name)
  new_pokemon = AlternateForm.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #name
  name = first_dexTab.split(" ")[1].split(" ").join("_").downcase
  new_pokemon.name = "galarian_"+name

  if fix_name.include? "mr"
    name = "mr_mime"
    new_pokemon.name = "galarian_"+name
  end

  if fix_name.include? "far"
    name = "farfetchd"
    new_pokemon.name = "galarian_"+name
  end

  if fix_name.include? "zacian"
    name = "zacian_crowned_sword"
    new_pokemon.name = name
  end

  if fix_name.include? "zamazenta"
    name = "zamazenta_crowned_sword"
    new_pokemon.name = name
  end

  # binding.pry
  ##find original pokemon
  original_pokemon = Pokemon.find_by(pokedex_number:new_pokemon.pokedex_number)
  new_pokemon.pokemon_id = original_pokemon.id
  # binding.pry

  #height
  height = site_data.css(".fooinfo")[6].text.split(" ").last.split("")
  height.pop
  height = (height.join.to_f * 10).to_i 
  new_pokemon.height = height

  #weight
  weight = site_data.css(".fooinfo")[7].text.split(" ").last.split("")
  ##pop pop lol
  weight.pop
  weight.pop
  weight = (weight.join.to_f * 10).to_i 
  new_pokemon.weight = weight

  #base stats
  statArr = site_data.css(".dextable").last.css("tr")[2].text.split(" ")
  statArr = statArr[5..-1]

  if statArr == nil
    len = site_data.css(".dextable").length - 2
    statArr = site_data.css(".dextable")[len].css("tr")[2].text.split(" ")
    statArr = statArr[5..-1]
  end

  # binding.pry
  new_pokemon.hp = statArr[0]
  new_pokemon.attack = statArr[1]
  new_pokemon.defense = statArr[2]
  new_pokemon.special_attack = statArr[3]
  new_pokemon.special_defense = statArr[4]
  new_pokemon.speed = statArr[5]

  #pokedex entry
  entry = site_data.css(".dextable")[8].css(".fooinfo")[0].text
  new_pokemon.pokemon_entry = entry
  new_pokemon.save
  # binding.pry

  ## serebii gen 8 sprites
  ps = AlternateFormSprite.create(
    alternate_form_id: new_pokemon.id,
    front_default: "https://serebii.net/swordshield/pokemon/#{num_conversion(pokedex_number)}.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{num_conversion(pokedex_number)}.png"
  )

  ## Find first type on Serebii
  type1 = site_data.css("td").at_css(".cen").css("tr")[1].css("a")[0].values[0].split("/pokedex-swsh/")[-1].split(".")[0]

  type1 = Type.find_by(name:type1)

  # binding.pry
  pt = AlternateFormType.create(
    alternate_form_id: new_pokemon.id,
    type_id: type1.id
  )

  # binding.pry
  ## if Dual Type Poke Add Second Type
  if site_data.css("td").at_css(".cen").css("tr")[1].css("a")[1] != nil

    type2 = site_data.css("td").at_css(".cen").css("tr")[1].css("a")[1].values[0].split("/pokedex-swsh/")[-1].split(".")[0]

    type2 = Type.find_by(name:type2)

    pt2 = AlternateFormType.create(
    alternate_form_id: new_pokemon.id,
    type_id: type2.id
    )
  end

  # binding.pry
  ## pokemon ability
  stop = ability_data.length-1
  count = 0

  loop do 
    elem = ability_data[count]

    abilName = elem.values.pop
    abilName = abilName.split("/abilitydex/")[-1].split(".shtml")[0]
    abil = Ability.find_by(name:abilName)

    # binding.pry
    if abil == nil
      abil = createNewAbil(elem.values.pop, abilName)
      # binding.pry
    end

    pa = AlternateFormAbility.create(alternate_form_id:new_pokemon.id, ability_id:abil.id)
    puts pa.ability.name

    #break search
    if count == stop
      pa.is_hidden = true
      pa.save
      # binding.pry
      break
    end
    count = count + 1
  end

  # binding.pry

  ## pokemon region
  pr = AlternateRegion.create(alternate_form_id:new_pokemon.id, region_id:8)

  # binding.pry
  puts new_pokemon.name
end

def new_create_gigantamax_form(site_data, fix_name)
  new_pokemon = AlternateForm.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #gigantamax
  new_pokemon.is_gigantimax = true
  
  #name
  name = first_dexTab.split(" ")[1].downcase
  new_pokemon.name = "gigantamax_"+name

  if fix_name.include? "mr"
    name = "mr_mime"
    new_pokemon.name = "gigantamax_"+name
  end

  if fix_name.include? "far"
    name = "farfetchd"
    new_pokemon.name = "gigantamax_"+name
  end

  ##find original pokemon
  if fix_name.include? "urshifu_single_strike_style"

    original_pokemon = Pokemon.find_by(name:"urshifu_single_strike_style")

    new_pokemon.name = "gigantamax_"+"urshifu_single_strike_style"

    new_pokemon.pokemon_id = original_pokemon.id
  elsif fix_name.include? "urshifu_rapid_strike_style"

    original_pokemon = Pokemon.find_by(name:"urshifu_rapid_strike_style")

    new_pokemon.name = "gigantamax_"+"urshifu_rapid_strike_style"

    new_pokemon.pokemon_id = original_pokemon.id
  else
    original_pokemon = Pokemon.find_by(pokedex_number:new_pokemon.pokedex_number)
    # binding.pry
    new_pokemon.pokemon_id = original_pokemon.id
  end

  new_pokemon.hp = original_pokemon.hp
  new_pokemon.attack = original_pokemon.attack
  new_pokemon.defense = original_pokemon.defense
  new_pokemon.special_attack = original_pokemon.special_attack
  new_pokemon.special_defense = original_pokemon.special_defense
  new_pokemon.speed = original_pokemon.speed

  ###height
  height = site_data.css(".dextable").last
  height = height.css("tr")[3].css(".fooinfo")[0].text.split(" ").last.split("")
  height.pop
  height = (height.join.to_f * 10).to_i 
  new_pokemon.height = height

  # binding.pry
  new_pokemon.save

  ## serebii gen 8 sprites
  ps = AlternateFormSprite.create(
    alternate_form_id: new_pokemon.id,
    front_default: "https://serebii.net/swordshield/pokemon/#{num_conversion(pokedex_number)}-gi.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{num_conversion(pokedex_number)}-gi.png"
  )

  ## pokemon region
  pr = AlternateRegion.create(alternate_form_id:new_pokemon.id, region_id:8)

  # binding.pry

end

def evo_chain_maker(curr_tr, curr_td, prev_tr, prev_td, evo_doc, poke_in_dict)

  # binding.pry

  ########################################
  ##### End Recursion ####################
  ########################################
  if curr_tr >= evo_doc[0].css("tr").length
    return poke_in_dict
  end

  ########################################
  ### No Evolutions ######################
  ########################################
  if evo_doc[0].css("tr").length == evo_doc[0].css("tr").css("td").length
    poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i

    if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "sword"
      poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
    end

    pre_evo = Pokemon.find_by(pokedex_number:poke_num)

    if poke_in_dict[pre_evo.name] == nil
      poke_in_dict[pre_evo.name] = nil
    end
    return poke_in_dict
  end

  ######################################################
  ####### Is that you Eevee? Tyrogue ? #################
  ######################################################
  # binding.pry
  if evo_doc.css("tr")[curr_tr].css("td")[curr_td].attributes["colspan"]
    evo = Evolution.new()

    start = 1
    stop = evo_doc[0].css("td").length - 4
    ###########################
    ### grab colspan pokemon ##
    ###########################
    pre_evo_num = evo_doc[0].css("td")[0].children[0].attributes["href"].value.split("").slice(12,3).join.to_i

    if pre_evo_num == 0
      return poke_in_dict
    end

    if Pokemon.find_by(pokedex_number:pre_evo_num)
      pre_evo = Pokemon.find_by(pokedex_number:pre_evo_num)
      evo.pokemon_id = pre_evo.id
    else
      pre_evo = AlternateForm.find_by(pokedex_number:pre_evo_num)
      evo = AlternateFormEvo.new()
      evo.alternate_form_id = pre_evo.id
    end

    if pre_evo.name == "tyrogue"
      add = 3
    else
      add = 8
      stop = evo_doc[0].css("td").length - 9
    end

    while start <= stop
      ##########################################
      ####### grab the post evo ################
      ##########################################
      # binding.pry
      evo = Evolution.new()
      evo.pokemon_id = pre_evo.id

      post_evo_num = evo_doc[0].css("td")[start+add].children[0].attributes["href"].value.split("").slice(12,3).join.to_i

      if Pokemon.find_by(pokedex_number:post_evo_num)
        post_evo = Pokemon.find_by(pokedex_number:post_evo_num)
        evo.evo_to = post_evo.name
        
      else
        post_evo = AlternateForm.find_by(pokedex_number:post_evo_num)
        evo.evo_to = post_evo.name
      end
      
      ############################################
      ##### is this in the poke dict? ############
      ############################################
      if poke_in_dict[pre_evo.name] != nil
        ### does this pokemon have multiple evos #
        if poke_in_dict[pre_evo.name].include? post_evo.name
          # binding.pry
          start += 1
          next
        end
      end
      
      ############################################
      ####### put poke in the dict ###############
      ############################################
      if poke_in_dict[pre_evo.name] == nil
        poke_in_dict[pre_evo.name] = [post_evo.name]
        
        ################################################
        ### is this an existing pokemon with a new evo #
      else
        poke_in_dict[pre_evo.name].push(post_evo.name)
      end
      
      ############################################
      ###### grab the evo when ###################
      # binding.pry
      evo_when = evo_doc[0].css("td")[start].children[0].attributes["alt"]
      
      if evo_when == nil
        evo_when = evo_doc[0].css("td")[start].children[0].children[0].attributes["alt"].value
        evo.evo_when = evo_when
      else
        evo.evo_when = evo_when.value
      end

      ############jump to evo
      evo.save()
      
      start +=1
    end
    
    return poke_in_dict
  end
  
  #######################################################
  ###### Which came first the nidoran or the Egg? #######
  #######################################################
  pre_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"]
  if pre_evo_name != nil
    if pre_evo_name.value.downcase == "egg"
      # binding.pry

      ###################################
      ##### Illumise and Volbeat ########
      ill_name = evo_doc.css("tr")[curr_tr+1].css("td")[curr_td+1].css("img")[0].attributes["alt"].value.downcase

      vol_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"].value.downcase

      if ill_name == "illumise"
        if poke_in_dict[ill_name] == nil
          poke_in_dict[ill_name] = nil
        end
        if poke_in_dict[vol_name] == nil
          poke_in_dict[vol_name] = nil
        end

        return poke_in_dict
      end

      poke_in_dict = evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)

      poke_in_dict = evo_chain_maker(curr_tr+1, curr_td+1, prev_tr, prev_td, evo_doc, poke_in_dict)
      
      return poke_in_dict
    end
  end

  ########################################################
  ### is this a second evo for prev pokemon ##############
  ########################################################
  if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "evo"
    # binding.pry

    evo = Evolution.new()

    ###########################################
    #### find pre evo #########################
    # binding.pry
    if prev_tr == nil || prev_td == nil 
      return poke_in_dict
    end

    pre_evo_name = evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["alt"] 
    if pre_evo_name == nil 
      
      ##############################################
      ## since no name lets get its number #########
      if evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.split("").slice(17,5).join.include? "-a"

        poke_num = evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i
        
        ### is this alolan?
        pre_evo = AlternateForm.find_by(pokedex_number:poke_num)
        if pre_evo.name.include? "alolan"
          evo = AlternateFormEvo.new()
          evo.alternate_form_id = pre_evo.id
        end
        # binding.pry

      ###################################################
      ######### jump to galar forms #####################
      ###################################################
      elsif evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.include? "-g"
        # binding.pry
        poke_num = evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i

        pre_evo = AlternateForm.find_by(pokedex_number:poke_num)
        pre_evo = "galarian_" + pre_evo.name.split(" ").last
        pre_evo = AlternateForm.find_by(name:pre_evo)
        evo = AlternateFormEvo.new()
        evo.alternate_form_id = pre_evo.id
      elsif evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.include? "-r"
        pre_evo = Pokemon.find_by(name:"urshifu_rapid_strike_style")
        evo.pokemon_id = pre_evo.id

        # binding.pry
      else
        poke_num = evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i

        if evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.include? "sword"
          poke_num = evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
        end

        # binding.pry
        pre_evo = Pokemon.find_by(pokedex_number:poke_num)
        evo.pokemon_id = pre_evo.id
      end
      #####################################################
      ##### name does exist proceed as normal #############
    else 
      pre_evo_name = evo_doc.css("tr")[prev_tr].css("td")[prev_td].css("img")[0].attributes["alt"].value.downcase.split(" ").join("_")
      # binding.pry
    
      if Pokemon.find_by(name:pre_evo_name) != nil
        pre_evo = Pokemon.find_by(name:pre_evo_name)
        evo.pokemon_id = pre_evo.id
      else
        # binding.pry
        pre_evo = AlternateForm.find_by(name:pre_evo_name)
        evo = AlternateFormEvo.new()
        evo.alternate_form_id = pre_evo.id
      end
    end

    ## find post evo
    post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"]
    # binding.pry
    if post_evo_name == nil 
  
      ######################################
      ##since no name lets get its number ##
      ### is this alolan? ##################
      if evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("").slice(17,5).join.include? "-a"
  
        poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i
        
        post_evo = AlternateForm.find_by(pokedex_number:poke_num)
        if post_evo.name.include? "alolan"
          evo.evo_to = post_evo.name
        end

      ########################################
      ###### jump to galar forms #############
      ########################################
      elsif evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.include? "-g"
        # binding.pry
        poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i

        post_evo = AlternateForm.find_by(pokedex_number:poke_num)
        post_evo = "galarian_" + post_evo.name.split(" ").last
        post_evo = AlternateForm.find_by(name:post_evo)
        evo.alternate_form_id = post_evo.id

      elsif evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.include? "-r"
        post_evo = Pokemon.find_by(name:"urshifu_rapid_strike_style")
        evo.evo_to = post_evo.name
        # binding.pry
      #######################################  
      ###### its a regular pokemon ##########
      else
        poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i

        if evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.include? "sword"
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
        end
  
        # binding.pry
        post_evo = Pokemon.find_by(pokedex_number:poke_num)
        evo.evo_to = post_evo.name
      end
  
    else 
      post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"].value.downcase.split(" ").join("_")

      ##### jump to last
      # if post_evo_name = "gigantamax urshifu"
      #   post_evo_name = "gigantamax urshifu-rapid-strike-style"
      # end

      # binding.pry
    
      if Pokemon.find_by(name:post_evo_name) != nil
        post_evo = Pokemon.find_by(name:post_evo_name)
        evo.evo_to = post_evo.name
      else
        # binding.pry
        post_evo = AlternateForm.find_by(name:post_evo_name)
        evo.evo_to = post_evo.name
      end
    end
    # binding.pry

    ## is pokemon already in dict?
    if poke_in_dict[pre_evo.name] != nil

      ### is this evo already in dict?
      if poke_in_dict[pre_evo.name].include? post_evo.name
        next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+3]

        if next_evo == nil
          # binding.pry
          poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
        else
          # binding.pry
          poke_in_dict = evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)
        end

        return poke_in_dict
      end
    end
    
    ####################################################
    ## if a new poke add evo_when and save evo #########
    ####################################################
    if evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"] == nil
      evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["title"].value.strip.downcase
      evo.evo_when = evo_when
    else 
      evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"].value.strip.downcase
      evo.evo_when = evo_when
    end

    if evo_when.include? "level"
      at_level = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("/")[1].split(".")[0].split("")
      at_level.shift
      at_level = at_level.join("")
      evo_when = evo_when + " " + at_level
      evo.evo_when = evo_when
    end

    evo.save()
    
    # binding.pry

    ## is this a new pokemon then create key
    if poke_in_dict[pre_evo.name] == nil
      poke_in_dict[pre_evo.name] = [post_evo.name]

    ### is this an existing pokemon with a new evo
    else
      poke_in_dict[pre_evo.name].push(post_evo.name)
    end

    # binding.pry

    ## is there a next evo ?
    next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+3]
    # binding.pry

    if next_evo == nil
      # binding.pry
      poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
    else
      # binding.pry
      poke_in_dict = evo_chain_maker(curr_tr, curr_td+1, prev_tr, prev_td, evo_doc, poke_in_dict)
    end

    # binding.pry

    return poke_in_dict

  end

  ##########################################
  ### run as normal ########################
  ##########################################
  evo = Evolution.new()


  ###########################################
  #### find pre evo #########################
  pre_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"]
  # binding.pry
  
  ###########################################
  ### Name Exception List ###################
  ###########################################
  # binding.pry
  if pre_evo_name != nil 
    if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"].value.downcase.include? "nido"
      pre_evo_name = nil
    end

    if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"].value.downcase.include? "farfetch'd"
      pre_evo_name = nil
    end
    if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"].value.downcase.include? "Mime"
      pre_evo_name = nil
    end
    # binding.pry
  end

  if pre_evo_name == nil 
    # binding.pry

    ##############################################
    ## since no name lets get its number #########
    if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(17,5).join.include? "-a"

      poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i
      
      pre_evo = AlternateForm.find_by(pokedex_number:poke_num)
      if pre_evo.name.include? "alolan"
        evo = AlternateFormEvo.new()
        evo.alternate_form_id = pre_evo.id
      end
      ### is this alolan?
      # binding.pry
    
    ###########################################
    #### jump to galar forms ##################
    ###########################################
    elsif evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "-g"
      # binding.pry
      poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i

      if AlternateForm.find_by(pokedex_number:poke_num)
        pre_evo = AlternateForm.find_by(pokedex_number:poke_num)
        if pre_evo.name.include? "galarian"
          pre_evo
          pre_evo = AlternateForm.find_by(name:pre_evo.name)
        else 
          pre_evo = "galarian_" + pre_evo.name.split("_").last
          pre_evo = AlternateForm.find_by(name:pre_evo)
        end
      else 
        pre_evo = Pokemon.find_by(pokedex_number:poke_num)
        pre_evo = "galarian_" + pre_evo.name
        pre_evo = AlternateForm.find_by(name:pre_evo)
      end
      evo = AlternateFormEvo.new()
      evo.alternate_form_id = pre_evo.id
      # binding.pry

    elsif evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "-r"
      pre_evo = Pokemon.find_by(name:"urshifu_rapid_strike_style")
      evo.pokemon_id = pre_evo.id

    else
      poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i

      if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "sword"
        if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "-a"
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
          variant = true
        else
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
        end
      end

      # binding.pry
      if variant 
        pre_evo = AlternateForm.find_by(pokedex_number:poke_num)
        evo = AlternateFormEvo.new()
        evo.alternate_form_id
      else
        pre_evo = Pokemon.find_by(pokedex_number:poke_num)
        evo.pokemon_id = pre_evo.id

      end
      # binding.pry

    end
  #######################################################
  ####### name does exist proceed as normal #############
  else 
    pre_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["alt"].value.downcase.split(" ").join("_")
    # binding.pry

    if pre_evo_name.include? "-"
      pre_evo_name = pre_evo_name.split("-").join("_")
    end

    if pre_evo_name.include? "Mr. Mime"
      pre_evo_name = "mr_mime"
    elsif pre_evo_name.include? "rime"
      pre_evo_name = "mr_rime"
    elsif pre_evo_name.include? "mime jr."
      pre_evo_name = "mime_jr"
    end

    if pre_evo_name.include? "flab"
      pre_evo_name = "flabebe"
    end

    if pre_evo_name.include? "pumpkaboo"
      pre_evo_name = "pumpkaboo_average"
    end

    if pre_evo_name.include? "type:"
      pre_evo_name = "type_null"
    end

    # binding.pry
    if pre_evo_name == "urshifu"
      pre_evo_name = "urshifu_single_strike_style"
    end

    # binding.pry
    if Pokemon.find_by(name:pre_evo_name) != nil
      pre_evo = Pokemon.find_by(name:pre_evo_name)
      evo.pokemon_id = pre_evo.id
    else
      # binding.pry
      pre_evo = AlternateForm.find_by(name:pre_evo_name)
      evo = AlternateFormEvo.new()
      evo.alternate_form_id = pre_evo.id
    end
  end

  
  ####################################################
  ###### The great Feebass Error #####################
  ####################################################
  # binding.pry
  if  pre_evo.name == "feebas"
    if poke_in_dict[pre_evo.name] == nil
      poke_in_dict[pre_evo.name] = ["milotic"]
      evo_when_one = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"].value.strip.downcase
      evo_when_two = evo_doc.css("tr")[curr_tr+1].css("td")[curr_td].css("img")[0].attributes["alt"].value.strip.downcase

      evo.evo_to = "milotic"
      evo.evo_when = evo_when_one
      evo.save()

      evo_two = Evolution.new()
      evo_two.pokemon_id = pre_evo.id 
      evo_two.evo_when = evo_when_two
      evo_two.evo_to = "milotic"
      evo_two.save()
    end
    # binding.pry

    return poke_in_dict
  end

  #####################################################
  ###### The Great Mr.Mime Error ######################
  #####################################################
  # binding.pry
  if  pre_evo.name == "mime_jr"
    if poke_in_dict[pre_evo.name] == nil
      poke_in_dict[pre_evo.name] = ["mr_mime", "galarian_mr_mime"]
      evo_when_one = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"].value.strip.downcase
      evo.evo_when = evo_when_one
      evo.evo_to = "mr_mime"
      evo.save()

      evo2 = Evolution.new()
      evo2.pokemon_id = pre_evo.id
      evo2.evo_to = "galarian_mr_mime"
      evo2.evo_when = evo_when_one
      evo2.save()

      g_mime = AlternateForm.find_by(name:"galarian_mr_mime")
      evo3 = AlternateFormEvo.new()
      poke_in_dict[g_mime.name] = ["mr_rime"]

      evo_when_two = evo_doc.css("tr")[curr_tr+1].css("td")[curr_td+1].css("img")[0].attributes["title"].value.strip.downcase

      if evo_when_two.include? "level"
        at_level = evo_doc.css("tr")[curr_tr+1].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("/")[1].split(".")[0].split("")
        at_level.shift
        at_level = at_level.join("")
        evo_when_two = evo_when_two + " " + at_level
        evo3.evo_when = evo_when_two
      end

      evo3.evo_when = evo_when_two
      evo3.evo_to = "mr_rime"
      evo3.alternate_form_id = g_mime.id
      evo3.save()
      # binding.pry

      return poke_in_dict
    end
    # binding.pry

    return poke_in_dict
  end

  # binding.pry

  ###########################################
  #### Is this node 2 rows? #################
  if evo_doc[0].css("tr")[curr_tr].css("td")[curr_td].attributes["rowspan"] != nil
    # binding.pry

    ##################################################
    ######## grab the next node ######################
    is_next_node_one = evo_doc[0].css("tr")[curr_tr].css("td")[curr_td+1].attributes["rowspan"]

    ##############################################
    ### is the next node a rowspan 2 still #######
    ##############################################
    if is_next_node_one != nil
      # binding.pry
      post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"]

      if post_evo_name != nil 
        if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"].value.downcase.include? "nido"
          post_evo_name = nil
        end
        # binding.pry
      end

      if post_evo_name == nil 
        # binding.pry
        ######################################
        ##since no name lets get its number ##
        ### is this alolan? ##################
        if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,5).join.include? "-a"
    
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i
          
          post_evo = AlternateForm.find_by(pokedex_number:poke_num)
          if post_evo.name.include? "alolan"
            evo.evo_to = post_evo.name
          end
        #############################################
        ##### jump to galar forms ###################
        #############################################
        elsif evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.include? "-g"
          # binding.pry

          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i

          post_evo = AlternateForm.find_by(pokedex_number:poke_num)
          post_evo = "galarian_" + post_evo.name.split(" ").last.join("_")
          post_evo = AlternateForm.find_by(name:post_evo)
          evo.alternate_form_id = post_evo.id
          ######################################  
          ###### its a regular pokemon ##########
        else
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i
          
          if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "sword"
            poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
          end
    
          post_evo = Pokemon.find_by(pokedex_number:poke_num)
          evo.evo_to = post_evo.name
        end
    
      else 
        post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"].value.downcase.split(" ").join("_")
      
        if Pokemon.find_by(name:post_evo_name) != nil
          post_evo = Pokemon.find_by(name:post_evo_name)
          evo.evo_to = post_evo.name
        else
          # binding.pry
          post_evo = AlternateForm.find_by(name:post_evo_name)
          evo.evo_to = post_evo.name
        end
      end

      ##############################################
      ## is pokemon already in dict? ###############
      ##############################################
      if poke_in_dict[pre_evo.name] != nil

        ### is this evo already in dict?
        if poke_in_dict[pre_evo.name].include? post_evo.name
          next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+4]

          if next_evo == nil
            poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
          else
            poke_in_dict = evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)
          end

          return poke_in_dict
        end
      end
    
      ####################################################
      ## if a new poke add evo_when and save evo #########
      ####################################################
      if evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"] == nil
        evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["title"].value.strip.downcase
      else 
        evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"].value.strip.downcase
      end

      if evo_when.include? "level"
        at_level = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("/")[1].split(".")[0].split("")
        at_level.shift
        at_level = at_level.join("")
        evo_when = evo_when + " " + at_level
        evo.evo_when = evo_when
      end

      evo.save()

      ##############################################
      ## is this a new pokemon then create key #####
      ##############################################
      if poke_in_dict[pre_evo.name] == nil
        poke_in_dict[pre_evo.name] = [post_evo.name]

      ################################################
      ### is this an existing pokemon with a new evo #
      else
        poke_in_dict[pre_evo.name].push(post_evo.name)
      end

      ## is there a next evo ?
      next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+4]

      # binding.pry
      if next_evo == nil
        poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
      else
        poke_in_dict = evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)
      end

      return poke_in_dict
      # binding.pry
      ##################################################
      ##### else its a 1 span next #####################
      ##################################################
    else
      # binding.pry
      prev_tr = curr_tr
      prev_td = curr_td

      post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"] 
      # binding.pry
      if post_evo_name == nil 
        # binding.pry
        ########################################
        ## since no name lets get its number ###
        if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(17,5).join.include? "-a"
    
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i
          
          post_evo = AlternateForm.find_by(pokedex_number:poke_num)
          if post_evo.name.include? "alolan"
            evo.evo_to = post_evo.name
          end
          ### is this alolan?
          # binding.pry

        ##############################################
        ########### jump to galar forms ##############
        ##############################################
        elsif evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.include? "-g"
          # binding.pry
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i

          post_evo = AlternateForm.find_by(pokedex_number:poke_num)
          post_evo = "galarian_" + post_evo.name.split(" ").last.join("_")
          post_evo = AlternateForm.find_by(name:post_evo)
          evo.alternate_form_id = post_evo.id
        else
          poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i

          if evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.include? "sword"
            poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
          end
    
          post_evo = Pokemon.find_by(pokedex_number:poke_num)
          evo.evo_to = post_evo.name
        end
    
      else 
        post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"].value.downcase.split(" ").join("_")

        if post_evo_name == "urshifu"
          post_evo_name = "urshifu_single_strike_style"
        end

        # binding.pry
      
        if Pokemon.find_by(name:post_evo_name) != nil
          post_evo = Pokemon.find_by(name:post_evo_name)
          evo.evo_to = post_evo.name
        else
          # binding.pry
          post_evo = AlternateForm.find_by(name:post_evo_name)
          evo.evo_to = post_evo.name
        end
      end
    end
    #######################################
    ## is pokemon already in dict? ########
    #######################################
    # binding.pry
    if poke_in_dict[pre_evo.name] != nil

      ### is this evo already in dict?
      if poke_in_dict[pre_evo.name].include? post_evo.name
        next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+4]

        # binding.pry

        if next_evo == nil
          poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
        else
          poke_in_dict = evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)
        end

        return poke_in_dict
      end
    end
    
      #################################################
      ## if a new poke add evo_when and save evo ######
      #################################################
      if evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"] == nil
        evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["title"].value.strip.downcase
        evo.evo_when = evo_when
      else 
        evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"].value.strip.downcase
        evo.evo_when = evo_when
      end

      # binding.pry

      if evo_when.include? "level"
        at_level = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("/")[1].split(".")[0].split("")
        at_level.shift
        at_level = at_level.join("")
        evo_when = evo_when + " " + at_level
        evo.evo_when = evo_when
      end

      evo.save()

      #############################################
      ## is this a new pokemon then create key ####
      #############################################
      if poke_in_dict[pre_evo.name] == nil
        poke_in_dict[pre_evo.name] = [post_evo.name]

      ### is this an existing pokemon with a new evo
      else
        poke_in_dict[pre_evo.name].push(post_evo.name)
      end

      # binding.pry

      ###############################################
      ## is there a next evo ? ######################
      next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+4]

      if next_evo == nil
        # binding.pry
        poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
      else
        # binding.pry
        poke_in_dict = evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)
      end

      # binding.pry

      # return poke_in_dict

    ###############################################  
    ##### starts with a span 1 ####################
    ###############################################
  else
    ## find post evo
    next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2]
    # binding.pry

    if next_evo == nil
      return poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
    else
      puts "lol"
    end
    
    # binding.pry
    post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"]

    # binding.pry
    if post_evo_name != nil 
      if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"].value.downcase.include? "nido"
        post_evo_name = nil
      end
      if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"].value.downcase.include? "fetch"
        post_evo_name = nil
      end
      # binding.pry
    end

    if post_evo_name == nil 

      # binding.pry
      ##since no name lets get its number
      if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,5).join.include? "-a"

        poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i
        
        post_evo = AlternateForm.find_by(pokedex_number:poke_num)
        if post_evo.name.include? "alolan"
          evo.evo_to = post_evo.name
        end
        ### is this alolan?
        # binding.pry
      ####################################################
      ####### jump to galar forms ########################
      ####################################################
      elsif evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.include? "-g"
        # binding.pry
        poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i

        if AlternateForm.find_by(pokedex_number:poke_num)
          post_evo = AlternateForm.find_by(pokedex_number:poke_num)
          if post_evo.name.include? "galarian"
            post_evo = AlternateForm.find_by(name:post_evo.name)
          else 
            post_evo = "galarian_" + post_evo.name.split("_").last
            post_evo = AlternateForm.find_by(name:post_evo)
          end
        else 
          post_evo = Pokemon.find_by(pokedex_number:poke_num)
          post_evo = "galarian_" + post_evo.name
          post_evo = AlternateForm.find_by(name:post_evo)
        end
        evo.evo_to = post_evo.name

      else
        poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(17,3).join.to_i

        if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.include? "sword"
          if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.include? "-a"
            poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
            alolan = true 
          else
            poke_num = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.split("").slice(21,3).join.to_i
          end
        end

        if alolan
          post_evo = AlternateForm.find_by(pokedex_number:poke_num)
          evo.evo_to = post_evo.name
        else
          post_evo = Pokemon.find_by(pokedex_number:poke_num)
          evo.evo_to = post_evo.name
        end
      end

    else 
      post_evo_name = evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["alt"].value.downcase.split(" ").join("_")
      # binding.pry

      if post_evo_name.include? "-"
        post_evo_name = post_evo_name.split("-").join("_")
      end

      if post_evo_name.include? "mr. mime"
        post_evo_name = "mr_mime"
      end

      if post_evo_name.include? "mega_kyogre"
        post_evo_name = "kyogre_primal"
      end
      
      if post_evo_name.include? "mega_groudon"
        post_evo_name = "groudon_primal"
      end

      if post_evo_name.include? "darmanitan"
        post_evo_name = "darmanitan_standard"
      end

      if post_evo_name.include? "flab"
        post_evo_name = "flabebe"
      end

      if post_evo_name.include? "meowstic"
        post_evo_name = "meowstic_male"
      end

      if post_evo_name.include? "aegislash"
        post_evo_name = "aegislash_shield"
      end

      if post_evo_name.include? "gourgeist"
        post_evo_name = "gourgeist_average"
      end

      if post_evo_name.include? "mega_necrozma"
        post_evo_name = "necrozma_ultra"
      end

      if post_evo_name.include? "mega_necrozma"
        post_evo_name = "necrozma_ultra"
      end

      if post_evo_name.include? "porygon2"
        post_evo_name = "porygon2"
      end

      if post_evo_name.include? "porygon-z"
        post_evo_name = "porygon_z"
      end

      # binding.pry
      if post_evo_name.include? "gigantamax_urshifu"
        if evo_doc.css("tr")[curr_tr].css("td")[curr_td+2].css("img")[0].attributes["src"].value.include? "-rgi"
          post_evo_name = "gigantamax_urshifu_rapid_strike_style"
        else 
          post_evo_name = "gigantamax_urshifu_single_strike_style"
        end
      end

      # binding.pry
      if Pokemon.find_by(name:post_evo_name) != nil
        post_evo = Pokemon.find_by(name:post_evo_name)
        evo.evo_to = post_evo.name
      else
        # binding.pry
        post_evo = AlternateForm.find_by(name:post_evo_name)
        evo.evo_to = post_evo.name
      end
      # binding.pry
    end

    # binding.pry

    ##############################################
    ## is pokemon already in dict? ###############
    # binding.pry
    if poke_in_dict[pre_evo.name] != nil

      ### is this evo already in dict?
      if poke_in_dict[pre_evo.name].include? post_evo.name
        next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+4]
        # binding.pry
        if next_evo == nil
          poke_in_dict = evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
        else
          poke_in_dict = evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)
        end

        return poke_in_dict
      end
    end

    # binding.pry
    #################################################
    ## if a new poke add evo_when and save evo ######
    if evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"] == nil
      evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["title"].value.strip.downcase
      evo.evo_when = evo_when
    else 
      evo_when = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["alt"].value.strip.downcase
      evo.evo_when = evo_when
    end

    if evo_when.include? "level"
      at_level = evo_doc.css("tr")[curr_tr].css("td")[curr_td+1].css("img")[0].attributes["src"].value.split("/")[1].split(".")[0].split("")
      at_level.shift
      at_level = at_level.join("")
      evo_when = evo_when + " " + at_level
      evo.evo_when = evo_when
    end

    evo.save()

    # binding.pry

    ################################################
    ## is this a new pokemon then create key #######
    if poke_in_dict[pre_evo.name] == nil
      poke_in_dict[pre_evo.name] = [post_evo.name]

    ### is this an existing pokemon with a new evo
    else
      poke_in_dict[pre_evo.name].push(post_evo.name)
    end

    # binding.pry
    ###############################################
    ## is there a next evo ? ######################
    next_evo = evo_doc.css("tr")[curr_tr].css("td")[curr_td+4]

    if next_evo == nil
      # binding.pry
      evo_chain_maker(curr_tr+1, 0, prev_tr, prev_td, evo_doc, poke_in_dict)
    else
      # binding.pry
      evo_chain_maker(curr_tr, curr_td+2, prev_tr, prev_td, evo_doc, poke_in_dict)
    end

    # binding.pry

    # poke_in_dict
  end

  # binding.pry
  poke_in_dict
end

def evo_chain_runner(start, last, name, poke_in_dict)
  
  start = 1
  if name == nil
    poke_in_dict = {}
    while start <= last
      puts "https://serebii.net/pokedex-sm/#{num_conversion(start)}.shtml"
      
      poke_html = open("https://serebii.net/pokedex-sm/#{num_conversion(start)}.shtml")
      poke_doc = Nokogiri::HTML(poke_html)
      evo_table = poke_doc.css(".evochain")

      #####################################
      #### Set timeout Go Brrrrr ##########
      #####################################
      counter = 0
      if start % 100 == 0
        # binding.pry
        arbitrary_counter = 0
        while arbitrary_counter < 300000000
          # binding.pry
          if counter % 2 == 0
            arbitrary_counter += 1
          end
          counter += 1
        end
      end

      if start == 122 || start == 439 || start == 83
        start += 1
        next
      end

      poke_in_dict = evo_chain_maker(0, 0, nil, nil, evo_table, poke_in_dict)
      # puts poke_in_dict
      # binding.pry

      start += 1
    end
  ### galar region evo chain creator
  else
    puts "https://serebii.net/pokedex-swsh/#{name}/"

    poke_html = open("https://serebii.net/pokedex-swsh/#{name}/")
    poke_doc = Nokogiri::HTML(poke_html)
    evo_table = poke_doc.css(".evochain")

    poke_in_dict = evo_chain_maker(0, 0, nil, nil, evo_table, poke_in_dict)
    # binding.pry

  end

  return poke_in_dict
end

def evo_chain_fixer
  poke_list = Pokemon.all + AlternateForm.all
  poke_list = poke_list.sort_by{|pokemon| pokemon.pokedex_number
  }

  poke_list.each { |curr_pokemon|
    ## is the curr_pokemon in the Pokemon table?
    if curr_pokemon.class == Pokemon
      # binding.pry
      puts "curr mon " + curr_pokemon.name
      curr_pokemon.evolutions.each { |next_evo|
        next_poke = Pokemon.find_by(name:next_evo.evo_to) 
        ## Are we in the pokemon table
        if next_poke
          ## do we have an evolution set?
          if next_poke.evolutions.length == 0
            ## no so we create the connection here
            evo = Evolution.new()
            evo.pokemon_id = next_poke.id
            evo.evo_from = curr_pokemon.name
            evo.save()
            ## move on to the next evo
            next
          end
          ## fix all evolutions to point at current pokemon
          next_poke.evolutions.each { |evo_to_fix|
            ## have we already fixed this evo?
            if evo_to_fix.evo_from == nil
              ## update and save evo
              evo_to_fix.evo_from = curr_pokemon.name
              evo_to_fix.save()
            end
          }
        else 
          ## the next pokemon is an Alternate Form
          # binding.pry
          next_poke = AlternateForm.find_by(name:next_evo.evo_to)
          if next_poke == nil
            next
          end
          puts "next poke " + next_poke.name
          if next_poke.alternate_form_evos.length == 0
            ## no so we create the connection here
            evo = AlternateFormEvo.new()
            evo.alternate_form_id = next_poke.id
            evo.evo_from = curr_pokemon.name
            evo.save()
            ## move on to the next evo
            next
          end
          ## fix all evolutions to point at current pokemon
          next_poke.alternate_form_evos.each { |evo_to_fix|
            ## have we already fixed this evo?
            if evo_to_fix.evo_from == nil
              ## update and save evo
              evo_to_fix.evo_from = curr_pokemon.name
              evo_to_fix.save()
            end
          }
        end
      }
    ## the curr_pokemon is in the Alternate Form table
    else
      # binding.pry
      puts "curr mon " + curr_pokemon.name
      ## find the pokemon we evolve to and access that pokemon
      curr_pokemon.alternate_form_evos.each { |next_evo|
        next_poke = Pokemon.find_by(name:next_evo.evo_to) 
        ## are we in the Pokemon table?
        if next_poke
           ## do we have an evolution set?
          if next_poke.evolutions.length == 0
            ## no so we create the connection here
            evo = Evolution.new()
            evo.pokemon_id = next_poke.id
            evo.evo_from = curr_pokemon.name
            evo.save()
            ## move on to the next evo
            next
          end
          ## fix all evolutions to point at current pokemon
          next_poke.evolutions.each { |evo_to_fix|
            ## have we already fixed this evo?
            if evo_to_fix.evo_from == nil
              ## update and save evo
              evo_to_fix.evo_from = curr_pokemon.name
              evo_to_fix.save()
            end
          }
          ## Alternate Form to Normal Pokemon Evo Fix Above ##
        else 
          ## Alternate Form to Alternate Form Pokemon Evo Fix Below ##
          next_poke = AlternateForm.find_by(name:next_evo.evo_to)
          ## do we have evolutions set?
          if next_poke.alternate_form_evos.length == 0
            ## no so we create the connection here
            evo = AlternateFormEvo.new()
            evo.alternate_form_id = next_poke.id
            evo.evo_from = curr_pokemon.name
            evo.save()
            ## move on to the next evo
            next
          end
          ## fix all evolutions to point at current pokemon
          next_poke.alternate_form_evos.each { |evo_to_fix|
            ## have we already fixed this evo?
            if evo_to_fix.evo_from == nil
              ## update and save evo
              evo_to_fix.evo_from = curr_pokemon.name
              evo_to_fix.save()
            end
          }
        end
      }
    end
  }

end

def pokemon_database_runner(melmetal)
  ### call type creator
  type_list = ["grass","water","fire","normal","electric","ice","fighting","poison","ground","flying","psychic","bug","rock","ghost","dragon","dark","steel","fairy"]
  create_types(type_list)

  # ### call region creator
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

  meltan = Pokemon.create(melmetal[0][:stats])
  
  meltan_sprites = Sprite.new(melmetal[0][:sprites])
  meltan_sprites.pokemon_id = meltan.id
  meltan_sprites.save

  meltan_region = PokemonRegion.new(melmetal[0][:region])
  meltan_region.pokemon_id = meltan.id
  meltan_region.save

  meltan_type = PokemonType.new(melmetal[0][:type])
  meltan_type.pokemon_id = meltan.id
  meltan_type.save

  meltan_abilities = PokemonAbility.new(melmetal[0][:abilities])
  meltan_abilities.pokemon_id = meltan.id
  meltan_abilities.save

  ## melmetal
  metal = Pokemon.create(melmetal[1][:stats])
  
  metal_sprites = Sprite.new(melmetal[1][:sprites])
  metal_sprites.pokemon_id = metal.id
  metal_sprites.save

  metal_region = PokemonRegion.new(melmetal[1][:region])
  metal_region.pokemon_id = metal.id
  metal_region.save

  metal_type = PokemonType.new(melmetal[1][:type])
  metal_type.pokemon_id = metal.id
  metal_type.save

  metal_abilities = PokemonAbility.new(melmetal[1][:abilities])
  metal_abilities.pokemon_id = metal.id
  metal_abilities.save

  evo = Evolution.new()
  evo.pokemon_id = meltan.id
  evo.evo_to = metal.name
  evo.evo_when = "400 candies in Pokemon Go"
  evo.save()

  evo1 = Evolution.new()
  evo1.pokemon_id = metal.id
  evo1.evo_from = meltan.name
  evo1.save()

  # binding.pry

  # # Grabs the first 7 generations alternate forms: including Megas/Region Variant etc. 
  pokemon_results_arr = pokemon_api_caller("https://pokeapi.co/api/v2/pokemon/?offset=893&limit=500")
    
  pokemon_results_arr.each do |pokemon|
      poke = create_pokemon(url_caller(pokemon["url"]), true)
  end

  # ############################################################
  # ### Lets you build an evo chain from pokemon range given ### 
  # ############################################################
  poke_in_dict = {}
  poke_in_dict = evo_chain_runner(1,809,nil, nil)

  # binding.pry

  Galar Region Unique Pokemon
  galar_list_base_url = "https://serebii.net/swordshield/pokemon.shtml"
  galar_html = open(galar_list_base_url)
  galar_doc = Nokogiri::HTML(galar_html)
  ## Galar Unique Pokemon name scraper
  count1 = 2
  zac_count = 1

  while count1 <= 188
    poke_name = galar_doc.css(".tab").css("tr")[count1].css(".fooinfo")[2].text.split(" ")[0]
    poke_name = /[a-zA-z]*/.match(poke_name)
    poke_name = poke_name.to_s.downcase
    # binding.pry

    if poke_name.include? "mr"
      poke_name = "mr.rime"
    end

    if poke_name.include? "sir"
      poke_name = "sirfetch'd"
    end

    galar_poke_html = open("https://serebii.net/pokedex-swsh/#{poke_name}/")
    galar_poke_doc = Nokogiri::HTML(galar_poke_html)
    ab_doc = galar_doc.css("tr")[count1].css(".fooinfo")[4].css("a")

    if poke_name.include? "zacian"
      if zac_count == 1
        create_zac_zam(galar_poke_doc)
        zac_count = zac_count + 1
        # binding.pry
      else
        # binding.pry
        new_create_alternate_form(galar_poke_doc,ab_doc,poke_name)
        zac_count += 1
      end
    elsif poke_name.include? "zamazenta" 
      if zac_count == 3
        create_zac_zam(galar_poke_doc)
        zac_count = zac_count + 1
        # binding.pry
      else
        # binding.pry
        new_create_alternate_form(galar_poke_doc,ab_doc,poke_name)
        zac_count += 1
      end  
    elsif poke_name.include? "urshifu"
      if zac_count == 5
        create_urshifu_single(galar_poke_doc)
        # binding.pry
        zac_count += 1
      else
        create_urshifu_rapid(galar_poke_doc)
      end
    else
      new_create_pokemon(galar_poke_doc)
    end
    count1 += 2
  end

  # binding.pry

  ### serebii alternate form pokemon scraper test
  count = 32
  stop = 38

  while count <= 38
    ## alternate form ability scraper
    ability_base_url = "https://serebii.net/swordshield/galarianforms.shtml"
    ab_html = open(ability_base_url)
    ab_doc = Nokogiri::HTML(ab_html)
    ## alternate form name scraper
    poke_name = ab_doc.css("tr")[count].css(".fooinfo")[2].text.split(" ")[0]
    ## alternate form ability array
    ab_doc = ab_doc.css("tr")[count].css(".fooinfo")[4].css("a")

    ## find alternate form by name
    poke_name = /[a-zA-z]*/.match(poke_name)
    poke_name = poke_name.to_s.downcase
    # binding.pry
    if poke_name.include? "mr"
      poke_name = "mr.mime"
    end

    if poke_name.include? "far"
      poke_name = "farfetch'd"
    end

    puts base_url = "https://serebii.net/pokedex-swsh/#{poke_name}/"
    
    ### search pokemon by number
    html = open(base_url)
    doc = Nokogiri::HTML(html)

    ### send serebii data to create Pokemon function
    new_create_alternate_form(doc, ab_doc, poke_name)    
    count += 2
  end
  
  # binding.pry

  ## serebii gigantamax form scraper
  gigantamax_list_base_url = "https://serebii.net/swordshield/gigantamax.shtml"
  gigantamax_html = open(gigantamax_list_base_url)
  gigantamax_doc = Nokogiri::HTML(gigantamax_html)

  count = 1
  stop = 65
  urshi_counter = 0

  while count <= stop
    ## gigantamax form name scraper
    poke_name = gigantamax_doc.css("tr")[count].css(".fooinfo")[2].text.split(" ")[0]

    ## find alternate form by name
    poke_name = /[a-zA-z]*/.match(poke_name)
    poke_name = poke_name.to_s.downcase
    # binding.pry
    if poke_name.include? "mr"
      poke_name = "mr.mime"
    end

    if poke_name.include? "far"
      poke_name = "farfetch'd"
    end

    puts base_url = "https://serebii.net/pokedex-swsh/#{poke_name}/"

    if poke_name.include? "urshifu"
      urshi_counter += 1
      if urshi_counter == 1
        poke_name = "urshifu_single_strike_style"
      else
        poke_name = "urshifu_rapid_strike_style"
      end
    end

    
    ### search pokemon by number
    html = open(base_url)
    doc = Nokogiri::HTML(html)

    ### send serebii data to create Pokemon function
    new_create_gigantamax_form(doc, poke_name)    
    count += 2
  end

  # binding.pry

  ##################################################
  ### the final frontier Galar Pokemon Evo Chain ###
  ##################################################
  # binding.pry
  galar_evo_list_base_url = "https://www.serebii.net/swordshield/pokemon.shtml"
  galar_evo_html = open(galar_evo_list_base_url)
  galar_evo_doc = Nokogiri::HTML(galar_evo_html)

  ### jump to counter
  count2 = 2
  stop = 188
  urshi_counter = 0

  while count2 <= stop
    poke_name = galar_evo_doc.css(".tab").css("tr")[count2].css(".fooinfo")[2].text.split(" ")[0]
    poke_name = /[a-zA-z]*/.match(poke_name)
    poke_name = poke_name.to_s.downcase
    # binding.pry

    if poke_name.include? "mr"
      poke_name = "mr.rime"
    end

    if poke_name.include? "mime"
      poke_name = "mr.mime"
    end

    if poke_name.include? "sir"
      poke_name = "sirfetch'd"
    end

    if poke_name.include? "far"
      poke_name = "farfetch'd"
    end

    ###########################################
    ##### Search Gen 8 By Name ################
    ###########################################
    puts poke_name

    if count2 == 174 || count2 == 176
      count2 += 4
      next
    end

    poke_in_dict = evo_chain_runner(1,2, poke_name,poke_in_dict)

    # binding.pry
    
    count2 += 2
  end

  # binding.pry
  evo_chain_fixer()
  
end

pokemon_database_runner(melMetalArr)