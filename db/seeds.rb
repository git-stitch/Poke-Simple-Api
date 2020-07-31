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

### Galarian Pokemon Array for Manual Import =(
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

def create_zac_zam(site_data)
  new_pokemon = Pokemon.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #name
  name = first_dexTab.split(" ")[1].downcase
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
    front_default: "https://serebii.net/swordshield/pokemon/#{pokedex_number}.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{pokedex_number}.png"
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

def create_urshifu_single(site_data)
  new_pokemon = Pokemon.new()

  ### grabs the name and dex number from top row
  first_dexTab = site_data.css(".dextab").at_css("h1").children.text
  
  #pokedex number
  pokedex_number = first_dexTab.split(" ")[0][2..-1].to_i
  new_pokemon.pokedex_number = pokedex_number
  
  #name
  name = first_dexTab.split(" ")[1].downcase
  new_pokemon.name = name + "-single-strike-style"

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
    front_default: "https://serebii.net/swordshield/pokemon/#{pokedex_number}.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{pokedex_number}.png"
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
  new_pokemon.name = name + "-rapid-strike-style"

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
    front_default: "https://serebii.net/swordshield/pokemon/#{pokedex_number}-r.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{pokedex_number}-r.png"
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
  name = first_dexTab.split(" ")[1].downcase
  new_pokemon.name = name

  if name.include? "mr"
    new_pokemon.name = "mr-rime"
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
    front_default: "https://serebii.net/swordshield/pokemon/#{pokedex_number}.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{pokedex_number}.png"
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
  name = first_dexTab.split(" ")[1].downcase
  new_pokemon.name = "galarian "+name

  if fix_name.include? "mr"
    name = "mr-mime"
    new_pokemon.name = "galarian "+name
  end

  if fix_name.include? "far"
    name = "farfetchd"
    new_pokemon.name = "galarian "+name
  end

  if fix_name.include? "zacian"
    name = "zacian-crowned-sword"
    new_pokemon.name = name
  end

  if fix_name.include? "zamazenta"
    name = "zamazenta-crowned-sword"
    new_pokemon.name = name
  end

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
    front_default: "https://serebii.net/swordshield/pokemon/#{pokedex_number}.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{pokedex_number}.png"
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
  new_pokemon.name = "gigantamax "+name

  if fix_name.include? "mr"
    name = "mr-mime"
    new_pokemon.name = "gigantamax "+name
  end

  if fix_name.include? "far"
    name = "farfetchd"
    new_pokemon.name = "gigantamax "+name
  end

  ##find original pokemon
  if fix_name.include? "urshifu-single-strike-style"

    original_pokemon = Pokemon.find_by(name:"urshifu-single-strike-style")

    new_pokemon.name = "gigantamax "+"urshifu-single-strike-style"

    new_pokemon.pokemon_id = original_pokemon.id
  elsif fix_name.include? "urshifu-rapid-strike-style"

    original_pokemon = Pokemon.find_by(name:"urshifu-rapid-strike-style")

    new_pokemon.name = "gigantamax "+"urshifu-rapid-strike-style"

    new_pokemon.pokemon_id = original_pokemon.id
  else
    original_pokemon = Pokemon.find_by(pokedex_number:new_pokemon.pokedex_number)
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
    front_default: "https://serebii.net/swordshield/pokemon/#{pokedex_number}-gi.png",
    front_shiny: "https://serebii.net/Shiny/SWSH/#{pokedex_number}-gi.png"
  )

  ## pokemon region
  pr = AlternateRegion.create(alternate_form_id:new_pokemon.id, region_id:8)

  # binding.pry

end

def evo_chain_creator(evo_doc)
  poke_in_dict = {}

  if evo_doc[0].css("tr").length == 1
    evo_type = "line"
    ##runs through td on this tr
    start = 0
    stop = evo_doc.css("tr")[0].css("td").length - 2
    evo_done = false
    poke1 = {}
    poke2 = {}
    evo_when = ""

    while start < stop
      pre_evo_name = evo_doc.css("tr")[0].css("td")[start].css("img")[0].attributes["alt"].value.downcase
      
      pre_evo = Pokemon.find_by(name:pre_evo_name)

      if pre_evo == nil
        pre_evo = AlternateForm.find_by(name:pre_evo_name)
      end

      post_evo_name = evo_doc.css("tr")[0].css("td")[start+2].css("img")[0].attributes["alt"].value.downcase
      
      post_evo = Pokemon.find_by(name:post_evo_name)

      if post_evo == nil
        post_evo = AlternateForm.find_by(name:post_evo_name)
      end

      evo_when = evo_doc.css("tr")[0].css("td")[start+1].css("img")[0].attributes["alt"].value.strip.downcase

      if evo_when.include? "level"
        at_level = evo_doc.css("tr")[0].css("td")[start].css("img")[0].attributes["src"].value.split("/")[1].split(".")[0].split("")
        at_level.shift
        at_level = at_level.join("")
        evo_when = evo_when + " " + at_level
      end

      binding.pry
      Evolution.new(pokemon_id:pre_evo.id, evo_when:evo_when, evo_to:post_evo.name)

      ## put evo in dict
      poke_in_dict[pre_evo.name] = [post_evo.name]

      # if start.even?
      #   ## find poke name
      #   poke_name = evo_doc.css("tr")[0].css("td")[start].css("img")[0].attributes["alt"].value.downcase
      #   poke = Pokemon.find_by(name:poke_name)

      #   if evo_done
      #     poke2 = Pokemon.find_by(name:poke_name)

      #     ## create evolution
      #     Evolution.new(pokemon_id:poke1.id, evo_when:evo_when, evo_to:poke2.name)

      #     ## put evo in dict
      #     poke_in_dict[poke1.name] = [poke2.name]

      #     ## reset
      #     evo_done = false
      #     poke1 = poke2
      #     poke2 = {}
      #   else
      #     poke1 = Pokemon.find_by(name:poke_name)
      #     # binding.pry
      #   end

      # elsif start.odd?
      #   ## find evo_when and see if its a level based one
      #   evo_when = evo_doc.css("tr")[0].css("td")[start].css("img")[0].attributes["alt"].value.strip.downcase

      #   if evo_when.include? "level"
      #     at_level = evo_doc.css("tr")[0].css("td")[start].css("img")[0].attributes["src"].value.split("/")[1].split(".")[0].split("")
      #     at_level.shift
      #     at_level = at_level.join("")
      #     evo_when = evo_when + " " + at_level

      #     evo_done = true
      #   end
      # end

      binding.pry
      start += 2
    end


  elsif evo_doc[0].css("tr").length > 1 && evo_doc[0].css("tr").children[0].attributes["colspan"] != nil
    evo_type = "multi-form"

  elsif evo_doc[0].css("tr").length > 1 && evo_doc[0].css("tr").children[0].attributes["rowspan"] != nil
    evo_type = "branching"

  else
    evo_type = "alternate-forms"

  end

  binding.pry
 
end

def evo_chain_runner(start, last)

  start = 1
  while start <= last
    puts "https://serebii.net/pokedex-sm/#{num_conversion(start)}.shtml"

    poke_html = open("https://serebii.net/pokedex-sm/#{num_conversion(start)}.shtml")
    poke_doc = Nokogiri::HTML(poke_html)
    evo_table = poke_doc.css(".evochain")

    evo_chain_creator(evo_table)
    binding.pry

    start += 1
  end
end

def pokemon_database_runner(melmetal)
  ### call type creator
  type_list = ["grass","water","fire","normal","electric","ice","fighting","poison","ground","flying","psychic","bug","rock","ghost","dragon","dark","steel","fairy"]
  # create_types(type_list)

  ### call region creator
  region_list = ["kanto","johto","hoenn","sinnoh","unova","kalos","alola","galar"]
  # create_regions(region_list)

  ### call ability creator
  # ability_results_arr = pokemon_api_caller("https://pokeapi.co/api/v2/ability/?offset=0&limit=293")
  # ability_results_arr.each do |ability|
  #   abil = create_abilities(url_caller(ability["url"]))
  # end

  # Grabs the first 7 generations of pokemon without alternate forms
  # pokemon_results_arr = pokemon_api_caller("https://pokeapi.co/api/v2/pokemon/?offset=0&limit=807")
    
  # pokemon_results_arr.each do |pokemon|
  #     poke = create_pokemon(url_caller(pokemon["url"]), false)
  # end

  # meltan = Pokemon.create(melmetal[0][:stats])
  
  # meltan_sprites = Sprite.new(melmetal[0][:sprites])
  # meltan_sprites.pokemon_id = meltan.id
  # meltan_sprites.save

  # meltan_region = PokemonRegion.new(melmetal[0][:region])
  # meltan_region.pokemon_id = meltan.id
  # meltan_region.save

  # meltan_type = PokemonType.new(melmetal[0][:type])
  # meltan_type.pokemon_id = meltan.id
  # meltan_type.save

  # meltan_abilities = PokemonAbility.new(melmetal[0][:abilities])
  # meltan_abilities.pokemon_id = meltan.id
  # meltan_abilities.save

  ## melmetal
  # metal = Pokemon.create(melmetal[1][:stats])
  
  # metal_sprites = Sprite.new(melmetal[1][:sprites])
  # metal_sprites.pokemon_id = metal.id
  # metal_sprites.save

  # metal_region = PokemonRegion.new(melmetal[1][:region])
  # metal_region.pokemon_id = metal.id
  # metal_region.save

  # metal_type = PokemonType.new(melmetal[1][:type])
  # metal_type.pokemon_id = metal.id
  # metal_type.save

  # metal_abilities = PokemonAbility.new(melmetal[1][:abilities])
  # metal_abilities.pokemon_id = metal.id
  # metal_abilities.save

  # binding.pry

  # Grabs the first 7 generations alternate forms: including Megas/Region Variant etc. 
  # pokemon_results_arr = pokemon_api_caller("https://pokeapi.co/api/v2/pokemon/?offset=807&limit=500")
    
  # pokemon_results_arr.each do |pokemon|
  #     poke = create_pokemon(url_caller(pokemon["url"]), true)
  # end

  ### Lets you build an evo chain from pokemon range given 
  evo_chain_runner(1,810)

  binding.pry

  ## Galar Region Unique Pokemon
  galar_list_base_url = "https://serebii.net/swordshield/pokemon.shtml"
  galar_html = open(galar_list_base_url)
  galar_doc = Nokogiri::HTML(galar_html)
  ## Galar Unique Pokemon name scraper
  count1 = 2
  zac_count = 1

  while count1 <= 180 
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
  count = 2
  stop = 30

  while count <= 30
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
    # new_create_pokemon(doc)
    new_create_alternate_form(doc, ab_doc, poke_name)    
    count += 2
  end
  

  ### serebii gigantamax form scraper
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
        poke_name = "urshifu-single-strike-style"
      else
        poke_name = "urshifu-rapid-strike-style"
      end
    end

    
    ### search pokemon by number
    html = open(base_url)
    doc = Nokogiri::HTML(html)

    ### send serebii data to create Pokemon function
    new_create_gigantamax_form(doc, poke_name)    
    count += 2
  end
  binding.pry
end

pokemon_database_runner(melMetalArr)