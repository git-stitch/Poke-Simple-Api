count = 0
# Regions Table Import
CSV.foreach('regions_table.csv') do |row|  
  # Skips Header Row
  if count == 0 
    count = 1
    next
  end

  data = {
    name: row[1]
  }

  region = Region.new(data)

  # puts region.name
  region.save
end

# Import the Types Table
count = 0
CSV.foreach('types_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    name: row[1]
  }

  type = Type.new(data)

  # puts type.name 
  type.save
end

# Import Abilities Table
count = 0
CSV.foreach('abilities_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    name: row[1],
    description: row[2],
    short_description: row[3]
  }

  ability = Ability.new(data)

  ability.save
end

# Import Pokemon Table
count = 0
CSV.foreach('pokemons_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    name: row[1],
    pokemon_entry: row[2],
    pokedex_number: row[3],
    hp: row[4],
    attack: row[5],
    defense: row[6],
    special_attack: row[7],
    special_defense: row[8],
    speed: row[9],
    height: row[10],
    weight: row[11]
  }

  # puts data
  # puts " "

  pokemon = Pokemon.new(data)

  pokemon.save
end

# Import Alternate Form Table
count = 0
CSV.foreach('alternate_forms_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    pokemon_id: row[1],
    name: row[2],
    pokemon_entry: row[3],
    pokedex_number: row[4],
    hp: row[5],
    attack: row[6],
    defense: row[7],
    special_attack: row[8],
    special_defense: row[9],
    speed: row[10],
    height: row[11],
    weight: row[12],
    is_mega: row[13],
    is_gigantimax: row[14]
  }

  # puts data
  # puts " "

  alternate_form = AlternateForm.new(data)

  alternate_form.save
end

# Import Pokemon Types Table
count = 0
CSV.foreach('pokemon_types_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    pokemon_id: row[1],
    type_id: row[2]
  }

  # puts data
  # puts " "

  poke_type = PokemonType.new(data)

  poke_type.save
end

# Import Pokemon Abilities Table
count = 0
CSV.foreach('pokemon_abilities_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    pokemon_id: row[1],
    ability_id: row[2],
    is_hidden: row[3]
  }

  # puts data
  # puts " "

  poke_ability = PokemonAbility.new(data)

  poke_ability.save
end

# Import Pokemon Regions Table
count = 0
CSV.foreach('pokemon_regions_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    region_id: row[1],
    pokemon_id: row[2]
  }

  puts data
  puts " "

  # if count == 10 
  #   return
  # end
  poke_region = PokemonRegion.new(data)

  poke_region.save
  # count = count + 1
end

# Import Evolutions Table
count = 0
CSV.foreach('evolutions_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    pokemon_id: row[1],
    evo_to: row[2],
    evo_when: row[3],
    evo_from: row[4]
  }

  # puts data
  # puts " "

  # if count == 10 
  #   return
  # end

  poke_evo = Evolution.new(data)

  poke_evo.save
  # count += 1
end

# Import Alternate Form Types Table
count = 0
CSV.foreach('alternate_form_types_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    alternate_form_id: row[1],
    type_id: row[2]
  }

  # puts data
  # puts " "

  # if count == 10
  #   return
  # end

  alternate_form_type = AlternateFormType.new(data)

  alternate_form_type.save
  # count += 1
end

# Import Alternate Form Abilities Table
count = 0
CSV.foreach('alternate_form_abilities_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    alternate_form_id: row[1],
    ability_id: row[2],
    is_hidden: row[3]
  }

  # puts data
  # puts " "

  # if count == 10
  #   return
  # end

  alternate_form_ability = AlternateFormAbility.new(data)

  alternate_form_ability.save
  # count += 1
end

# Import Alternate Form Regions Table
count = 0
CSV.foreach('alternate_form_regions_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    alternate_form_id: row[1],
    region_id: row[2]
  }

  # puts data
  # puts " "

  # if count == 10 
  #   return
  # end

  alternate_form_region = AlternateRegion.new(data)

  alternate_form_region.save
  # count += 1
end

# Import the Sprites Table
count = 0
CSV.foreach('sprites_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    pokemon_id: row[1],
    back_default: row[2],
    back_female: row[3],
    back_shiny: row[4],
    back_shiny_female: row[5],
    front_default: row[6],
    front_female: row[7],
    front_shiny: row[8],
    front_shiny_female: row[9],
    gen_eight_front_default: row[10],
    gen_eight_front_shiny: row[11]
  }

  puts data
  puts " "

  # if count == 10
  #   return
  # end

  sprite = Sprite.new(data)

  sprite.save

  # count += 1
end

# Import Alternate Form Sprite Table
CSV.foreach('alternate_form_sprites_table.csv') do |row|
  if count == 0
    count = 1
    next
  end

  data = {
    alternate_form_id: row[1],
    back_default: row[2],
    back_female: row[3],
    back_shiny: row[4],
    back_shiny_female: row[5],
    front_default: row[6],
    front_female: row[7],
    front_shiny: row[8],
    front_shiny_female: row[9],
    gen_eight_front_default: row[10],
    gen_eight_front_shiny: row[11]
  }

  # puts count

  puts data 
  puts " "

  # if count == 10 
  #   return
  # end

  alternate_sprite = AlternateFormSprite.new(data)

  alternate_sprite.save

  # count += 1 
end